/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit form form.
 *
 * @constructor
 */
FusionAuth.Admin.FormForm = function() {
  Prime.Utils.bindAll(this);

  // Widgets per step
  this.expandableWidgets = [];
  this.reorderWidgets = [];

  // Top level expandable table
  this.table = Prime.Document.queryById('form-step-table');
  new FusionAuth.UI.ExpandableTable(this.table)
      .withAddCallback(this._handleAddStep)
      .withPostDeleteCallback(this._redraw);

  // Initialize type specific objects
  this.tableLabel = Prime.Document.queryById('form-step-table-label');
  this.addButtonLabel = Prime.Document.queryById('form-step-add-button');
  this.errormessage = Prime.Document.queryFirst('.empty-row', this.table);
  // Hidden type field
  this.formType = Prime.Document.queryFirst('input[name="form.type"]');
  // Type select
  this.formTypeSelect = Prime.Document.queryFirst('select[name="form.type"]');
  if (this.formTypeSelect !== null) {
    this.formTypeSelect.addEventListener('change', this._handleTypeChange);
    this._handleTypeChange();
    // Remove the name attribute, we only want the hidden field to come across in the POST request.
    this.formTypeSelect.removeAttribute('name');
  }
  this._toggleTypeSelect();

  // Hook up row re-order
  this.reorderSteps = new Prime.Widgets.Reorder(this.table)
      .withItemSelector('tr.step-row')
      .withReorderCallback(this._redraw)
      .initialize();

  // Handle all all field buttons at the table level
  this.table.addDelegatedEventListener('click', 'a[data-add-button]', this._handleAddFieldClick);

  // Initialize each row
  this.table.query('tr.step-row').each(this._initStepRow);

  // Add a helper for 'yes' / 'no' required field
  Handlebars.registerHelper('yesNo', function(value) {
    // If incoming value is a string, convert to a boolean.
    if (typeof value === 'string') {
      value = value === 'true';
    }
    return value ? 'Yes' : 'No';
  });
};

FusionAuth.Admin.FormForm.constructor = FusionAuth.Admin.FormForm;
FusionAuth.Admin.FormForm.prototype = {

  _extractDataFromAddFieldDialogForm: function(form) {
    var data = {};
    data.fieldId = form.queryFirst('select[name="fieldId"]').getValue();
    data.fieldName = form.queryFirst('input[data-id="' + data.fieldId + '"]').getDataAttribute('name');
    data.fieldKey = form.queryFirst('input[data-id="' + data.fieldId + '"]').getDataAttribute('key');
    data.fieldControl = form.queryFirst('input[data-id="' + data.fieldId + '"]').getDataAttribute('control');
    data.fieldType = form.queryFirst('input[data-id="' + data.fieldId + '"]').getDataAttribute('type');
    data.required = form.queryFirst('input[data-id="' + data.fieldId + '"]').getDataAttribute('required');
    data.step = form.queryFirst('input[data-step]').getDataAttribute('step');
    return data;
  },

  _handleAddFieldDialogOpen: function(dialog) {
    // Remove fields that are already in-use

    var select = dialog.element.queryFirst('select[name="fieldId"]');
    var options = select.query('option');
    var enabled = options.length;

    this.table.query('tr.field-row input[type="hidden"]').each(function(input) {
      var fieldId = input.getValue();
      select.query('option[value="' + fieldId + '"]').setDisabled(true);
      enabled--;
    });

    for (var i = 0; i < options.length; i++) {
      var option = options[i];
      if (!option.isDisabled()) {
        select.setValue(option.getValue());
        break;
      }
    }

    if (enabled === 0) {
      select.setDisabled(true);
      dialog.element.query('button').setDisabled(true);
    }
  },

  _handleAddFieldDialogSubmitSuccess: function(dialog) {
    // Extract the form data and shove it in the DOM
    var form = dialog.element.queryFirst('form');
    var data = this._extractDataFromAddFieldDialogForm(form);
    var step = this.table.query('tr.step-row')[parseInt(data.step)];

    // Add the row
    step.domElement.expandableTableObject.addRow(data);

    // Redraw the step so we can re-order the fields
    this._redraw();

    // Finally close the dialog
    this.addFieldDialog.close();
  },

  _handleAddFieldClick: function(event, target) {
    Prime.Utils.stopEvent(event);
    var add = new Prime.Document.Element(target);
    var step = add.queryUp('tr[data-index]').getDataAttribute('index');
    var type = this.formType.getValue();
    this.addFieldDialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withCallback(this._handleAddFieldDialogOpen)
        .withFormSuccessCallback(this._handleAddFieldDialogSubmitSuccess)
        .open(add.getAttribute('href') + '?step=' + step + '&type=' + type);
  },

  _handleAddStep: function(row, data) {
    this._initStepRow(row, data.index);
    this._redraw();
  },

  _handleTypeChange: function() {
    var type = this.formTypeSelect.getValue();
    var tLabel = this.tableLabel.getDataAttribute(type + 'Label');
    var addButtonLabel = this.tableLabel.getDataAttribute(type + 'AddButtonLabel');
    this.tableLabel.setHTML(tLabel);
    this.addButtonLabel.queryFirst('span').setHTML(addButtonLabel);
    var error_message = this.tableLabel.getDataAttribute(type + 'Error')
    this.errormessage.setHTML(error_message);

    var rowStepLabel = this.tableLabel.getDataAttribute(type + 'StepLabel');
    Prime.Document.query('.form-row-step-label').each(function(element) {
      element.setHTML(rowStepLabel);
    });

    this.formType.setValue(type);
  },

  _initStepRow: function(row, step) {
    var table = row.queryFirst('table');
    row.domElement.expandableTableObject = new FusionAuth.UI.ExpandableTable(table)
        .withPostDeleteCallback(this._redraw);

    row.domElement.reOrderObject = new Prime.Widgets.Reorder(table)
        .withItemSelector('tr.field-row')
        .withReorderCallback(this._redraw)
        .initialize();
  },

  _redraw: function() {
    // Walk through each step and all fields in each step and re-write their names.
    // - While we're at it, clear the id values, since they will no longer be in sync.
    // - This is brute force, but it is simpler, on each change to order, or delete we will just fix everything.

    var type = this.formTypeSelect.getValue();
    var rowStepLabel = this.tableLabel.getDataAttribute(type + 'StepLabel');

    this.table.query('tr.step-row').each(function(step, i) {
      step.queryFirst('tr > td > label > span.form-row-step-index').setHTML(parseInt(i + 1));
      step.queryFirst('tr > td > label > span.form-row-step-label').setHTML(rowStepLabel);
      step.query('tr.field-row').each(function(field, j) {
        var input = field.queryFirst('input[type="hidden"]');
        // Remove the Id
        input.removeAttribute('id')
            // Set the step
             .setAttribute('name', input.getAttribute('name').replace(/\[\d+]/, '[' + i + ']'))
            // Set the Field order
             .setAttribute('name', input.getAttribute('name').replace(/\[\d+](?!.*\[\d+])/, '[' + j + ']'));
      });

      // After we re-write the field names, redraw the re-order widget
      step.domElement.reOrderObject.redraw();
    });

    // Disable Type if any steps have been created
    this._toggleTypeSelect();

    // Redraw the re-order widget for the steps
    this.reorderSteps.redraw();
  },

  _toggleTypeSelect: function() {
    if (this.formTypeSelect !== null) {
      this.formTypeSelect.setDisabled(this.table.query('tr.step-row').length > 0)
    }
  }
};