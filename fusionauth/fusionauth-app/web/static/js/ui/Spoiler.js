/*
 * Copyright (c) 2020-2022, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
"use strict";

FusionAuth.UI.Spoiler = function(element, storageKey) {
  Prime.Utils.bindAll(this);
  this.element = element;
  this.spoiler = null;
  this.storageKey = storageKey;
  this.state = Prime.Storage.getSessionObject(this.storageKey) || { open : false };
};

FusionAuth.UI.Spoiler.prototype = {

  initialize: function() {
    this.element.addEventListener('click', this._handleClick);
    this.spoiler = Prime.Document.queryById(this.element.getDataAttribute('spoiler'));
    if (this.state.open) {
      this.spoiler.addClass('open');
    }
    return this;
  },

  _handleClick: function(event) {
    Prime.Utils.stopEvent(event);
    new Prime.Effects.SlideOpen(this.spoiler)
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
