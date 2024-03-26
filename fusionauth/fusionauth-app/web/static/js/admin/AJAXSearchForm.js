/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * AJAX search.
 *
 * @constructor
 */
FusionAuth.Admin.AJAXSearchForm = function() {
  Prime.Utils.bindAll(this);
  this.options = {
    sort: 'elastic'
  };
  this.searchCriteria = {};
};
FusionAuth.Admin.AJAXSearchForm.constructor = FusionAuth.Admin.AJAXSearchForm;

FusionAuth.Admin.AJAXSearchForm.prototype = {
  /**
   * Initializes the search.
   *
   * @param queryString {string} Optional queryString to initialize the search with.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  initialize: function(queryString) {
    this.form.addEventListener('submit', this._handleFormSubmit);
    this.rawQueryLabel = this.form.queryFirst('#raw-query label');
    this.rawQueryPre = this.form.queryFirst('#raw-query pre');
    this.form.query('a[name="reset"]').addEventListener('click', this._handleResetClick);
    this.inputs = {};
    this.selects = {};
    this.form.query('input[type=text]').each(function(input) {
      this.inputs[input.getAttribute('name')] = input;
    }.bind(this));
    this.form.query('select').each(function(select) {
      this.selects[select.getAttribute('name')] = select;
    }.bind(this));

    this.errorDialog = new Prime.Widgets.HTMLDialog(Prime.Document.queryById('error-dialog')).initialize();
    this.inProgress = new Prime.Widgets.InProgress(this.container).withMinimumTime(250);
    this.bulkActionsDiv = Prime.Document.queryFirst('.bulk-actions');
    this.numberSelectedDiv = Prime.Document.queryFirst('[data-number-selected]');
    this.resetSearchCriteria();

    // Reset and set the search query if it was passed in (from the global form at the top of the page)
    if (queryString) {
      this.searchCriteria['s.queryString'] = queryString;
      this.saveCriteria();
      this.inputs['s.queryString'].setValue(queryString).focus();
    } else {
      this.loadSearchCriteria();
    }

    return this;
  },

  loadSearchCriteria: function() {
    var locallyStored = Prime.Storage.getSessionObject(this.storageKey)
    if (!locallyStored) {
      return;
    }

    this.searchCriteria = locallyStored;
    for (const property in this.searchCriteria) {
      if (this.searchCriteria.hasOwnProperty(property) && this.inputs[property]) {
        this.inputs[property].setValue(this.searchCriteria[property]);
      }
      if (this.searchCriteria.hasOwnProperty(property) && this.selects[property]) {
        this.selects[property].setSelectedValues(this.searchCriteria[property]);
      }
    }
  },

  /**
   * Sets the default search criteria.
   */
  resetSearchCriteria: function() {
    this.searchCriteria = Object.assign({}, this.defaultSearchCriteria);
  },

  /**
   * Saves the current search criteria.
   */
  saveCriteria: function() {
    Prime.Storage.setSessionObject(this.storageKey, this.searchCriteria);
  },

  /**
   * Executes the search using the current search criteria in local storage.
   */
  search: function() {
    if (this.bulkActionsDiv !== null) {
      this.bulkActionsDiv.hide();
    }

    if (this.numberSelectedDiv !== null) {
      this.numberSelectedDiv.hide();
    }

    new Prime.Ajax.Request(this.form.getAttribute('action'), 'GET')
        .withData(this.searchCriteria)
        .withInProgress(this.inProgress)
        .withSuccessHandler(this._handleAJAXFormSuccess)
        .withErrorHandler(this._handleAJAXError)
        .go();
  },

  /**
   * Sets the outer container that contains the form and the results div.
   *
   * @param container {PrimeElement} The container.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withContainer: function(container) {
    this.container = container;
    return this;
  },

  /**
   * Sets the default search criteria.
   *
   * @param defaultSearchCriteria {Object} The default search criteria.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withDefaultSearchCriteria: function(defaultSearchCriteria) {
    this.defaultSearchCriteria = defaultSearchCriteria;
    return this;
  },

  /**
   * Sets the form.
   *
   * @param form {PrimeElement} The form.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withForm: function(form) {
    this.form = form;
    return this;
  },

  /**
   * Sets up a callback that is called before the form is reset.
   *
   * @param callback {Function} The callback.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withFormResetCallback: function(callback) {
    this.options.formResetCallback = callback;
    return this;
  },

  /**
   * Sets up a callback that is called before the form is submitted.
   *
   * @param callback {Function} The callback.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withFormSubmitCallback: function(callback) {
    this.options.formSubmitCallback = callback;
    return this;
  },

  /**
   * Sets the result div where the search results are output.
   *
   * @param resultDiv {PrimeElement} The result div element.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withResultDiv: function(resultDiv) {
    this.resultDiv = resultDiv;
    return this;
  },

  /**
   * Changes the sort handling mode from Elastic Search to Database.
   *
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withDatabaseSort: function() {
    this.options.sort = 'database';
    return this;
  },

  /**
   * Sets the key for storing the search in local storage.
   *
   * @param storageKey {string} The key.
   * @returns {FusionAuth.Admin.AJAXSearchForm} This.
   */
  withStorageKey: function(storageKey) {
    this.storageKey = storageKey;
    return this;
  },

  withPostSuccessCallback: function(callback) {
    this.options.postSuccessCallback = callback;
    return this;
  },

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAJAXError: function(xhr) {
    if (xhr.status === 503 || xhr.status === 401) {
      location.reload();
    } else {
      this._handleAJAXFormSuccess(xhr);

      var dialog = Prime.Document.queryById('search-errors');
      if (dialog !== null) {
        // Render the page as normal and show the dialog
        new Prime.Widgets.HTMLDialog(dialog)
            .initialize()
            .open();
      } else {
        // Show a dialog
        this.errorDialog.open();
      }
    }
  },

  _handleAJAXFormSuccess: function(xhr) {
    // Try to keep the current scroll position after an AJAX load.
    var scrollTop = document.body.scrollTop;
    this.resultDiv.setHTML(xhr.responseText);

    if (this.rawQueryPre) {
      var rawQuery = this.resultDiv.queryFirst('input[type="hidden"]')
                         .getValue()
                         .replace('<', '&lt;')
                         .replace('>', '&gt;');
      var isJson = false;
      try {
        JSON.parse(rawQuery);
        isJson = true;
      } catch (error) {
      }

      this.rawQueryLabel.setHTML(isJson ? this.rawQueryLabel.getDataAttribute('labelJson') : this.rawQueryLabel.getDataAttribute('labelString'));
      this.rawQueryPre.setHTML(rawQuery);
      if (this.options.postSuccessCallback) {
        this.options.postSuccessCallback.apply();
      }
    }

    // The minimal delay allows us to keep the scroll position.
    setTimeout(function() {
      document.body.scrollTop = scrollTop;
    }, 0);

    // Set up the listing
    this.table = this.resultDiv.queryFirst('table');
    new FusionAuth.UI.Listing(this.table)
        .withCheckEventCallback(this._handleCheckEventCallback)
        .initialize();

    // Pagination
    this.resultDiv.query('.pagination').each((function(pagination) {
      pagination.query('a').each((function(a) {
        if(a.getDataAttribute('prevResultPage') === null && a.getDataAttribute('nextResultPage') === null) {
          a.addEventListener('click', this._handlePaginationClicks);
        }
      }).bind(this));
      pagination.queryFirst('select').addEventListener('change', this._handlePaginationChange);
    }).bind(this));

    // Sort
    this.table.query('[data-sort]').addEventListener('click', this._handleColumnClick);

    // Handle cell click to select checkbox
    this.table.addEventListener('click', this._handleTableClick);
  },

  _handleCheckEventCallback: function(state) {
    var bulkActions = Prime.Document.queryFirst('.bulk-actions');
    var numberSelected = Prime.Document.queryFirst('[data-number-selected]');

    if (state.checkedCount === 0) {
      bulkActions.query('a').addClass('disabled');
      this.table.removeClass('checkboxes');
      numberSelected.hide();
    } else {
      bulkActions.show().setStyle('display', 'inline-block');
      bulkActions.query('a').removeClass('disabled');
      this.table.addClass('checkboxes');
      numberSelected.show().queryFirst('em').setHTML(state.checkedCount);
    }
  },

  _handleColumnClick: function(event) {
    var target = new Prime.Document.Element(event.target);
    // may be a select all checkbox, let it pass.
    if (!target.is('th, a')) {
      return;
    }

    Prime.Utils.stopEvent(event);
    var th = new Prime.Document.Element(event.currentTarget);

    // Toggle Ascending / Descending if we're clicking on the same sort field column
    var sortFields = th.getDataAttribute('sort').split(',');
    var sortOrder = 'asc';
    if (this.options.sort === 'elastic') {
      if (this.searchCriteria['s.sortFields[0].name'] === sortFields[0]) {
        if (this.searchCriteria['s.sortFields[0].order'] === 'asc') {
          sortOrder = 'desc';
        }
      }

      this.searchCriteria['s.sortFields[0].name'] = sortFields[0];
      this.searchCriteria['s.sortFields[0].order'] = sortOrder;
      this.searchCriteria['s.sortFields[1].name'] = sortFields[1];
      this.searchCriteria['s.sortFields[1].order'] = sortOrder;
    } else {
      // Handle database search
       var orderBy = this.searchCriteria['s.orderBy'];
      if (orderBy && orderBy.indexOf(sortFields[0]) >= 0) {
        if (orderBy.indexOf('asc') >= 0) {
          this.searchCriteria['s.orderBy'] = orderBy.replaceAll('asc', 'desc');
        } else {
          this.searchCriteria['s.orderBy'] = orderBy.replaceAll('desc', 'asc');
        }
      } else {
        this.searchCriteria['s.orderBy'] = sortFields[0] + ' asc';
      }
    }

    this.saveCriteria();
    this.search();
  },

  _handleFormSubmit: function(event) {
    Prime.Utils.stopEvent(event);

    this.resetSearchCriteria();
    for (const property in this.inputs) {
      if (this.inputs.hasOwnProperty(property)) {
        this.searchCriteria[property] = this.inputs[property].getValue();
      }
    }

    for (const property in this.selects) {
      if (this.selects.hasOwnProperty(property)) {
        this.searchCriteria[property] = this.selects[property].getSelectedValues()[0];
      }
    }

    if (this.options.formSubmitCallback) {
      this.options.formSubmitCallback(this.searchCriteria);
    }

    this.saveCriteria();
    this.search();
  },

  _handlePaginationChange: function() {
    var target = new Prime.Document.Element(event.currentTarget);
    this.searchCriteria['s.numberOfResults'] = target.getSelectedValues()[0];
    this.searchCriteria['s.startRow'] = 0;
    this.searchCriteria.currentPage = 0;
    if (this.options.formResetCallback) {
      this.options.formResetCallback();
    }
    this.saveCriteria();
    this.search();
  },

  _handlePaginationClicks: function(event) {
    Prime.Utils.stopEvent(event);

    var target = new Prime.Document.Element(event.currentTarget);
    var url = target.getAttribute('href').substring(1);
    var index = url.indexOf('=');
    var key = url.substring(0, index);
    var value = url.substring(index + 1);
    if (key === 's.searchAfter') {
      var entries = JSON.parse(value);
      entries.forEach((e, i) => this.searchCriteria[`s.searchAfter[${i}]`] = e);
    } else {
      this.searchCriteria[key] = value;
    }
    Object.keys(this.searchCriteria).forEach(key => {
      if (key.startsWith('s.nextResults')) {
        delete this.searchCriteria[key];
      }
    })
    this.saveCriteria();
    this.search();
  },

  _handleResetClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.resetSearchCriteria();
    for (const property in this.inputs) {
      if (this.inputs.hasOwnProperty(property)) {
        this.inputs[property].setValue('');
      }
    }

    for (const property in this.selects) {
      if (this.selects.hasOwnProperty(property)) {
        this.selects[property].setSelectedValues();
      }
    }

    if (this.options.formResetCallback) {
      this.options.formResetCallback();
    }

    this.saveCriteria();
    this.search();
  },

  _handleTableClick: function(event) {
    var target = new Prime.Document.Element(event.target);
    if (target.is('td.icon')) {
      target.queryFirst('input[type="checkbox"]').fireEvent('click');
    }
  }
};
