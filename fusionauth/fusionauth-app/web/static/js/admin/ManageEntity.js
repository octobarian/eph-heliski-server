/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * JavaScript for the manage entity page.
 *
 * @constructor
 * @param entityId {string} The entity id.
 */
FusionAuth.Admin.ManageEntity = function(entityId) {
  Prime.Utils.bindAll(this);

  // Last Login table
  this.entityId = entityId;

  this.tabs = new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey('user.manage.tabs')
      .initialize();

  // Setup the entity search
  var resultDiv = Prime.Document.queryById('entity-search-results');
  var container = resultDiv.queryUp('.panel');
  var form = Prime.Document.queryById('entity-search-form');
  this.ajaxSearch = new FusionAuth.Admin.AJAXSearchForm()
      .withContainer(container)
      .withDatabaseSort()
      .withDefaultSearchCriteria({
        's.entityId': entityId,
        's.orderBy': 'name asc'
      })
      .withForm(form)
      .withResultDiv(resultDiv)
      .withStorageKey('io.fusionauth.entity[' + entityId + '].entities')
      .initialize();
  this.ajaxSearch.search();
};

FusionAuth.Admin.ManageEntity.constructor = FusionAuth.Admin.ManageEntity;
