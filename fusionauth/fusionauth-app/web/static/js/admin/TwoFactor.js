/*
 * Copyright (c) 2021, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};
'use strict';

/**
 * Handles the Two Factor enable / disable form.
 *
 * @param {Prime.Document.Element|PrimeElement} element the form element
 * @constructor
 */
FusionAuth.Admin.TwoFactor = function(element) {
  Prime.Utils.bindAll(this);

  this.errors = null;
  this.form = Prime.Document.Element.wrap(element);

  // This will either be a select or a hidden field.
  this.method = this.form.queryFirst('select[name="method"]');
  if (this.method !== null) {
    this.method.addEventListener('change', this._handleMethodChange);
  } else {
    this.method = this.form.queryFirst('input[name="method"]');
  }

  this.authenticatorInstructions = Prime.Document.queryById('authenticator-instructions');
  this.emailInstructions = Prime.Document.queryById('email-instructions');
  this.smsInstructions = Prime.Document.queryById('sms-instructions');
  this.sendEmailCode = Prime.Document.queryById('send-email-code').addEventListener('click', this._handleSendClick);
  this.sendSMSCode = Prime.Document.queryById('send-sms-code').addEventListener('click', this._handleSendClick);
  this.qrCode = Prime.Document.queryById('qrcode');
  this.codeInput = this.form.queryFirst('input[name=code]');

  // Build the QR code
  if (this.qrCode !== null) {
    var account = this.qrCode.getDataAttribute('account');
    var base32Secret = this.qrCode.getDataAttribute('base32Secret');
    var issuer = this.qrCode.getDataAttribute('issuer');
    // Clear this div before we construct the QR code so we don't append this on a form validation re-render
    this.qrCode.setHTML('');
    new QRCode(this.qrCode.domElement, 'otpauth://totp/' + encodeURIComponent(issuer) + '%3A' + encodeURIComponent(account) + '?issuer=' + encodeURIComponent(issuer) + '&secret=' + base32Secret);
  }

  this.toggleMethodTypes();
};

FusionAuth.Admin.TwoFactor.constructor = FusionAuth.Admin.TwoFactor;
FusionAuth.Admin.TwoFactor.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  toggleMethodTypes: function() {
    var value = this.method.getValue();

    this.authenticatorInstructions.hide();
    this.emailInstructions.hide();
    this.smsInstructions.hide();
    if (this.qrCode !== null) {
      this.qrCode.hide();
    }
    this.codeInput.queryUp('.form-row').hide();

    if (value === 'authenticator') {
      this.authenticatorInstructions.show();
      if (this.qrCode !== null) {
        this.qrCode.show();
      }
      this.codeInput.queryUp('.form-row').show();
    } else if (value === 'email') {
      this.emailInstructions.show();
      this.codeInput.queryUp('.form-row').show();
    } else if (value === 'sms') {
      this.smsInstructions.show();
      this.codeInput.queryUp('.form-row').show();
    }
  },

  _handleMethodChange: function() {
    this.toggleMethodTypes();
  },

  _handleSendClick: function(event) {
    Prime.Utils.stopEvent(event);

    if (this.errors !== null) {
      this.errors.destroy();
    }

    var inProgress = new Prime.Widgets.InProgress(this.form.queryUp('.prime-dialog')).withMinimumTime(500);
    new Prime.Ajax.Request('/ajax/user/two-factor/send', 'POST')
        .withInProgress(inProgress)
        .withDataFromForm(this.form)
        .withErrorHandler(this._handleSendResponse)
        .withSuccessHandler(this._handleSendResponse)
        .go();
  },

  _handleSendResponse: function(xhr) {
    if (xhr.status === 400) {
      this.errors = new FusionAuth.UI.Errors()
          .withErrors(JSON.parse(xhr.responseText))
          .withForm(this.form)
          .initialize();
    }
  }
};