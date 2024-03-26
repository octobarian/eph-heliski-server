/*
 * Copyright (c) 2021, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Constructs a ClientSecret object.
 *
 * @param {Prime.Document.Element|PrimeElement} element the client secret element
 * @constructor
 */
FusionAuth.Admin.ClientSecret = function(element) {
  Prime.Utils.bindAll(this);

  this.element = Prime.Document.Element.wrap(element);
  this.clientSecretHidden = Prime.Document.queryById(this.element.getDataAttribute('hidden'));
  if (this.element !== null) {
    this.element.queryUp('div').queryFirst('a.button').addEventListener('click', this._handleRegenerateClick);
  }
};

FusionAuth.Admin.ClientSecret.constructor = FusionAuth.Admin.ClientSecret;
FusionAuth.Admin.ClientSecret.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleRegenerateClick: function(event) {
    Prime.Utils.stopEvent(event);
    var warnKey = this.element.getDataAttribute('warn') || 'warn';
    this.dialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withFormSuccessCallback(this._handleRegenerateSuccess)
        .open('/ajax/oauth2/regenerate-client-secret?warnKey=' + warnKey);
  },

  _handleRegenerateSuccess: function(dialog, xhr) {
    this.dialog.close();
    var response = JSON.parse(xhr.responseText);
    this.element.setValue(response.clientSecret);
    this.clientSecretHidden.setValue(response.clientSecret);
  }
};
