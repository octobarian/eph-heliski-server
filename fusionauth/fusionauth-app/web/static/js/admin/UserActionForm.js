/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.UserActionForm = function() {
  Prime.Utils.bindAll(this);

  // Tabs
  this.tabs = new Prime.Widgets.Tabs(Prime.Document.queryFirst('ul.tabs'))
      .withErrorClassHandling('error')
      .initialize();

  // Setup the controls
  this.temporalCheckbox = Prime.Document.queryById('userAction_temporal').addEventListener('change', this._handleTemporalChangeEvent);
  this.userEmailingEnabled = Prime.Document.queryById('userAction_userEmailingEnabled').addEventListener('change', this._handleEmailTemplateClickEvent);
  this.includeEmailInEventJSON = Prime.Document.queryById('userAction_includeEmailInEventJSON').addEventListener('change', this._handleEmailTemplateClickEvent);

  this.timeBasedOptions = Prime.Document.queryById('time-based-options');
  this.preventLogin = Prime.Document.queryFirst('input[name="userAction.preventLogin"]');
  this.sendEndEvent = Prime.Document.queryFirst('input[name="userAction.sendEndEvent"]');

  this.startEmailTemplateFieldSet = Prime.Document.queryById('start-email-template');
  this.timeBaseEmailTemplatesFieldSet = Prime.Document.queryById('time-based-email-templates');

  // Localization table for names
  new FusionAuth.Admin.LocalizationTable(Prime.Document.queryById('localized-names'));

  // Expandable table for options
  Prime.Document.queryById('option-add-button').addEventListener('click', this._handleOptionAddClick);

  this.optionTable = Prime.Document.queryById('option-table');
  this.optionExpandableTable = new FusionAuth.UI.ExpandableTable(this.optionTable);
  this.optionTable.query('td.action a:first-of-type').each(function(e) {
    e.addEventListener('click', this._handleOptionEditClick);
  }.bind(this));

  this._handleTemporalChangeEvent();
};

FusionAuth.Admin.UserActionForm.prototype = {
  _getDataFromOptionForm: function() {
    var form = this.optionDialog.element.queryFirst('form');
    var data = {};
    data.name = form.queryFirst('input[name=name]').getValue();
    data.localizedNames = {};
    form.query('table tbody tr:not(.empty-row)').each(function(row) {
      var locale = row.queryFirst('td select').getSelectedValues()[0];
      data.localizedNames[locale] = row.queryFirst('td input').getValue();
    });
    return data;
  },

  /**
   * @private
   */
  _handleEmailTemplateClickEvent: function() {
    if (this.startEmailTemplateFieldSet === null) {
      return;
    }

    if (this.userEmailingEnabled.isChecked() || this.includeEmailInEventJSON.isChecked()) {
      this.startEmailTemplateFieldSet.show();
      if (this.temporalCheckbox.isChecked()) {
        this.timeBaseEmailTemplatesFieldSet.show();
      } else {
        this.timeBaseEmailTemplatesFieldSet.hide();

        this.timeBaseEmailTemplatesFieldSet.query('select').each(function(select) {
          select.setSelectedValues('');
        });
      }
    } else {
      this.startEmailTemplateFieldSet.hide();
      this.timeBaseEmailTemplatesFieldSet.hide();

      this.startEmailTemplateFieldSet.query('select').each(function(select) {
        select.setSelectedValues('');
      });
      this.timeBaseEmailTemplatesFieldSet.query('input').each(function(select) {
        select.setSelectedValues('');
      });
    }
  },

  /**
   * @private
   */
  _handleOptionAddClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.optionEditRow = null;

    var anchor = new Prime.Document.Element(event.currentTarget);
    this.optionDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleOptionDialogOpenSuccess)
        .withAdditionalClasses('wide')
        .withFormHandling(true)
        .withFormErrorCallback(this._handleOptionDialogOpenSuccess)
        .withFormSuccessCallback(this._handleOptionFormSuccess)
        .open(anchor.getAttribute('href'));
  },

  _handleOptionDialogOpenSuccess: function(dialog) {
    new FusionAuth.Admin.LocalizationTable(dialog.element.queryFirst('table'));
  },

  _handleOptionEditClick: function() {
    Prime.Utils.stopEvent(event);

    var anchor = new Prime.Document.Element(event.currentTarget);
    this.optionEditRow = anchor.queryUp('tr');
    this.optionDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleOptionDialogOpenSuccess)
        .withAdditionalClasses('wide')
        .withFormHandling(true)
        .withFormErrorCallback(this._handleOptionDialogOpenSuccess)
        .withFormSuccessCallback(this._handleOptionFormSuccess)
        .open(anchor.getAttribute('href'));
  },

  _handleOptionFormSuccess: function() {
    var data = this._getDataFromOptionForm();

    var row = null;
    if (this.optionEditRow !== null) {
      this.optionExpandableTable.deleteRow(this.optionEditRow);
    } else {
      this.optionTable.query('tbody tr').each(function(r) {
        if (r.getDataSet().name === data.name) {
          row = r;
        }
      });

      if (row !== null) {
        this.optionExpandableTable.deleteRow(row);
      }
    }

    row = this.optionExpandableTable.addRow(data);
    row.queryFirst('a:first-of-type').addEventListener('click', this._handleOptionEditClick);
    row.getDataSet().name = data.name;

    // Finally close the dialog
    this.optionDialog.close();
  },

  /**
   * @private
   */
  _handleTemporalChangeEvent: function() {
    if (this.temporalCheckbox.isChecked()) {
      this.timeBasedOptions.addClass('open');
      this.sendEndEvent.setDisabled(false);
      this.preventLogin.setDisabled(false);
      this.tabs.hideTab('options');
    } else {
      this.timeBasedOptions.removeClass('open');
      this.sendEndEvent.setDisabled(true);
      this.preventLogin.setDisabled(true);
      this.tabs.showTab('options');
    }

    this._handleEmailTemplateClickEvent();
  }
};
