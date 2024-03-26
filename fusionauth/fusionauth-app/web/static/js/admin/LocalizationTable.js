/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Provides additional features to the ExpandableTable to support localization tables where one of the columns is a
 * select box with the locales and the other is a text field.
 *
 * @param {Prime.Document.Element|PrimeElement} table The table element.
 * @constructor
 */
FusionAuth.Admin.LocalizationTable = function(table) {
  Prime.Utils.bindAll(this);

  this.table = table;
  this.form = this.table.queryUp('form');
  new FusionAuth.UI.ExpandableTable(table).withAddCallback(this._addCallback);
  Prime.Document.query('select', table).each(function(e) {
    e.addEventListener('change', this._handleSelectChangeEvent);
  }.bind(this));

  if (this.form !== null) {
    this.form.addEventListener('submit', this._formSubmitHandler);
  }
};

FusionAuth.Admin.LocalizationTable.prototype = {
  withFormPreSubmitCallback: function(preSubmitCallback) {
    this.preSubmitCallback = preSubmitCallback;
  },

  /**
   * @private
   */
  _addCallback: function(row) {
    Prime.Document.queryFirst('select', row).addEventListener('change', this._handleSelectChangeEvent);

    // Remove in-use locales
    var inUse = [];
    this.table.query('tr select').each(function(element) {
      var selected = element.getSelectedValues();
      if (selected) {
        inUse.push(selected[0]);
      }
    });

    var select = row.queryFirst('select');
    for (var i = 0; i < inUse.length; i++) {
      var option = select.queryFirst('option[value="' + inUse[i] + '"]');
      if (option !== null) {
        option.domElement.remove();
        this._syncValue(select);
      }
    }
  },

  _formSubmitHandler: function() {
    if (this.preSubmitCallback !== null) {
      this.preSubmitCallback(this.form);
    }
  },

  /**
   * @private
   */
  _handleSelectChangeEvent: function(event) {
    var select = new Prime.Document.Element(event.currentTarget);
    this._syncValue(select);
  },

  _syncValue: function(select) {
    var row = Prime.Document.queryUp('tr', select);
    Prime.Document.query('input', row).each(function(inputElement) {
      var name = inputElement.getAttribute('name');
      var startIndex = name.indexOf("['");
      var newName = name.substring(0, startIndex) + "['" + select.getSelectedValues()[0] + "']";
      inputElement.setAttribute('name', newName);
    });

    Prime.Document.query('textarea', row).each(function(inputElement) {
      var name = inputElement.getAttribute('name');
      var startIndex = name.indexOf("['");
      var newName = name.substring(0, startIndex) + "['" + select.getSelectedValues()[0] + "']";
      inputElement.setAttribute('name', newName);
    });
  }
};

