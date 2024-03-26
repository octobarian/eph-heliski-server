/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.IdentityProvider.Google = function() {
  Prime.Utils.bindAll(this);

  Prime.Document.onReady(function() {
    // Attempt to set the correct width on the button for the GIS button which is using the HTML API.
    // - This won't account for page resize, but because the button is loaded in an IFRAME, it is very difficult to
    //   get the resize to work correctly.
    this.gIdSignin = document.querySelector('.g_id_signin');
    if (this.gIdSignin !== null) {
      this.gIdSignin.dataset.width = "" + this.gIdSignin.parentElement.offsetWidth;
    }

    // If the legacy GAPI is not loaded, then there is nothing to do here.
    // - This assumes that you aren't trying to use GAPI and GIS at the same time.
    if (typeof gapi === 'undefined') {
      return;
    }

    // This is the legacy button that can only be used for the UseRedirect mode, or with the legacy GAPI until it is fully deprecated.
    // - If the legacy button has been removed, or the legacy button has a login-method of UsePopup, bail.
    this.button = Prime.Document.queryById('google-login-button');
    if (this.button === null || this.button.is('[data-login-method="UseRedirect"]')) {
      return;
    }

    // The remainder of this code is only for the popup login method when using the legacy Google API.
    this.scope = this.button.getDataAttribute('scope');
    gapi.load('auth2', function() {
      var thisScript = FusionAuth.IdentityProvider.Helper.findIdentityProviderScriptByFileName('Google.js');
      // Retrieve the singleton for the GoogleAuth library and set up the client.
      var auth2 = gapi.auth2.init({
        client_id: thisScript.dataset.clientId,
        scope: this.scope
      });

      auth2.attachClickHandler(this.button.domElement, {}, this._onSignIn, this._onFailure);
    }.bind(this));
  }.bind(this));
};

FusionAuth.IdentityProvider.Google.constructor = FusionAuth.IdentityProvider.Google;
FusionAuth.IdentityProvider.Google.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _onFailure: function(error) {
    if (error.error !== 'popup_closed_by_user') {
      console.log(error);
    }
  },

  _onSignIn: function(response) {
    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.open();
    }

    // Disconnect so we do not auto-login when we return to this page
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.disconnect();

    this._loginCallback(response);
  },

  _loginCallback: function(response) {
    var state = FusionAuth.IdentityProvider.Helper.captureState();
    window.location.href = '/oauth2/callback'
        + '?token=' + encodeURIComponent(response.getAuthResponse().id_token)
        + '&identityProviderId=82339786-3dff-42a6-aac6-1f1ceecb6c46'
        + '&state=' + state;
  }
};

function googleButtonClickHandler() {
  if (FusionAuth.IdentityProvider.InProgress) {
    FusionAuth.IdentityProvider.InProgress.open();
  }
}

FusionAuth.IdentityProvider.Google.instance = new FusionAuth.IdentityProvider.Google();

//noinspection DuplicatedCode
if (document.getElementById('idp_helper') === null) {
  var element = document.createElement('script');
  element.id = 'idp_helper';
  element.src = '/js/identityProvider/Helper.js?version=' + (FusionAuth.Version || '1.11.0');
  element.async = false;
  document.getElementsByTagName("head")[0].appendChild(element);
}
