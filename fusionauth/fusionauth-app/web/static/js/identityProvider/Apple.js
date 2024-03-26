/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.IdentityProvider.Apple = function() {
  Prime.Utils.bindAll(this);

  Prime.Document.onReady(function() {
    this.button = Prime.Document.queryById('apple-login-button');
    this.scope = this.button.getDataAttribute('scope');
    this.servicesId = this.button.getDataAttribute('servicesId');

    Prime.Document.addDelegatedEventListener('click', '#apple-login-button', this._handleLoginClick);
    this.initialized = false;
  }.bind(this));
};

FusionAuth.IdentityProvider.Apple.constructor = FusionAuth.IdentityProvider.Apple;
FusionAuth.IdentityProvider.Apple.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleLoginClick: function(event) {
    Prime.Utils.stopEvent(event);

    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.open();
      // In Safari, if the user closes the prompt we need to turn off the In Progress indicator.
      // - I can't find an event to listen for, this will have to do for now.
      setTimeout(function() {
        FusionAuth.IdentityProvider.InProgress.close();
      }, 3000); // Numeric separators aren't supported until Safari 13, so we shouldn't use 3_000
    }

    if (!this.initialized) {
      this.initialized = true;

      var state = FusionAuth.IdentityProvider.Helper.captureState({
        identityProviderId: '13d2a5db-7ef9-4d62-b909-0df58612e775'
      });

      AppleID.auth.init({
        clientId : this.servicesId,
        scope : this.scope,
        redirectURI : window.location.protocol + '//' + window.location.hostname + '/oauth2/callback',
        state : state,
        usePopup : false
      });
    }

    AppleID.auth.signIn();
  }
};

FusionAuth.IdentityProvider.Apple.instance = new FusionAuth.IdentityProvider.Apple();

//noinspection DuplicatedCode
if (document.getElementById('idp_helper') === null) {
  var element = document.createElement('script');
  element.id = 'idp_helper';
  element.src = '/js/identityProvider/Helper.js?version=' + (FusionAuth.Version || '1.11.0');
  element.async = false;
  document.getElementsByTagName("head")[0].appendChild(element);
}