/*
 * Copyright (c) 2021-2023, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles Entity Search page.
 *
 * @constructor
 */
FusionAuth.Admin.EntitySearch = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('entity-search-form');
  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.entity.search.advancedControls').initialize();

  new AdvancedEntitySearch(this.form);
};
FusionAuth.Admin.EntitySearch.constructor = FusionAuth.Admin.EntitySearch;