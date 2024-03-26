/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @constructor
 */
FusionAuth.OAuth2.TwoFactor = function() {
  Prime.Utils.bindAll(this);

  this.uvpaAvailableField = Prime.Document.queryFirst('input[name="userVerifyingPlatformAuthenticatorAvailable"]')
  if (this.uvpaAvailableField !== null && typeof(PublicKeyCredential) !== 'undefined' && PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable) {
    PublicKeyCredential
      .isUserVerifyingPlatformAuthenticatorAvailable()
      .then(result => this.uvpaAvailableField.setValue(result));
  }
};

FusionAuth.OAuth2.TwoFactor.constructor = FusionAuth.OAuth2.TwoFactor;
FusionAuth.OAuth2.TwoFactor.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

};
