/*
 * Copyright (c) 2019-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the API key stuff.
 *
 * @constructor
 */
FusionAuth.Admin.APIKeys = function() {
  Prime.Utils.bindAll(this);

  const form = Prime.Document.queryById('api-key-form');
  new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.api-keys.advancedControls');

  // Bind the reveal action
  this.revealForm = Prime.Document.queryById('api-key-reveal-form');
  this.revealValue = this.revealForm.queryFirst('input[type=hidden][name=apiKeyId]')
  Prime.Document.addDelegatedEventListener('click', '[data-secure-reveal] a', this._handleRevealClick);
};

FusionAuth.Admin.APIKeys.constructor = FusionAuth.Admin.APIKeys;
FusionAuth.Admin.APIKeys.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleRevealClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.currentRevealTarget = Prime.Document.Element.wrap(event.target);
    this.currentRevealContainer = this.currentRevealTarget.queryUp('[data-secure-reveal]');

    // Try to destroy any open tooltips
    var tooltip = this.currentRevealTarget.is('[data-tooltip]')
        ? this.currentRevealTarget
        : this.currentRevealTarget.queryUp('[data-tooltip]');
    if (tooltip !== null && Prime.Utils.isDefined(tooltip.domElement.toolTipObject)) {
      tooltip.domElement.toolTipObject.hide();
    }

    this.revealValue.setValue(this.currentRevealContainer.getDataAttribute('secureReveal'));
    new Prime.Ajax.Request(this.revealForm.getAttribute('action'), 'POST')
        .withDataFromForm(this.revealForm)
        .withSuccessHandler(this._handleSecretReveal)
        .go();
  },

  _handleSecretReveal: function(xhr) {
    this.currentRevealContainer.setHTML(xhr.responseText);
  }
};
