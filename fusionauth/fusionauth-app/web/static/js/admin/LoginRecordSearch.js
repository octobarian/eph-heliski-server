/*
 * Copyright (c) 2019-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the Login Record search.
 *
 * @param element the form
 * @constructor
 */
FusionAuth.Admin.LoginRecordSearch = function(element) {
  Prime.Utils.bindAll(this);

  this.form = element;
  this.numberOfResults = this.form.queryFirst('input[name="s.numberOfResults"]');

  this.form.query('.date-time-picker').each(function(e) {
    new Prime.Widgets.DateTimePicker(e).initialize();
  });

  // Pagination - rows per page changes.
  var loginRecordSection = Prime.Document.queryById('login-record-content');
  loginRecordSection.query('.pagination').each(function(element) {
    element.queryFirst('select').addEventListener('change', this._handlePaginationChange);
  }.bind(this));

  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.loginRecord.advancedControls').initialize();

  this.search = this.form.queryFirst('input[name="q"]');
  this.userInput = this.form.queryFirst('input[name="s.userId"]');
  if (this.search !== null) {
    this.searchWidget = new FusionAuth.Admin.AJAXSearchWidget(this.search, this.userInput)
        .withRenderer(FusionAuth.Admin.AJAXSearchForm.UserIdSearchRenderer)
        .withResultProvider(function(json) {
          return json['users'];
        })
        .withSearchURI('/ajax/user/search.json')
        .initialize();
  }
};

FusionAuth.Admin.LoginRecordSearch.constructor = FusionAuth.Admin.LoginRecordSearch;
FusionAuth.Admin.LoginRecordSearch.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handlePaginationChange: function(event) {
    var target = new Prime.Document.Element(event.currentTarget);
    this.numberOfResults.setValue(target.getValue());
    this.form.domElement.submit();
  }
};