/*
 * Copyright (c) 2019-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the keys stuff.
 *
 * @constructor
 */
FusionAuth.Admin.Keys = function() {
  Prime.Utils.bindAll(this);

  var keyActions = Prime.Document.queryById('key-actions');
  keyActions.addDelegatedEventListener('click', 'a', this._handleKeyGenerateClick);

  // Bind the reveal action
  Prime.Document.addDelegatedEventListener('click', '#hmac-secret form button', this._handleRevealClick);
};

FusionAuth.Admin.Keys.constructor = FusionAuth.Admin.Keys;
FusionAuth.Admin.Keys.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleDialogOpen: function(dialog) {

    var privateKeyTextArea = dialog.element.queryFirst('textarea[name="key.privateKey"]');
    if (privateKeyTextArea !== null) {
      new FusionAuth.UI.TextEditor(privateKeyTextArea)
          .withOptions({
            'mode': 'properties',
            'lineNumbers': true,
            'lineWrapping': false
          })
          .render()
          .setHeight(200);
    }

    var publicKeyTextArea = dialog.element.queryFirst('textarea[name="key.publicKey"]');
    if (publicKeyTextArea !== null) {
      new FusionAuth.UI.TextEditor(publicKeyTextArea)
          .withOptions({
            'mode': 'properties',
            'lineNumbers': true,
            'lineWrapping': false
          })
          .render()
          .setHeight(200);
    }

    var certificateTextArea = dialog.element.queryFirst('textarea[name="key.certificate"]');
    if (certificateTextArea !== null) {
      new FusionAuth.UI.TextEditor(certificateTextArea)
          .withOptions({
            'mode': 'properties',
            'lineNumbers': true,
            'lineWrapping': false
          })
          .render()
          .setHeight(200);
    }

    var secretTextArea = dialog.element.queryFirst('textarea[name="key.secret"]');
    if (secretTextArea !== null) {
      new FusionAuth.UI.TextEditor(secretTextArea)
          .withOptions({
            'mode': 'properties',
            'lineNumbers': true,
            'lineWrapping': false
          })
          .render()
          .setHeight(50);
    }
  },

  _handleKeyGenerateClick: function(event, target) {
    Prime.Utils.stopEvent(event);

    var anchor = new Prime.Document.Element(target);
    this.dialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleDialogOpen)
        .withFormHandling(true)
        .withAdditionalClasses('wide')
        .withFormSuccessCallback(this._handleFormSuccess)
        .open(anchor.getAttribute('href'));
  },

  _handleFormSuccess: function() {
    this.dialog.close();
    window.location.reload();
  },

  _handleRevealClick: function(event) {
    Prime.Utils.stopEvent(event);
    var form = Prime.Document.queryFirst('#hmac-secret form');
    new Prime.Ajax.Request(form.getAttribute('action'), 'POST')
        .withDataFromForm(form)
        .withSuccessHandler(this._handleSecretReveal)
        .go();
  },

  _handleSecretReveal: function(xhr) {
    var field = Prime.Document.queryFirst('#hmac-secret');
    field.setHTML(xhr.responseText);
  }
};