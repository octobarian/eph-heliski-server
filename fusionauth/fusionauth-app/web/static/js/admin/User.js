/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * JavaScript for the add / edit user page.
 *
 * @param orderedPreferredLanguages {Array} The current ordered list of preferred languages the user has.
 * @constructor
 */
FusionAuth.Admin.User = function(orderedPreferredLanguages) {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('user-form');
  this.passwordFields = Prime.Document.queryById('password-fields');

  this.tenantIdSelect = this.form.queryFirst('select[name="tenantId"]');
  if (this.tenantIdSelect !== null) {
    this.tenantIdSelect.addEventListener('change', this._handleTenantIdChange);
  }

  // Edit User Password Options
  this.editUserPasswordOptions = this.form.queryFirst('select[name="editPasswordOption"]');
  if (this.editUserPasswordOptions !== null) {
    this.editUserPasswordOptions.addEventListener('change', this. _handleEditUserPasswordEvent);
  }

  // Birthdate date picker
  var birthDatePicker = this.form.queryFirst('.date-picker');
  if (birthDatePicker !== null) {
    var birthDateSet = birthDatePicker.getValue().length > 0;
    new Prime.Widgets.DateTimePicker(birthDatePicker)
        .withCustomFormatHandler(this._handleDateFormat)
        .initialize();
  }

  this.preferredLanguages = this.form.queryFirst('select[name="user.preferredLanguages"]');
  if (this.preferredLanguages !== null) {
    new Prime.Widgets.MultipleSelect(this.preferredLanguages)
        .withInitialSelectedOrder(orderedPreferredLanguages)
        .withPreserveDisplayedSelectionOrder(true)
        .withRemoveIcon('')
        .withCustomAddEnabled(false)
        .withPlaceholder('')
        .initialize();
  }

  // Kind of a hack for now, we should have an option on the date picker to not set the value on initialize unless the field contains a value
  if (birthDatePicker !== null && !birthDateSet) {
    birthDatePicker.setValue('');
  }

  // handle this for field validation while change password is selected
  this._handleEditUserPasswordEvent();
};

FusionAuth.Admin.User.constructor = FusionAuth.Admin.User;
FusionAuth.Admin.User.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleTenantIdChange: function() {
    var tenantId = this.tenantIdSelect.getValue();
    var url = window.location.href;
    if (url.indexOf('?') > -1){
      url += '&tenantId=' + tenantId;
    }else{
      url += '?tenantId=' + tenantId;
    }
    window.location.href = url;
  },

  /**
   * Handles the select change event.
   * @private
   */
  _handleEditUserPasswordEvent: function() {
    if (this.editUserPasswordOptions !== null) {
      if (this.editUserPasswordOptions.getValue() === 'update') {
        this.passwordFields.addClass('open');
      } else {
        this.passwordFields.removeClass('open');
      }
    }
  },

  /**
   * Hard coding this for now - we should really build a formatter into the Date Picker
   * @param date the current date value of the date picker
   * @returns {string} return a string to be set into the input field
   * @private
   */
  _handleDateFormat: function(date) {
    return (date.getMonth() + 1)  + "/" + date.getDate() + "/" + date.getFullYear();
  }
};