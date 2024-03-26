/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Manage the User Action Form
 *
 * @constructor
 * @param form {Prime.Document.Element} the form
 */
FusionAuth.Admin.UserActioningForm = function(form) {
  Prime.Utils.bindAll(this);

  this.form = form;
  this._setupListeners();
};

FusionAuth.Admin.UserActioningForm.constructor = FusionAuth.Admin.UserActioningForm;

FusionAuth.Admin.UserActioningForm.prototype = {

  _handleActionSelectChangeEvent: function() {
    var selectedValue = this.actionSelect.getSelectedValues()[0];
    var nothingSelected = selectedValue === '';

    if (nothingSelected) {
      this.form.queryFirst('[data-dependant-controls]').addClass('disabled');
      this.expirationControls.hide();
    } else {
      this.form.queryFirst('[data-dependant-controls]').removeClass('disabled');
    }

    this.form.query('.action-options').each(function(e) {
      e.hide().queryFirst('select').setDisabled(true);
    });

    var selectedOption = new Prime.Document.Element(this.actionSelect.domElement.selectedOptions[0]);
    var optionDataSet = selectedOption.getDataSet();

    // If emailing is enabled, handle the checkbox show-hide
    if (this.emailCheckbox !== null) {
      if (optionDataSet.useremailingenabled === 'true') {
        this.emailCheckbox.show();
      } else {
        this.emailCheckbox.hide();
      }
    }

    if (optionDataSet.temporal === 'false') {
      var optionContainer = this.form.queryFirst('[id="' + selectedValue + '_options"]');
      if (optionContainer !== null) {
        optionContainer.show();
        optionContainer.queryFirst('select').setDisabled(false);
      }
    }

    // Hide the Expiration controls if the action isn't temporal, or if nothing is selected yet.
    if (nothingSelected || optionDataSet.temporal === 'false') {
      this._handleExpiryRadioChangeEvent();
      this.expirationControls.hide().query('select, input').setDisabled(true);

      this.expirationEnabled.setChecked(false);
    } else {
      this.expirationControls.show().query('select, input').setDisabled(false);
      this.expirationEnabled.setChecked(true);
      this.expirationEnabled.fireEvent('change');
    }

    if (optionDataSet.usernotificationsenabled === 'true') {
      this.notifyUserCheckbox.show();
    } else {
      this.notifyUserCheckbox.hide();
    }

    // prevent login affects all applications, 'all applications' should be checked.
    this.preventLoginMessage = Prime.Document.queryById('preventLogin-description');
    if (optionDataSet.preventlogin === 'true') {
      this.allApplicationsCheckbox.setChecked(true);
      this.applicationCheckboxList.query('input:not([value=""])').setDisabled(true);
      this.preventLoginMessage.show();
    } else {
      this.applicationCheckboxList.query('input:not([value=""])').setDisabled(false);
      if (this.applicationCheckboxList.query('input:not([value=""]):checked').length === 0) {
        this.allApplicationsCheckbox.setChecked(true);
      } else {
        this.allApplicationsCheckbox.setChecked(false);
      }

      this.preventLoginMessage.hide();
    }
  },

  _handleApplicationCheckboxClickEvent: function(event) {
    var checkbox = new Prime.Document.Element(event.target);
    if (checkbox.getValue() === '') {
      if (checkbox.isChecked()) {
        // All applications was just checked, uncheck everything else
        this.applicationCheckboxList.query('input:not([value=""])').each(function(e) {
          e.setChecked(!this.allApplicationsCheckbox.isChecked());
        }.bind(this));
      } else {
        // You cannot un-check the all-applications checkbox. You must select a specific application.
        Prime.Utils.stopEvent(event);
      }
    } else if (checkbox.isChecked()) {
      // Something else was checked, uncheck all applications checkbox
      this.allApplicationsCheckbox.setChecked(false);
    } else if (this.applicationCheckboxList.query('input:checked').length === 0) {
      // At least one application must be selected.
      Prime.Utils.stopEvent(event);
    }
  },

  _handleExpiryRadioChangeEvent: function() {
    if (this.expirationEnabled.isChecked()) {
      this.expirationValues.show().queryFirst('input[type="text"]').focus();
    } else {
      this.expirationValues.hide();
    }
  },

  _setupListeners: function() {
    // The Add and Modify dialogs don't have all of the same controls, need to null check a few.
    this.actionSelect = this.form.queryFirst('#action_userActionId');
    if (this.actionSelect !== null) {
      this.actionSelect.addEventListener('change', this._handleActionSelectChangeEvent);
    }
    this.userActionInputs = this.form.queryFirst('#user-action-inputs');

    // Expiration Controls
    this.expirationControls = Prime.Document.queryById('expiration-controls');
    this.expirationEnabled = this.expirationControls.queryFirst('input[name="expires"]').addEventListener('change', this._handleExpiryRadioChangeEvent);
    this.expirationValues = Prime.Document.queryById('expiration-values');

    this.emailCheckbox = this.form.queryFirst('#email-user-checkbox');
    this.notifyUserCheckbox = this.form.queryFirst('#notify-user-checkbox');

    this.applicationCheckboxList = this.form.queryFirst('#action_applicationIds');
    if (this.applicationCheckboxList === null) {
      // Modify Action, no Application Checkbox list exists.
      // TODO ?? Anything to do here?

    } else {
      // Default 'All Applications' to selected.
      this.applicationCheckboxList.queryFirst('input').setChecked(true);
      this.applicationCheckboxList.query('input').each(function(checkbox) {
        checkbox.addEventListener('click', this._handleApplicationCheckboxClickEvent);
      }.bind(this));
      this.allApplicationsCheckbox = this.applicationCheckboxList.queryFirst('#action_applicationIds input[value=""]');
      this._handleActionSelectChangeEvent();
    }
  }
};