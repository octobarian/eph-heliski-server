/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.IdentityProvider.Redirect = function() {
  Prime.Utils.bindAll(this);
  Prime.Document.addDelegatedEventListener('click', '[data-login-method="UseRedirect"]', this._handleLoginClick);

  // For backwards compatibility add linkedin, openid, and samlv2 if they weren't matched by the data-login-method
  ['.linkedin', '.openid', '.samlv2'].forEach(function(cls) {
    var selector = cls + '.login-button';
    var element = Prime.Document.queryFirst(selector);
    if (element && !element.is('[data-login-method="UseRedirect"]')) {
      Prime.Document.addDelegatedEventListener('click', selector, this._handleLoginClick);
    }
  }, this);
};

FusionAuth.IdentityProvider.Redirect.constructor = FusionAuth.IdentityProvider.Redirect;
FusionAuth.IdentityProvider.Redirect.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleLoginClick: function(event, target) {
    Prime.Utils.stopEvent(event);

    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.open();
    }

    var button = new Prime.Document.Element(target);
    var identityProviderId = button.getDataAttribute('identityProviderId');
    var state = FusionAuth.IdentityProvider.Helper.captureState({
      identityProviderId:  button.getDataAttribute('identityProviderId')
    });

    window.location.href = '/oauth2/redirect'
        + '?client_id=' + Prime.Document.queryFirst('input[name=client_id]').getValue()
        + '&identityProviderId=' + identityProviderId
        + '&state=' + state;
  }
};

Prime.Document.onReady(function() {
  FusionAuth.IdentityProvider.Redirect.instance = new FusionAuth.IdentityProvider.Redirect();
});

//noinspection DuplicatedCode
if (document.getElementById('idp_helper') === null) {
  var element = document.createElement('script');
  element.id = 'idp_helper';
  element.src = '/js/identityProvider/Helper.js?version=' + (FusionAuth.Version || '1.11.0');
  element.async = false;
  document.getElementsByTagName("head")[0].appendChild(element);
}
