/*
 * Copyright (c) 2020-2022, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
"use strict";

// This is a work in progress, it mostly works. We'd need to be able to refresh the page after restoring state for pages
// that are searching for example. This is an alternative to using the @BrowserActionSession
FusionAuth.UI.LocalStorageState = function(form, storageKey) {
  Prime.Utils.bindAll(this);

  this.form = form.addEventListener('submit', this._handleSubmit);
  this.storageKey = storageKey;
  this.state = Prime.Storage.getLocalObject(this.storageKey) || {};

  this.form.query('input,select,textarea').each((function(element) {
    if (!element.isDisabled()) {
      var name = element.getAttribute('name');
      var value = this.state[name];
      if (Prime.Utils.isDefined(value)) {
        element.setValue(value);
      }
    }
  }).bind(this));
};

FusionAuth.UI.LocalStorageState.constructor = FusionAuth.UI.LocalStorageState;
FusionAuth.UI.LocalStorageState.prototype = {
  _handleSubmit: function() {
    this.form.query('input,select,textarea').each((function(element) {
      if (!element.isDisabled()) {
        var name = element.getAttribute('name');
        var value = element.getValue();
        if (Prime.Utils.isDefined(value) && value.length > 0) {
          this.state[name] = element.getValue();
        }
      }
    }).bind(this));

    Prime.Storage.setLocalObject(this.storageKey, this.state);
  }
};
