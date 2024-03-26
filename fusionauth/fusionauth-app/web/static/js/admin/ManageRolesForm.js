/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the manage application roles page.
 *
 * @constructor
 */
FusionAuth.Admin.ManageRolesForm = function() {
  Prime.Utils.bindAll(this);

  new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
      .initialize();
  Prime.Document.queryFirst('a[href*="add-role"]').addEventListener('click', this._handleClickEvent);
};
FusionAuth.Admin.ManageRolesForm.constructor = FusionAuth.Admin.ManageRolesForm;

FusionAuth.Admin.ManageRolesForm.prototype = {
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
