/*
 * Copyright (c) 2021-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Account = FusionAuth.Account || {};

/**
 * @constructor
 */
FusionAuth.Account.EnableTwoFactor = function(params) {
  Prime.Utils.bindAll(this);

  var qrCode = Prime.Document.queryById('qrcode');
  if (qrCode !== null) {
    this.accountName = params.accountName;
    this.issuer = params.issuer;
    this.secretBase32Encoded = params.secretBase32Encoded;

    // https://github.com/google/google-authenticator/wiki/Key-Uri-Format
    new QRCode(qrCode.domElement, 'otpauth://totp/' + encodeURIComponent(this.issuer) + '%3A' + encodeURIComponent(this.accountName) + '?issuer=' + encodeURIComponent(this.issuer) + '&secret=' + this.secretBase32Encoded);
  }

  this.enableForm = Prime.Document.queryById('two-factor-form');
  if (this.enableForm !== null) {
    this.enableForm.addEventListener('submit', this._handleOnSubmit);
  }

  this.selectMethod = Prime.Document.queryById('select-method');
  if (this.selectMethod !== null) {
    this.selectMethod.addEventListener('change', this._handleSelectChange);
    this._handleSelectChange();
  }

  this.sendForm = Prime.Document.queryById('two-factor-send-form');
};

FusionAuth.Account.EnableTwoFactor.constructor = FusionAuth.Account.EnableTwoFactor;
FusionAuth.Account.EnableTwoFactor.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleOnSubmit: function() {
    // Sync the email & mobile phone between forms
    var email = this.sendForm.queryFirst('input[name="email"]');
    if (email !== null) {
      this.enableForm.queryFirst('input[name="email"]').setValue(email.getValue());
    }

    var mobilePhone = this.sendForm.queryFirst('input[name="mobilePhone"]');
    if (mobilePhone !== null) {
      this.enableForm.queryFirst('input[name="mobilePhone"]').setValue(mobilePhone.getValue());
    }
  },

  _handleSelectChange: function() {
    var value = this.selectMethod.getValue();
    Prime.Document.query("[data-method-instructions]").each(function(element) {
      if (element.is('[data-method-instructions=' + value)) {
        element.show();
      } else {
        element.hide();
      }
    });

    // Update the hidden field for 'method' with the currently selected value.
    Prime.Document.query('form input[type="hidden"][name="method"]').each(function(element) {
      element.setValue(value);
    });
  }

};
