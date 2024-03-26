/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

FusionAuth.UI.Chart = function(element) {
  Prime.Utils.bindAll(this);
  this.element = element;
  this.canvas = this.element.queryFirst('canvas');
  this.context = this.canvas.domElement.getContext("2d");

  this.configuration = {};
  this.toggles = null;
  this._setInitialOptions();
};

FusionAuth.UI.Chart.constructor = FusionAuth.UI.Chart;
FusionAuth.UI.Chart.prototype = {

  changeType: function(type) {
    this.configuration.type = type;
    this._saveState(type);
    this.destroy();
    this.initialize();
    return this;
  },

  destroy: function() {
    this.chart.destroy();
    return this;
  },

  initialize: function() {
    this.toggles = this.element.queryFirst('.chart-toggle');
    if (this.toggles !== null) {
      this.toggles.addEventListener('click', this._handleToggleClick);
    }

    this.localStorageSupported = Prime.Utils.isDefined(Storage) && this.options['localStorageKey'] !== null;
    var savedState = this._retrieveState();

    this.configuration.type = savedState || this.configuration.type;
    this.chart = new Chart(this.context, this.configuration);
    // initialize the current chart mode
    if (this.toggles !== null) {
      var current = this.toggles.queryFirst('[data-chart="' + this.configuration.type + '"]');
      if (current !== null) {
        current.addClass('current');
      }
    }

    return this;
  },

  withConfiguration: function(configuration) {
    this.configuration = configuration;
    return this;
  },

  withLocalStorageKey: function(key) {
    this.options['localStorageKey'] = key;
    return this;
  },

  _handleToggleClick: function(event) {
    Prime.Utils.stopEvent(event);
    var target = new Prime.Document.Element(event.target);
    if (target.is('a')) {
      this.toggles.query('a.current').removeClass('current');
      target.addClass('current');
      this.changeType(target.getDataAttribute('chart'));
    }
  },

  _retrieveState: function() {
    var savedState = null;
    if (this.localStorageSupported && this.options['localStorageKey'] !== null) {
      savedState = sessionStorage.getItem(this.options['localStorageKey']);
    }

    return Prime.Utils.isDefined(savedState) ? savedState : null;
  },

  _saveState: function(type) {
    if (this.localStorageSupported && this.options['localStorageKey'] !== null) {
      return sessionStorage.setItem(this.options['localStorageKey'], type);
    }
  },

  _setInitialOptions: function() {
    // Defaults
    this.options = {
      'localStorageKey': null
    };

    var userOptions = Prime.Utils.dataSetToOptions(this.element);
    for (var option in userOptions) {
      if (userOptions.hasOwnProperty(option)) {
        this.options[option] = userOptions[option];
      }
    }
  }
};
