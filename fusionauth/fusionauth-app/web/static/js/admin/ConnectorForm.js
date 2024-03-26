/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit connector form.
 *
 * @constructor
 */
FusionAuth.Admin.ConnectorForm = function(type) {
  Prime.Utils.bindAll(this);

  if (type === "Generic") {
    // Setup the header table
    new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('header-table'));
  }

  if (type === "LDAP") {
    // Setup the multiple selector for requested attributes
    this.requestedAttributes = Prime.Document.queryById('requestedAttributes');
    if (this.requestedAttributes !== null) {
      new Prime.Widgets.MultipleSelect(this.requestedAttributes)
          .withPlaceholder('cn')
          .withRemoveIcon('')
          // TODO : Connectors : This should ideally be a translated message
          .withCustomAddLabel('Add attribute ')
          .initialize();
    }
  }

  // Setup the tabs. When editing the FusionAuth connector, there are no tabs on the page.
  var tabs = Prime.Document.queryFirst('.tabs');
  if (tabs !== null) {
    new Prime.Widgets.Tabs(tabs)
        .withErrorClassHandling('error')
        .withLocalStorageKey('settings.tenants.connector.tabs')
        .initialize();
  }
};

FusionAuth.Admin.ConnectorForm.constructor = FusionAuth.Admin.ConnectorForm;
FusionAuth.Admin.ConnectorForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/
};
