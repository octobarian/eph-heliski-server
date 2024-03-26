/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
'use strict';

/**
 * Defines an expandable table. The table element must be passed in. The table element must have 2 data attributes:
 *
 * data-add-button - this defines the ID of the add button that is used to add rows to the table
 * data-template - this defines the ID of the Handlebars template script tag used to add the new rows
 *
 * @param {PrimeElement} table The table element.
 * @constructor
 */
FusionAuth.UI.ExpandableTable = function(table) {
  Prime.Utils.bindAll(this);

  this.table = table;
  this.addCallback = null;
  this.addCallbackContext = null;
  this.deleteCallback = null;
  this.deleteCallbackContext = null;
  this.deleteSelector = this.table.getDataAttribute('deleteButton') || '.delete-button';
  this.updateCallback = null;
  // Called after the DOM has been updated
  this.postDeleteCallback = null;

  // Get the table body and add button
  this.tableBody = this.table.getChildren('tbody')[0];
  var addButtonId = this.table.getDataAttribute('addButton');
  if (addButtonId !== null) {
    this.addButton = Prime.Document.queryById(addButtonId);
    if (this.addButton === null) {
      throw 'Invalid data-add-button attribute on the <table> element. A button with an id of [' + addButtonId + '] doesn\'t exist';
    }
    this.addButton.addEventListener('click', this._handleAddClickEvent);
  } else {
    this.addButton = null;
  }

  // Get the template
  var templateId = this.table.getDataAttribute('template');
  if (templateId === null) {
    throw 'Missing data-template attribute on the <table> element';
  }
  var templateElement = Prime.Document.queryById(templateId);
  if (templateElement === null) {
    throw 'Invalid data-template attribute on the <table> element';
  }
  this.template = Handlebars.compile(templateElement.getHTML());

  // Get the optional empty row
  this.emptyRow = this.table.queryFirst('.empty-row');

  // Collect the immediate body rows so we can support nested tables
  var rows = this.table.queryFirst('tbody').getChildren('tr');

  // Delete buttons
  rows.each(this._bindDeleteButton);

  this.rowCount = rows.length;
  if (this.emptyRow !== null) {
    this.rowCount = this.rowCount - 1;

    // Hide it if there are other rows in the table
    if (this.rowCount > 0) {
      this.emptyRow.hide();
    }
  }

  this._registerHelpers();
};

