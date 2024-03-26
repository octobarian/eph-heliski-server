/*
 * Copyright (c) 2020-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit field form.
 *
 * @constructor
 */
FusionAuth.Admin.FieldForm = function() {
  Prime.Utils.bindAll(this);
  this.form = Prime.Document.queryById('field-form');

  // Use a generic selector to get the hidden or select version of the field
  this.selectKey = Prime.Document.queryFirst('[name="field.key"]');
  if (this.selectKey !== null) {
    this.selectKey.addEventListener('change', this._redraw);
  }

  // Consent Id Form Row
  this.consent = Prime.Document.queryFirst('[name="field.consentId"]').queryUp('.form-row');

  // Custom field keys
  this.registrationCustomKey = Prime.Document.queryById('registration-data-key-form-row');
  this.userCustomKey = Prime.Document.queryById('user-data-key-form-row');

  // Form Control
  this.formControl = Prime.Document.queryById('field_control-form-row');
  this.formControlSelect = this.formControl.queryFirst('select');
  if (this.formControlSelect !== null) {
    this.formControlSelect.addEventListener('change', this._redraw);
  }

  // Form Data Type
  this.fieldDataType = Prime.Document.queryById('field_type-form-row');
  this.fieldDataTypeSelect = this.fieldDataType.queryFirst('select');
  // Hidden type is used by consent
  this.hiddenFieldDataType = Prime.Document.queryFirst('input[type="hidden"][name="field.type"]');
  if (this.fieldDataTypeSelect !== null) {
    this.fieldDataTypeSelect.addEventListener('change', this._redraw);
  } else {
    // When the select is not on the page, just use the hidden version, this is the case on the edit form
    this.fieldDataTypeSelect = this.hiddenFieldDataType;
  }

  // Required field
  this.fieldRequired = Prime.Document.queryFirst('[name="field.required"]');

  // Confirm field
  this.confirmValue = Prime.Document.queryById('field_confirm-form-row');
  this.confirmValueCheckbox = this.confirmValue.queryFirst('input');

  // Field Options, used by select, radio, and checkbox
  this.optionsFormRow = Prime.Document.queryById('field-options-form-row');
  new FusionAuth.UI.TextEditor(Prime.Document.queryFirst('textarea[name="options"]'))
      .withOptions({
        'mode': 'properties',
        'lineNumbers': true,
      })
      .render()
      .setHeight(100);

  // Field validation
  this.validatorFieldset = Prime.Document.queryById('field-validator-fieldset');

  this.init();
};

