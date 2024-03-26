/*
 * Copyright (c) 2021-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles a generic search and pagination forms that hit the database.
 *
 * @param {Prime.Document.Element|PrimeElement} form The form Element.
 * @param {string} localStorageKey The local storage key to put settings under for this form.
 * @constructor
 */
FusionAuth.Admin.SearchForm = function(form, localStorageKey) {
  Prime.Utils.bindAll(this);

  this.form = form;
  this.numberOfResults = this.form.queryFirst('input[name="s.numberOfResults"]');

  this.form.query('.date-time-picker').each(function(e) {
    new Prime.Widgets.DateTimePicker(e).initialize();
  });

  // Find the location of the results
  var id = this.form.getDataSet().searchResults;
  if (!id) {
    throw "Missing searchResults attribute on the form";
  }

  // Find the search results
  var searchResults = Prime.Document.queryById(id);
  if (searchResults === null) {
    throw "Invalid searchResults attribute because the element with id [" + id + "] doesn't exist";
  }

  // Handle the result table
  var table = searchResults.queryFirst('table.listing');
  if (table !== null) {
    new FusionAuth.UI.Listing(table).initialize();
  }

  // Setup the pagination buttons
  searchResults.query('.pagination').each(function(element) {
    element.queryFirst('select').addEventListener('change', this._handlePaginationChange);
  }.bind(this));

  // Handle advanced search controls
  if (this.form.queryFirst('[data-expand-open]') !== null) {
    new FusionAuth.UI.AdvancedControls(this.form, localStorageKey).initialize();
  }

  // Handle "Show Search Query"
  this.showSearchQuery = Prime.Document.queryById('show-raw-query');
  if (this.showSearchQuery !== null) {
    // If defined, if a storage key was provided, that indicates we should manage the state.
    this.showSearchQueryStorageKey = this.showSearchQuery.getDataAttribute('storageKey');
    if (this.showSearchQueryStorageKey !== null) {
      this.showSearchQueryState = Prime.Storage.getSessionObject(this.showSearchQueryStorageKey) || {open: false};
      if (this.showSearchQueryState.open) {
        this.showSearchQuery.setChecked(true);
        Prime.Document.queryById(this.showSearchQuery.getDataAttribute('slideOpen')).addClass('open');

      }
      this.showSearchQuery.addEventListener('click', this._handleShowSearchQueryClick);
    }
  }
};

FusionAuth.Admin.SearchForm.constructor = FusionAuth.Admin.SearchForm;
FusionAuth.Admin.SearchForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handlePaginationChange: function(event) {
    var target = new Prime.Document.Element(event.currentTarget);
    this.numberOfResults.setValue(target.getValue());
    this.form.domElement.submit();
  },

  _handleShowSearchQueryClick: function() {
    this.showSearchQueryState.open = !!this.showSearchQuery.isChecked();
    Prime.Storage.setSessionObject(this.showSearchQueryStorageKey, this.showSearchQueryState);
  }
};
