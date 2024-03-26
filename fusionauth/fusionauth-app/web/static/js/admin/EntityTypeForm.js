/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit entity type form. The row table is managed by the ExpandableTable object.
 *
 * @constructor
 */
FusionAuth.Admin.EntityTypeForm = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('entity-type-form');

  // Setup the permission table
  this.permissionsTable = Prime.Document.queryById('permission-table');
  if (this.permissionsTable !== null) {
    new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('permission-table'));
  }

  new Prime.Widgets.Tabs(this.form.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey( 'entity-management.entity-types.tabs')
      .initialize();
}

