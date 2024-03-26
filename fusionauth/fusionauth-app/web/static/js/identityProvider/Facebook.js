/*
 * Copyright (c) 2018-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.IdentityProvider.Facebook = function() {
  Prime.Utils.bindAll(this);

  Prime.Document.onReady(function() {
    this.button = Prime.Document.queryById('facebook-login-button');
    if (this.button.is('[data-login-method="UseRedirect"]')) {
      return;
    }
    this.scope = this.button.getDataAttribute('permissions');
    Prime.Document.addDelegatedEventListener('click', '#facebook-login-button', this._handleLoginClick);
  }.bind(this));

  window.fbAsyncInit = function() {
    var thisScript = FusionAuth.IdentityProvider.Helper.findIdentityProviderScriptByFileName('Facebook.js');

    FB.init({
      appId: thisScript.dataset.appId,
      cookie: true,
      status: true,
      version: 'v3.1',
      xfbml: false
    });

    var automaticFacebookLogin = false;
    if (automaticFacebookLogin) {
      FB.getLoginStatus(function(response) {
        this._loginCallback(response);
      }.bind(this));
    }

  }.bind(this);
};

FusionAuth.IdentityProvider.Facebook.constructor = FusionAuth.IdentityProvider.Facebook;
FusionAuth.IdentityProvider.Facebook.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleLoginClick: function(event) {
    Prime.Utils.stopEvent(event);

    FB.getLoginStatus(function(response) {
      if (response.status === "connected") {
        this._loginCallback(response);
      } else {
        FB.login(function(response) {
          if (response.authResponse) {
            this._loginCallback(response);
          } else {
            console.log('User cancelled login or did not fully authorize.');
          }
        }.bind(this), {
          scope: this.scope
        });
      }
    }.bind(this));
  },

  _loginCallback: function(response) {
    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.open();
    }

    if (response.status === 'connected') {
      var state = FusionAuth.IdentityProvider.Helper.captureState();
      window.location.href = '/oauth2/callback'
          + '?token=' + encodeURIComponent(response.authResponse.accessToken)
          + '&identityProviderId=56abdcc7-8bd9-4321-9621-4e9bbebae494'
          + '&state=' + state;

    } else if (response.status === 'not_authorized') {
      console.log('Not Authorized');
    } else {
      console.log('Unknown');
    }

    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.close();
    }
  }
};

// Create the singleton instance
FusionAuth.IdentityProvider.Facebook.instance = new FusionAuth.IdentityProvider.Facebook();

//noinspection DuplicatedCode
if (document.getElementById('idp_helper') === null) {
  var element = document.createElement('script');
  element.id = 'idp_helper';
  element.src = '/js/identityProvider/Helper.js?version=' + (FusionAuth.Version || '1.11.0');
  element.async = false;
  document.getElementsByTagName("head")[0].appendChild(element);
}