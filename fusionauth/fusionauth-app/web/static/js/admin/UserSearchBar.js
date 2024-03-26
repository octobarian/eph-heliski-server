/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Global User Search Bar, capture Enter and submit the form so we don't need a submit button.
 *
 * @constructor
 */
FusionAuth.Admin.UserSearchBar = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('user-search-bar');
  this.queryString = this.form.queryFirst('input').addEventListener('keydown', this._handleKeyDown);
};

FusionAuth.Admin.UserSearchBar.constructor = FusionAuth.Admin.UserSearchBar;
FusionAuth.Admin.UserSearchBar.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleKeyDown: function(event) {
    if (event.keyCode === Prime.Events.Keys.ENTER) {
      this.form.domElement.submit();
    }
  }
};