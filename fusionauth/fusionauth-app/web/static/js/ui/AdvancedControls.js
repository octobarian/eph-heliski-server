/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
"use strict";

FusionAuth.UI.AdvancedControls = function(form, storageKey) {
  Prime.Utils.bindAll(this);
  this.form = form;
  this.advancedControls = null;
  this.storageKey = storageKey;
  this.state = Prime.Storage.getSessionObject(this.storageKey) || { open : false };
};

FusionAuth.UI.AdvancedControls.prototype = {

  initialize: function() {
    this.form.queryFirst('[data-expand-open]').addEventListener('click', this._handleClick);
    this.advancedControls = Prime.Document.queryById(this.form.queryFirst('[data-expand-open]').getDataAttribute('expandOpen'));
    if (this.state.open) {
      this.advancedControls.addClass('open');
    }
  },

  _handleClick: function(event) {
    Prime.Utils.stopEvent(event);
    new Prime.Effects.SlideOpen(this.advancedControls)
        .withCloseCallback(this._closeCallback)
        .withOpenCallback(this._openCallback)
        .toggle();
  },

  _openCallback: function() {
    this.advancedControls.query('input, select').setDisabled(false);
    this.state.open = true;
    Prime.Storage.setSessionObject(this.storageKey, this.state);
  },

  _closeCallback: function() {
    this.advancedControls.query('input, select').setDisabled(true);
    this.state.open = false;
    Prime.Storage.setSessionObject(this.storageKey, this.state);
  }
};
