/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the system configuration form.
 *
 * @constructor
 */
FusionAuth.Admin.SystemConfigurationForm = function() {
  Prime.Utils.bindAll(this);

  new Prime.Widgets.Tabs(Prime.Document.queryById('tabs'))
      .withErrorClassHandling('error')
      .withSelectCallback(this._handleTabSelect)
      .withLocalStorageKey('system-configuration.tabs')
      .initialize();

  // Initialize the allowed origins etc
  var corsAllowedOrigins = Prime.Document.queryById('cors-allowed-origins');
  new Prime.Widgets.MultipleSelect(corsAllowedOrigins)
      .withCustomAddLabel(corsAllowedOrigins.getDataAttribute('corsAllowedOriginsAddLabel'))
      .withPlaceholder('')
      .withRemoveIcon('')
      .initialize();

  var corsAllowedHeaders = Prime.Document.queryById('cors-allowed-headers');
  new Prime.Widgets.MultipleSelect(corsAllowedHeaders)
      .withCustomAddLabel(corsAllowedHeaders.getDataAttribute('corsAllowedHeadersAddLabel'))
      .withPlaceholder('')
      .withRemoveIcon('')
      .initialize();

  var corsExposedHeaders = Prime.Document.queryById('cors-exposed-headers');
  new Prime.Widgets.MultipleSelect(corsExposedHeaders)
      .withCustomAddLabel(corsExposedHeaders.getDataAttribute('corsExposedHeadersAddLabel'))
      .withPlaceholder('')
      .withRemoveIcon('')
      .initialize();
};

FusionAuth.Admin.SystemConfigurationForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/
};
