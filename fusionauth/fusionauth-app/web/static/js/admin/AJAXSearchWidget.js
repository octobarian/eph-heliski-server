/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Input field with AJAX Search behind it.
 *
 * @constructor
 */
FusionAuth.Admin.AJAXSearchWidget = function(searchInput, hiddenInput) {
  Prime.Utils.bindAll(this);

  this.autoComplete = null;
  this.inProgress = null;
  this.searchInput = searchInput;
  this.hiddenInput = hiddenInput;

  // Default options
  this.options = {
    emptyMessage: 'No users found',
    renderer: null,
    requestFunction: null,
    resultProvider: null,
    selectCallback: null,
    searchURI: null
  };
};

FusionAuth.Admin.AJAXSearchWidget.constructor = FusionAuth.Admin.AJAXSearchWidget;
FusionAuth.Admin.AJAXSearchWidget.prototype = {
  destroy: function() {
    if (this.inProgress !== null) {
      this.inProgress.close();
      this.inProgress = null;
    }
    if (this.autoComplete !== null) {
      this.autoComplete.destroy();
      this.autoComplete = null;
    }
  },

  getValue: function() {
    if (this.hiddenInput.getValue() !== '') {
      return this.hiddenInput.getValue();
    }

    return null;
  },

  initialize: function() {
    this.inProgress = new Prime.Widgets.InProgress(this.searchInput).withMinimumTime(250);
    this.autoComplete = new FusionAuth.UI.AutoComplete(this.searchInput)
        .withInputAvailableCallback(this._handleInput)
        .withSelectValueCallback(this._handleSelectValue)
        .withClearValueCallback(this._handleClearInput)
        .initialize();

    return this;
  },

  setValue: function(value) {
    this.hiddenInput.setValue(value);
  },

  withEmptyMessage: function(emptyMessage) {
    this.options.emptyMessage = emptyMessage;
    return this;
  },

  withRequestFunction: function(requestFunction) {
    this.options.requestFunction = requestFunction;
    return this;
  },

  withResultProvider: function(resultProvider) {
    this.options.resultProvider = resultProvider;
    return this;
  },

  withRenderer: function(renderer) {
    this.options.renderer = renderer;
    return this;
  },

  withSearchURI: function(searchURI) {
    this.options.searchURI = searchURI;
    return this;
  },

  withSelectCallback: function(selectCallback) {
    this.options.selectCallback = selectCallback;
    return this;
  },

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleClearInput: function() {
    this.hiddenInput.setValue('');
    this.searchInput.setValue('');

    if (this.options.selectCallback) {
      this.options.selectCallback();
    }
  },

  _handleInput: function(value, callback) {
    var request = this.options.requestFunction
        ? this.options.requestFunction(value)
        : null;

    if (request === null) {
      request = {};
      request['s.numberOfResults'] = 50;
      request['s.startRow'] = 0;
      request['s.queryString'] = value;
    }

    new Prime.Ajax.Request(this.options.searchURI, 'GET')
        .withData(request)
        .withInProgress(this.inProgress)
        .withSuccessHandler(function(xhr) {
          this._handleSearchSuccess(xhr, callback);
        }.bind(this))
        .withErrorHandler(function(xhr) {
          this._handleSearchError(xhr, callback);
        }.bind(this))
        .go();
  },

  _handleSearchError: function(xhr, callback) {
    callback('<a href="#" class="disabled">  An error occurred, unable to complete search. Status code <em>' + xhr.status + '</em>. </a>')
  },

  _handleSearchSuccess: function(xhr, callback) {
    var json = JSON.parse(xhr.responseText);
    var html = '';
    var results = [];

    // The result provider may further prune the results.
    if (json.total > 0) {
      results = this.options.resultProvider(json);
    }

    if (results.length === 0) {
      html += '<a href="#" class="disabled">' + this.options.emptyMessage + '</a>';
    } else {
      for (var i = 0; i < results.length; i++) {
        var data = this.options.renderer(results[i]);
        html += '<a href="#" data-display="' + data.display + '" data-value="' + data.value + '">' + data.display + '</a>';
      }
    }

    callback(html);
  },

  _handleSelectValue: function(value, display) {
    this.hiddenInput.setValue(value);
    this.searchInput.setValue(display);
    if (this.options.selectCallback) {
      this.options.selectCallback(this);
    }
  }
};

/**
* Search renderer to search users where the user's login Id is the search value
* @param user {any} a user matching the search criteria
* @return {any} the search result display text and value (login Id)
*/
FusionAuth.Admin.AJAXSearchForm.UserLoginIdSearchRenderer = function(user) {
  var name = user.firstName || '';
  if (name) {
    name += ' ';
  }

  name += user.lastName || '';
  if (!name) {
    name += user.fullName || '';
  }

  if (name) {
    name += ' ';
  }

  var loginId = user.email || '';
  if (!loginId) {
    loginId = user.username || '';
  }

  if (name) {
    name += ' &lt;' + loginId + '&gt;';
  } else {
    name += loginId;
  }

  return {
    display: name,
    value: loginId
  };
};

/**
* Search renderer to search users where the user's Id is the search value
* @param user {any} a user matching the search criteria
* @return {any} the search result display text and value (user Id)
*/
FusionAuth.Admin.AJAXSearchForm.UserIdSearchRenderer = function(user) {
  // The search results and display are handled the same as UserLoginIdSearchRenderer,
  // but the search value is the user's UUID rather than login Id
  const loginIdRenderer = FusionAuth.Admin.AJAXSearchForm.UserLoginIdSearchRenderer(user);
  return {
    display: loginIdRenderer.display,
    value: user.id
  };
};

FusionAuth.Admin.AJAXSearchForm.TenantSearchRenderer = function(tenant) {
  return {
    display: tenant.name,
    value: tenant.id
  };
}