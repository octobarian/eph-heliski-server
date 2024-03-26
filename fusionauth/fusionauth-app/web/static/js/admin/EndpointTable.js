/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Constructs a new EndpointTable object.
 *
 * @param {Object} element The table to add an event listener to
 * @constructor
 */
FusionAuth.Admin.EndpointTable = function(element) {
  Prime.Utils.bindAll(this);

  this.element = element;
  this.element.addEventListener('click', this._handleClick);
};
FusionAuth.Admin.EndpointTable.constructor = FusionAuth.Admin.EndpointTable;

FusionAuth.Admin.EndpointTable.prototype = {
  /**
   * Handles the click event on an HTTP Method cell. This isn't so pretty... sorry about that.
   *
   * @private
   */
  _handleClick: function(event) {
    var target = new Prime.Document.Element(event.target);

    if (target.is('input[type=checkbox]')) {
      return;
    }

    // Handle select all columns
    var col = target.is('th[data-select-col]') ? target : target.queryUp('th[data-select-col]');
    var state;
    if (col !== null) {
      Prime.Utils.stopEvent(event);
      var httpMethod = col.getAttribute("data-select-col");
      state = target.getAttribute("data-checked") || "true";
      target.setAttribute("data-checked", state === "true" ? "false" : "true");
      this.element.query("input[type=checkbox][value=" + httpMethod + "]").each(function(checkbox) {
        checkbox.setChecked(state === "true");
      });
      return;
    }

    // Handle select all rows - td.httpMethod cells have already been handled
    var row = target.queryUp('tr');
    if (target.is('[data-select-row]') && row !== null) {
      state = row.getAttribute("data-checked") || "true";
      row.setAttribute("data-checked", state === "true" ? "false" : "true");
      row.query("td input[type=checkbox]").each(function(checkbox) {
        checkbox.setChecked(state === "true");
      });
      return;
    }

    // If this is a http method cell, check the box
    var td = target.is('td') ? target : target.queryUp('td');
    if (td !== null) {
      var checkbox = td.queryFirst('input[type=checkbox]');
      checkbox.setChecked(!checkbox.isChecked()); // toggle
      Prime.Utils.stopEvent(event);
    }
  }
};