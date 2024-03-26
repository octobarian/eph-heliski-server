/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Manage the Add User Consent Form
 *
 * @constructor
 * @param form {Prime.Document.Element} the form
 */
FusionAuth.Admin.AddUserConsentForm = function(form) {
  Prime.Utils.bindAll(this);

  this.form = form;
  this.form.addDelegatedEventListener('change', 'select[name="consentId"]', this._handleConsentChange);

  this.consent =  this.form.queryFirst('select[name="consentId"]');
};

FusionAuth.Admin.AddUserConsentForm.constructor = FusionAuth.Admin.AddUserConsentForm;
FusionAuth.Admin.AddUserConsentForm.prototype = {

  _handleConsentChange: function() {
    this.consent =  this.form.queryFirst('select[name="consentId"]');
    this.controls = Prime.Document.queryById('consent-controls');

    var uri = '/ajax/user/consent/consent-controls?userId=' + this.form.queryFirst('input[name="userId"]').getValue();
    if (Prime.Utils.isDefined(this.consent.getValue())) {
      uri += '&consentId=' + this.consent.getValue();
    }

    new Prime.Ajax.Request(uri, 'GET')
        .withSuccessHandler(this._handleSuccessResponse)
        .withErrorHandler(this._handleSuccessResponse)
        .go();
  },

  _handleSuccessResponse: function(xhr) {
    this.controls.setHTML(xhr.responseText);
  }
};