FusionAuth.Admin.FieldForm.constructor = FusionAuth.Admin.FieldForm;
FusionAuth.Admin.FieldForm.prototype = {

  init: function() {
    this.form.query('div.slide-open').each(function(element) {
      if (typeof (element.domElement.slideOpenObject) === 'undefined') {
        element.domElement.slideOpenObject = new Prime.Effects.SlideOpen(element);
      }
    });

    this._redraw();
  },

  _hideContainer: function(div) {
    if (div !== null) {
      if (div.domElement.slideOpenObject) {
        div.domElement.slideOpenObject.close();
      } else {
        div.hide();
      }

      div.query('select,input,textarea')
         .setDisabled(true)
    }
  },

  _isManaged: function(key) {
    return !key.startsWith('user.data.') && !key.startsWith('registration.data.');
  },

  _showContainer: function(div) {
    if (div !== null) {
      if (div.domElement.slideOpenObject) {
        div.domElement.slideOpenObject.open();
      } else {
        div.show();
      }

      div.query('select,input,textarea')
         .setDisabled(false)
    }
  },

  _redraw: function() {

    // Are we on the add form?
    var add = this.selectKey.is('select');

    var key = this.selectKey.getValue();
    var id = key.replace(/\./g, '-') + 'key-form-row';

    // If the generated Id matches a div, show it.
    if (add) {
      if (id === this.userCustomKey.getId()) {
        this._hideContainer(this.registrationCustomKey);
        this._showContainer(this.userCustomKey);
      } else if (id === this.registrationCustomKey.getId()) {
        this._hideContainer(this.userCustomKey);
        this._showContainer(this.registrationCustomKey);
      } else {
        this._hideContainer(this.registrationCustomKey);
        this._hideContainer(this.userCustomKey);
      }
    }

    // Reset disabled state of 'required'
    this.fieldRequired.setDisabled(false);

    if (key === "") {
      // Hide the optional controls and bail.
      this._hideContainer(this.consent);
      this._hideContainer(this.optionsFormRow);
      return;
    }

    // When you select 'Consents' hide everything but the consent selector.
    if (key === 'consents.' || key.startsWith('consents[')) {
      // Show consent and set hidden data type to 'consent'
      this._showContainer(this.consent);
      this.hiddenFieldDataType.setValue('consent').setDisabled(false);

      // Hide form control, options, validation and field data type
      this._hideContainer(this.confirmValue);
      this._hideContainer(this.formControl);
      this._hideContainer(this.fieldDataType);
      this._hideContainer(this.optionsFormRow);
      this._hideContainer(this.validatorFieldset);
      return;
    } else if (this.consent !== null) {
      // Hide the consent stuff for all other keys, and keep the additional field data type hidden, it is just for consents.
      this._hideContainer(this.consent);
      // Ensure that we see the control and datatype when adding
      if (add) {
        this._showContainer(this.formControl);
        this._showContainer(this.fieldDataType);
        this.hiddenFieldDataType.setDisabled(true);
      }
    }

    // Show the confirm value control
    this._showContainer(this.confirmValue);

    // Show the validation controls. If user.password it will be hidden further below.
    this.validatorFieldset.show().query('select,input,textarea').setDisabled(false);

    // If we are setting custom user or registration data, the user can select the form data type and control
    if (key === 'user.data.' || key === 'registration.data.') {
      this._showContainer(this.formControl);
      this._showContainer(this.fieldDataType);
    } else if (this._isManaged(key)) {

      // The field key is a managed value, set to the correct values
      // - All fields are text, except for:
      //   > user.timezone & registration.timezone are 'select'
      //   > user.preferredLanguages & registration.preferredLanguages are 'select'
      //   > registration.roles is 'checkbox'
      //   > user.twoFactorEnabled is 'checkbox'

      // Set the form control
      if (key.endsWith('.preferredLanguages') || key.endsWith('.timezone')) {
        this.formControlSelect.setValue('select').setDisabled(true);
      } else if (key.endsWith('.roles') || key.endsWith('.twoFactorEnabled')) {
        this.formControlSelect.setValue('checkbox').setDisabled(true);
      } else {
        this.formControlSelect.setValue('text').setDisabled(true);
      }

      if (key === 'user.password') {
        this.formControlSelect.setValue('password');
        // must required
        this.fieldRequired.setChecked(true).setDisabled(true);
      }

      // Set data type
      this.fieldDataTypeSelect.setValue('string').setDisabled(true);
      if (key === 'user.birthDate') {
        this.fieldDataTypeSelect.setValue('date');
      } else if (key === 'user.twoFactorEnabled') {
        this.fieldDataTypeSelect.setValue('bool');
      } else if (key === 'user.email') {
        this.fieldDataTypeSelect.setValue('email');
      }
    }

    // Options are allowed for checkbox, radio and select
    var control = this.formControlSelect.getValue();

    // All managed fields have hidden options, even if they are eligible because the options are provided by FusionAuth
    if (this._isManaged(key)) {
      this._hideContainer(this.optionsFormRow);
    } else if (control === 'checkbox' || control === 'radio' || control === 'select') {
      this._showContainer(this.optionsFormRow);
    } else {
      this._hideContainer(this.optionsFormRow);
    }

    // Validation is allowed for Number, Text (except when password) and Textarea
    var dataType = this.formControlSelect.getValue();
    if (dataType !== 'password' && (control === 'number' || control === 'text' || control === 'textarea')) {
      this._showContainer(this.validatorFieldset);
    } else {
      // Disable and turn off validation, close it using some sweet transitions.
      if (this.validatorFieldset.queryFirst('input[type="checkbox"]').isChecked()) {
        this.validatorFieldset.queryFirst('input[type="checkbox"]').fireEvent('click');
      }

      this.validatorFieldset.query('input').setDisabled(true);
    }
  }
};