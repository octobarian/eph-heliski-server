/*
 * Copyright (c) 2020-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * @constructor
 */
FusionAuth.Admin.Reactor = function() {
  Prime.Utils.bindAll(this);
  this.currentLocation = window.location.href;

  // Refresh key
  this.regenerateButton = Prime.Document.queryById('regenerate-key');
  if (this.regenerateButton !== null) {
    this.regenerateButton.addEventListener('click', this._handleRegenerateClick);
  }

  // Activate button (optional), use ends with matching selector in case we ever have a contextPath
  this.activateForm = Prime.Document.queryFirst('form[action$="/admin/reactor/activate"]');
  if (this.activateForm !== null) {
    this.activateForm.addEventListener('submit', this._handleActivateFormSubmit);
    this.activateButton = this.activateForm.queryFirst('button');
  }
};

FusionAuth.Admin.Reactor.constructor = FusionAuth.Admin.Reactor;
FusionAuth.Admin.Reactor.prototype = {
  _handleActivateFormSubmit: function() {
    var text = this.activateButton.getDataSet().activating;
    this.activateButton.setHTML('<i class="fa fa-spin fa-spinner"></i> <span class="text">' + text + '</span>')
    this.activateButton.setDisabled(true);
  },

  _handleRegenerateClick: function(event) {
    Prime.Utils.stopEvent(event);
    var uri = this.regenerateButton.getAttribute('href');
    new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withFormSuccessCallback(this._handleRegenerateSuccess)
        .open(uri);
  },

  _handleRegenerateSuccess: function() {
    window.location.href = this.currentLocation;
  }
};
