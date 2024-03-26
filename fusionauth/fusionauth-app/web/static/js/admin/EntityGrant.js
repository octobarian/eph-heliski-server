/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the entity grant form.
 *
 * @constructor
 */
FusionAuth.Admin.EntityGrant = function() {
  Prime.Utils.bindAll(this);

  this.qText = Prime.Document.queryFirst('input[type="text"][name="q"]');
  if (this.qText !== null) {
    this.searchInput = Prime.Document.queryFirst('input[name="q"]');
    this.hiddenInput = Prime.Document.queryFirst('input[name="entityId"]');
    var tenantId = Prime.Document.queryFirst('input[type="hidden"][name="tenantId"]').getValue();
    new FusionAuth.Admin.AJAXSearchWidget(this.searchInput, this.hiddenInput)
        .withEmptyMessage('No entities found')
        .withRenderer(function(entity) {
          return {
            display: entity.name,
            value: entity.id
          };
        })
        .withResultProvider(function(json) {
          return json['entities'];
        })
        .withSearchURI('/ajax/entity/search.json?tenantId=' + tenantId)
        .withSelectCallback(this._handleEntitySelect)
        .initialize();

  }
};

FusionAuth.Admin.EntityGrant.constructor = FusionAuth.Admin.EntityGrant;

FusionAuth.Admin.EntityGrant.prototype = {
  _handleEntitySelect: function() {
    var entityId = this.hiddenInput.getValue();
    var userId = Prime.Document.queryFirst('input[type="hidden"][name="grant.userId"]').getValue();
    var recipientEntityId = Prime.Document.queryFirst('input[type="hidden"][name="grant.recipientEntityId"]').getValue();
    var tenantId = Prime.Document.queryFirst('input[type="hidden"][name="tenantId"]').getValue();

    var url = new URL(window.location.href);
    url.searchParams.set('entityId', entityId);
    if (userId !== '') {
      url.searchParams.set('grant.userId', userId);
    }
    if (recipientEntityId !== '') {
      url.searchParams.set('grant.recipientEntityId', recipientEntityId);
    }
    if (tenantId !== '') {
      url.searchParams.set('tenantId', tenantId);
    }
    window.location.href = url.toString();
  }
};