FusionAuth.UI.ExpandableTable.constructor = FusionAuth.UI.ExpandableTable;
FusionAuth.UI.ExpandableTable.prototype = {
  /**
   * Adds a new row using the Handlebars template for the table.
   *
   * @return {Prime.Document.Element} The newly added row.
   */
  addRow: function(rowData) {
    // Build the row data and add the index and then insert it
    var data = this._buildRowData(rowData);
    data.index = this.rowCount++;

    var row = this._buildRow(data, function(newRowHTML) {
      this.tableBody.appendHTML(newRowHTML);
      var rows = this.tableBody.getChildren('tr');
      return rows[rows.length - 1];
    }.bind(this));

    if (this.addCallback !== null) {
      this.addCallback(row, data);
    }

    return row;
  },

  /**
   * Updates an existing row using the Handlebars template for the table.
   *
   * @param {Prime.Document.Element|PrimeElement} The row to update.
   * @return {Prime.Document.Element} The updated row.
   */
  updateRow: function(row, rowData) {
    // Before we update the row, close tooltips
    row.query('[data-tooltip]').each(function(element) {
      if (element.domElement.toolTipObject) {
        element.domElement.toolTipObject.hide();
      }
    });

    var previousSibling = row.getPreviousSibling();
    var nextSibling = row.getNextSibling();

    // Build the row data, add the index, delete the old, and then insert it
    var data = this._buildRowData(rowData);
    data.index = this._determineIndex(row);

    row.removeFromDOM();
    row = this._buildRow(data, function(newRowHTML) {
      if (previousSibling !== null) {
        previousSibling.domElement.insertAdjacentHTML('afterend', newRowHTML);
        return previousSibling.getNextSibling();
      } else if (nextSibling !== null) {
        nextSibling.domElement.insertAdjacentHTML('beforebegin', newRowHTML);
        return nextSibling.getPreviousSibling();
      } else {
        this.tableBody.appendHTML(newRowHTML);
        var rows = this.tableBody.getChildren('tr');
        return rows[rows.length - 1];
      }
    }.bind(this));

    if (this.updateCallback !== null) {
      this.updateCallback(row, data);
    }

    return row;
  },

  /**
   * Deletes the given row.
   *
   * @param row {Prime.Document.Element} The element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  deleteRow: function(row) {
    if (this.deleteCallback !== null) {
      this.deleteCallback(row);
    }

    // Before we delete the row, close tooltips
    row.query('[data-tooltip]').each(function(element) {
      if (element.domElement.toolTipObject) {
        element.domElement.toolTipObject.hide();
      }
    });

    row.removeFromDOM();
    if (Prime.Document.query('tbody > tr', this.tableBody).length === 1) {
      if (this.emptyRow !== null) {
        this.emptyRow.show();
      }
    }

    if (this.postDeleteCallback !== null) {
      this.postDeleteCallback(row);
    }

    return this;
  },

  /**
   * @param callback {Function} The callback function that is called when a row is added. This function is passed the
   * row as Prime.Document.Element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  withAddCallback: function(callback) {
    this.addCallback = callback;
    return this;
  },

  /**
   * @param callback {Function} The callback function that is called when a row is deleted. This function is passed the
   * row as Prime.Document.Element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  withDeleteCallback: function(callback) {
    this.deleteCallback = callback;
    return this;
  },

  /**
   * @param callback {Function} The callback function that is called after the DOM has been updated when a row is deleted. This function is passed the
   * row as Prime.Document.Element. This element will no longer be attached to the DOM.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  withPostDeleteCallback: function(callback) {
    this.postDeleteCallback = callback;
    return this;
  },

  /**
   * @param callback {Function} The callback function that is called when a row is updated. This function is passed the
   * row as Prime.Document.Element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  withUpdateCallback: function(callback) {
    this.updateCallback = callback;
    return this;
  },

  _bindDeleteButton: function(row) {
    // Delete buttons
    // - Allow the table to provide a selector which is helpful when tables are nested. Default to 'delete-button'.
    // The row array may contain an empty row, so ignore a null value.
    var button = row.queryFirst(this.deleteSelector);
    if (button !== null) {
      button.addEventListener('click', this._handleDeleteClickEvent);
    }
  },

  _buildRow: function(data, insertionFunction) {
    var newRowHTML = this.template(data);
    var row = insertionFunction(newRowHTML);
    if (this.emptyRow !== null) {
      this.emptyRow.hide();
    }

    var input = row.queryFirst('input');
    if (input !== null) {
      input.focus();
    }

    this._bindDeleteButton(row);

    return row;
  },

  _buildRowData: function(rowData) {
    var data = {};

    // Add the table data
    var tableDataSet = this.table.getDataSet();
    for (var key in tableDataSet) {
      if (tableDataSet.hasOwnProperty(key)) {
        data[key] = tableDataSet[key];
      }
    }

    // Assume any extra data passed in comes from a single object argument
    if (rowData !== undefined) {
      for (var arg in rowData) {
        if (rowData.hasOwnProperty(arg)) {
          data[arg] = rowData[arg];
        }
      }
    }

    return data;
  },

  _determineIndex: function(row) {
    var rows = this.tableBody.query('tr');
    for (var i = 0; i < rows.length; i++) {
      if (row.domElement === rows[i].domElement) {
        return i;
      }
    }

    return -1;
  },

  /**
   * Handles the click event on the add button.
   *
   * @private
   */
  _handleAddClickEvent: function(event) {
    this.addRow();
    Prime.Utils.stopEvent(event);
  },

  /**
   * Handles the click event on the delete button.
   *
   * @param event The event.
   * @private
   */
  _handleDeleteClickEvent: function(event) {
    var row = Prime.Document.queryUp('tr', event.currentTarget);
    this.deleteRow(row);
    Prime.Utils.stopEvent(event);
  },

  _registerHelpers: function() {
    // Empty string, null, etc --> &hellip;
    Handlebars.registerHelper('default_if_empty', function(value) {
      if (value === null || value.length === 0) {
        return new Handlebars.SafeString("&ndash;");
      }

      if (Array.isArray(value)) {
        return value.join(", ");
      } else {
        return value;
      }
    });

    Handlebars.registerHelper('increment', function(value) {
      return ++value;
    });

    Handlebars.registerHelper('cap', function(value) {
      return value.substring(0, 1).toUpperCase() + value.substring(1, value.length);
    });
  }
};
