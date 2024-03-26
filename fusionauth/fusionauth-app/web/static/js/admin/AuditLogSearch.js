/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the audit log search.
 *
 * @param element the form
 * @constructor
 */
FusionAuth.Admin.AuditLogSearch = function(element) {
  Prime.Utils.bindAll(this);

  this.form = element;
  this.numberOfResults = this.form.queryFirst('input[name="s.numberOfResults"]');

  this.form.query('.date-time-picker').each(function(e) {
    new Prime.Widgets.DateTimePicker(e).initialize();
  });

  // Pagination - rows per page changes.
  var auditLogSection = Prime.Document.queryById('system-audit-content');
  auditLogSection.query('.pagination').each(function(element) {
    element.queryFirst('select').addEventListener('change', this._handlePaginationChange);
  }.bind(this));

  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.auditLog.advancedControls').initialize();

  this.search = this.form.queryFirst('input[name="q"]');
  this.userInput = this.form.queryFirst('input[name="s.user"]');
  if (this.search !== null) {
    this.searchWidget = new FusionAuth.Admin.AJAXSearchWidget(this.search, this.userInput)
        .withRenderer(FusionAuth.Admin.AJAXSearchForm.UserLoginIdSearchRenderer)
        .withResultProvider(function(json) {
          return json['users'];
        })
        .withSearchURI('/ajax/user/search.json')
        .initialize();
  }
};

FusionAuth.Admin.AuditLogSearch.constructor = FusionAuth.Admin.AuditLogSearch;
FusionAuth.Admin.AuditLogSearch.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handlePaginationChange: function(event) {
    var target = new Prime.Document.Element(event.currentTarget);
    this.numberOfResults.setValue(target.getValue());
    this.form.domElement.submit();
  },

  _handleSelectValue: function(value, display) {
    this.search.setValue(display);
    if (this.searchWidget !== null) {
      this.searchWidget.setValue(value);
    }
  },

  _searchErrorHandler: function(xhr, callback) {
    callback('<a href="#" class="disabled">  An error occurred, unable to complete search. Status code <em>' + xhr.status + '</em>. </a>')
  }
};