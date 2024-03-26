/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the permissions page.
 *
 * @constructor
 */
FusionAuth.Admin.PermissionsForm = function() {
  Prime.Utils.bindAll(this);

  new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
      .initialize();
  Prime.Document.queryFirst('a[href*="add"]').addEventListener('click', this._handleClickEvent);
};
FusionAuth.Admin.PermissionsForm.constructor = FusionAuth.Admin.PermissionsForm;

FusionAuth.Admin.PermissionsForm.prototype = {
  _handleClickEvent: function(event) {
    Prime.Utils.stopEvent(event);
    var button = new Prime.Document.Element(event.currentTarget);
    var uri = button.getAttribute('href');
    this.dialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withAdditionalClasses('wide')
        .open(uri);
  }
};
