/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @constructor
 */
FusionAuth.OAuth2.Authorize = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryFirst('form[action*="authorize"]');
  this.deviceName = this.form.queryFirst('input[name="metaData.device.name"]');
  this.deviceType = this.form.queryFirst('input[name="metaData.device.type"]');
  this.timezone = this.form.queryFirst('input[name="timezone"]');
  this.uvpaAvailableField = this.form.queryFirst('input[name="userVerifyingPlatformAuthenticatorAvailable"]');

  var os = Prime.Browser.os;
  if (os === 'Mac') {
    os = 'macOS';
  }

  this.deviceName.setValue(os + ' ' + Prime.Browser.name);
  this.deviceType.setValue('BROWSER');
  var guessed = jstz.determine();
  this.timezoneAvailable = Prime.Utils.isDefined(guessed.name());
  if (this.timezoneAvailable) {
    this.timezone.setValue(guessed.name());
    document.cookie = 'fusionauth.timezone=' + guessed.name() + '; path=/';
  }
  if (this.uvpaAvailableField !== null
      && typeof(PublicKeyCredential) !== 'undefined'
      && PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable) {
    PublicKeyCredential
      .isUserVerifyingPlatformAuthenticatorAvailable()
      .then(result => this.uvpaAvailableField.setValue(result));
  }

  // There are other links on the page with device name, type and timezone
  Prime.Document.query('a').each(this._updateURLs);
};

FusionAuth.OAuth2.Authorize.constructor = FusionAuth.OAuth2.Authorize;
FusionAuth.OAuth2.Authorize.prototype = {
  _updateURLs: function(element) {
    var href = element.getAttribute('href');
    if (href !== null) {
      href = href.replace(/(metaData\.device\.name=)[^"&]*/, '$1' + encodeURIComponent(this.deviceName.getValue()));
      href = href.replace(/(metaData\.device\.type=)[^"&]*/, '$1' + encodeURIComponent(this.deviceType.getValue()));
      if (this.timezoneAvailable) {
        href = href.replace(/(timezone=)[^"&]*/, '$1' + encodeURIComponent(this.timezone.getValue()));
      }
      element.setAttribute('href', href);
    }
  }
};
