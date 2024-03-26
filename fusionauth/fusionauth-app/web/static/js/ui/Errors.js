/*
 * Copyright (c) 2018-2022, FusionAuth, All Rights Reserved
 */

var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
'use strict';

/**
 * Take a JSON Errors from an API and render field and general errors w/out rebuilding the template.
 *
 * @constructor
 */
FusionAuth.UI.Errors = function() {
  Prime.Utils.bindAll(this);

  this.errorTemplate = Handlebars.compile(Prime.Document.queryById('error-alert-template').getHTML());
  this.form = null;
  this.initialized = false;
  this.messageContainer = Prime.Document.queryFirst('header.page-alerts');
  this.errors = null;
};

FusionAuth.UI.Errors.constructor = FusionAuth.UI.Errors;
FusionAuth.UI.Errors.prototype = {

  initialize: function() {
    if (this.initialized) {
      return this;
    }

    this.initialized = true;

    if (this.errors === null) {
      return this;
    }

    for (var prop in this.errors) {
      if (this.errors.hasOwnProperty(prop)) {
        // Handle General Errors
        if (prop === 'generalErrors') {
          var generalErrors = this.errors[prop];
          for (var i = 0; i < generalErrors.length; i++) {
            var newError = this.errorTemplate({'id': 'error_id_' + generalErrors[i].code, 'message': generalErrors[i].message});
            this.messageContainer.appendHTML(newError);
          }
        } else if (prop === 'fieldErrors') {
          // Handle Field Errors if we have a form
          if (this.form !== null) {
            var fieldErrors = this.errors[prop];
            for (var field in fieldErrors) {
              if (fieldErrors.hasOwnProperty(field)) {
                var fErrors = fieldErrors[field];
                for (var j = 0; j < fErrors.length; j++) {

                  var formField = this.form.queryFirst('input[name="' + field + '"], select[name="' + field + '"], textarea[name="' + field + '"]');
                  if (formField !== null) {
                    formField.addClass('error');
                    var formRow = formField.queryUp('.form-row');
                    if (formRow !== null) {
                      var label = formRow.queryFirst('label[for="' + formField.getId() + '"]');
                      if (label !== null) {
                        label.addClass('error');
                      }
                      formRow.appendHTML('<span class="error">' + fErrors[j].message + '</span>');
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return this;
  },

  /**
   * Use the same errors object and remove the messages we added.
   */
  destroy: function() {
    if (this.errors === null) {
      this.initialized = false;
      return this;
    }

    for (var prop in this.errors) {
      if (this.errors.hasOwnProperty(prop)) {
        // Handle General Errors
        if (prop === 'generalErrors') {
          var generalErrors = this.errors[prop];
          for (var i = 0; i < generalErrors.length; i++) {
            var errorMessage = Prime.Document.queryById('error_id_' + generalErrors[i].code);
            if (errorMessage !== null) {
              errorMessage.removeFromDOM();
            }
          }
        } else if (prop === 'fieldErrors') {
          // Handle Field Errors if we have a form
          if (this.form !== null) {
            var fieldErrors = this.errors[prop];
            for (var field in fieldErrors) {
              if (fieldErrors.hasOwnProperty(field)) {
                var fErrors = fieldErrors[field];
                for (var j = 0; j < fErrors.length; j++) {

                  var formField = this.form.queryFirst('input[name="' + field + '"], select[name="' + field + '"], textarea[name="' + field + '"]');
                  if (formField !== null) {
                    formField.removeClass('error');
                    var formRow = formField.queryUp('.form-row');
                    if (formRow !== null) {
                      var label = formRow.queryFirst('label[for="' + formField.getId() + '"]');
                      if (label !== null) {
                        label.removeClass('error');
                      }

                      var errorSpan = formRow.queryFirst('span.error');
                      errorSpan.removeFromDOM();
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    this.errors = null;
    this.initialized = false;
    return this;
  },

  withErrors: function(errors) {
    this.errors = errors;
    return this;
  },

  withForm: function(form) {
    this.form = form;
    return this;
  }
};