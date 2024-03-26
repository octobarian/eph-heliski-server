/*
 * Copyright (c) 2018-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

/**
 * By default sorting is enabled, if the element passed in has a data-sortable attribute with anything not ''' 'true'
 * sorting will be disabled. e.g. data-sortable="false"
 */
FusionAuth.UI.Listing = function(element) {
  Prime.Utils.bindAll(this);

  this.element = element;

  this.rows = [];
  this.ajaxCallback = null;
  this.element.query('tbody tr').each(function(row) {
    this.addRow(row);
  }.bind(this));

  // Key: URI + [table name] (if defined) --> Example: /admin/application/__table
  this.localStorageSupported = typeof(Storage) !== 'undefined';
  var tableName = this.element.getDataAttribute('name') || 'table';
  this.localStorageKey = window.location.pathname + '__' + tableName;

  this.tableWidget = new Prime.Widgets.Table(this.element)
      .withLocalStorageKey(this.localStorageKey);
};

FusionAuth.UI.Listing.constructor = FusionAuth.UI.Listing;
FusionAuth.UI.Listing.prototype = {
  addRow: function(row) {
    this.rows.push(new FusionAuth.UI.ListingRow(row, this));
    return this;
  },

  deleteRow: function(row) {
    var newRows = [];
    for (var i = 0; i < this.rows.length; i++) {
      if (this.rows[i].element.domElement !== row.domElement) {
        newRows.push(this.rows[i]);
      }
    }
    this.rows = newRows;
  },

  initialize: function() {
    this.tableWidget.initialize();
  },

  withAJAXCallback: function(callback) {
    this.ajaxCallback = callback;
    return this;
  },

  withCheckEventCallback: function(callback) {
    this.tableWidget.withCheckEventCallback(callback);
    return this;
  }
};

FusionAuth.UI.ListingRow = function(element, listing) {
  Prime.Utils.bindAll(this);

  this.listing = listing;
  this.element = element;

  // Setup AJAX delete/edit
  element.query('a[data-ajax-form=true]').each(function(e) {
    e.addEventListener('click', this._handleAJAXClickEvent);
  }.bind(this));

  // Setup AJAX view
  element.query('a[data-ajax-view=true]').each(function(e) {
    e.addEventListener('click', this._handleAJAXClickEvent);
  }.bind(this));
};

FusionAuth.UI.ListingRow.constructor = FusionAuth.UI.ListingRow;
FusionAuth.UI.ListingRow.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  /**
   *
   * @param {MouseEvent} event
   * @returns {boolean}
   * @private
   */
  _handleAJAXClickEvent: function(event) {
    Prime.Utils.stopEvent(event);

    var anchor = new Prime.Document.Element(event.currentTarget);
    var uri = anchor.getAttribute('href');
    var dialog = new Prime.Widgets.AJAXDialog();
    var dataSet = anchor.getDataSet();
    var additionalClasses = [];
    if (dataSet.ajaxWideDialog === 'true') {
      additionalClasses.push('wide');
    }
    if (dataSet.resizeDialog === 'true') {
      additionalClasses.push('resize');
    }
    if (additionalClasses.length > 0) {
      dialog.withAdditionalClasses(additionalClasses.join(' '));
    }
    if (dataSet.ajaxForm === 'true') {
      dialog.withFormHandling(true);
    }
    dialog.withCallback(this._handleDialogOpen).open(uri);
  },

  _handleDialogOpen: function(dialog) {
    dialog.element.query('a[data-spoiler').each(function(element) {
      element.domElement.spoilerObject = new FusionAuth.UI.Spoiler(element, element.getDataAttribute('spoilerStorageKey')).initialize();
    });

    if (this.listing.ajaxCallback) {
      this.listing.ajaxCallback();
    }
  }
};
