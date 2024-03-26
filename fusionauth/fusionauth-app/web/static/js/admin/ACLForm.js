/*
 * Copyright (c) 2021, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the IP ACL form by setting up an ExpandableTable for the headers.
 *
 * @constructor
 */
FusionAuth.Admin.ACLForm = function(element) {
  Prime.Utils.bindAll(this);

  this.form = element;

  // Setup the exception table
  new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('acl-entries-table'));

  // Setup the tabs
  new Prime.Widgets.Tabs(this.form.queryFirst('.tabs'))
      .withLocalStorageKey('settings.ip-acl-tabs')
      .initialize();
};

FusionAuth.Admin.ACLForm.constructor = FusionAuth.Admin.ACLForm;
FusionAuth.Admin.ACLForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/
};
