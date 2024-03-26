/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
"use strict";

FusionAuth.UI.LongDescription = function(element, storageKey) {
  Prime.Utils.bindAll(this);
  this.element = element;
  this.longDescription = null;
  this.storageKey = storageKey;
  this.state = Prime.Storage.getSessionObject(this.storageKey) || { open : false };
};

FusionAuth.UI.LongDescription.prototype = {

  initialize: function() {
    this.element.addEventListener('click', this._handleClick);
    this.longDescription = Prime.Document.queryById(this.element.getDataAttribute('expandOpen'));
    if (this.state.open) {
      this.longDescription.addClass('open');
    }
  },

  _handleClick: function(event) {
    Prime.Utils.stopEvent(event);
    new Prime.Effects.SlideOpen(this.longDescription)
        .withCloseCallback(this._closeCallback)
        .withOpenCallback(this._openCallback)
        .toggle();
  },

  _openCallback: function() {
    this.state.open = true;
    Prime.Storage.setSessionObject(this.storageKey, this.state);
  },

  _closeCallback: function() {
    this.state.open = false;
    Prime.Storage.setSessionObject(this.storageKey, this.state);
  }
};
