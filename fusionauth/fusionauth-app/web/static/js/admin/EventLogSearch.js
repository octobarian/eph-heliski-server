/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the event log search.
 *
 * @param element the form
 * @constructor
 */
FusionAuth.Admin.EventLogSearch = function(element) {
  Prime.Utils.bindAll(this);

  this.form = element;
  this.numberOfResults = this.form.queryFirst('input[name="s.numberOfResults"]');

  this.form.query('.date-time-picker').each(function(e) {
    new Prime.Widgets.DateTimePicker(e).initialize();
  });

  // Pagination - rows per page changes.
  var auditLogSection = Prime.Document.queryById('event-log-content');
  auditLogSection.query('.pagination').each(function(element) {
    element.queryFirst('select').addEventListener('change', this._handlePaginationChange);
  }.bind(this));

  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.eventLog.advancedControls').initialize();
};

FusionAuth.Admin.EventLogSearch.constructor = FusionAuth.Admin.EventLogSearch;
FusionAuth.Admin.EventLogSearch.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handlePaginationChange: function(event) {
    var target = new Prime.Document.Element(event.currentTarget);
    this.numberOfResults.setValue(target.getValue());
    this.form.domElement.submit();
  }
};