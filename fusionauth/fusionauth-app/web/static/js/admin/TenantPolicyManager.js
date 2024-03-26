/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * @constructor
 */
FusionAuth.Admin.TenantPolicyManager = function() {
  Prime.Utils.bindAll(this);

  this.reorderConnector = null;
  this.form =  Prime.Document.queryById('tenant-form');
  this.table = Prime.Document.queryById('connector-policy-table');

  // Setup the connector policy expandable table
  this.expandableConnectorPolicyTable = new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('connector-policy-table'))
      .withAddCallback(this._handleRowModifications)
      .withUpdateCallback(this._handleRowModifications)
      .withPostDeleteCallback(this._handleRowModifications);

  Prime.Document.queryById('add-connector-policy').addEventListener('click', this._handleAddConnectorPolicyClick);

  // Register a click handler for the edit button
  this.table.addDelegatedEventListener('click', 'a.edit-button', this._handleEditPolicyClick);
};

FusionAuth.Admin.TenantPolicyManager.constructor = FusionAuth.Admin.TenantPolicyManager;
FusionAuth.Admin.TenantPolicyManager.prototype = {
  onTabSelect: function() {
    // Hook up row re-order
    if (this.reorderConnector === null) {
      this.reorderConnector = new Prime.Widgets.Reorder(this.table)
          .withItemSelector('tbody tr.connector-policy')
          .withReorderCallback(this._handleRowModifications)
          .initialize();
    }
  },

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleAddConnectorPolicyClick: function(event) {
    Prime.Utils.stopEvent(event);
    var target = new Prime.Document.Element(event.target);
    this.addConnectorDialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withCallback(this._handlePolicyDialogOpen)
        .withFormSuccessCallback(this._handlePolicyDialogSubmitSuccess)
        .open(target.getAttribute('href'));
  },

  _handleEditPolicyClick: function(event, target) {
    Prime.Utils.stopEvent(event);

    var edit = new Prime.Document.Element(target);

    // Add current values to the Edit URL
    var row = edit.queryUp('tr');
    var url = edit.getAttribute('href')
        + '?connectorId=' + encodeURIComponent(row.queryFirst('input[name$=connectorId]').getValue())
        + '&connectorMigrate=' + encodeURIComponent(row.queryFirst('input[name$=migrate]').getValue())
        + '&connectorDomains=' + encodeURIComponent(row.queryFirst('input[name^=connectorDomains]').getValue());

    this.addConnectorDialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withCallback(this._handlePolicyDialogOpen)
        .withFormSuccessCallback(this._handlePolicyDialogSubmitSuccess)
        .open(url);
  },

  _handlePolicyDialogOpen: function(dialog) {
    var textarea = dialog.element.queryFirst('textarea');
    textarea.domElement.editor = new FusionAuth.UI.TextEditor(textarea)
          .withOptions({
            'mode': 'properties',
            'lineNumbers': true
          })
          .render();

      // Make these editors auto height with a max of 1000px;
    textarea.domElement.editor.editorElement.setStyles({
        'height': 'auto',
        'min-height': '80px',
        'max-height': '250px'
      });

    textarea.domElement.editor.editorElement.queryFirst('.CodeMirror-scroll').setStyles({
        'height': 'auto',
        'min-height': '80px',
        'max-height': '250px'
      });
  },

  _handlePolicyDialogSubmitSuccess: function(dialog) {
    // Extract the form data and shove it in the DOM
    var form = dialog.element.queryFirst('form');
    var data = this._extractDataFromPolicyDialogForm(form);

    var row = null;
    this.expandableConnectorPolicyTable.table.query('tbody tr').each(function(r) {
      if (r.getDataSet().connectorId === data.connectorId) {
        row = r;
      }
    });

    if (row !== null) {
      this.expandableConnectorPolicyTable.updateRow(row, data);
    } else {
      this.expandableConnectorPolicyTable.addRow(data);
    }

    // Finally close the dialog
    this.addConnectorDialog.close();
  },

  _extractDataFromPolicyDialogForm: function(form) {
    var data = {};
    data.connectorId = form.queryFirst('select[name=connectorId]').getValue();
    data.connectorName = form.queryFirst('input[data-id="' + data.connectorId + '"]').getDataAttribute('name');
    data.connectorType = form.queryFirst('input[data-id="' + data.connectorId + '"]').getDataAttribute('type');
    data.connectorDomains = form.queryFirst('textarea[name=connectorDomains').getValue();
    data.connectorMigrate = form.queryFirst('input[name=connectorMigrate]').isChecked();
    return data;
  },

  _handleRowModifications: function() {
    this.expandableConnectorPolicyTable.table.query('tbody tr').each(function(r, i) {
      r.query('input').each(function(e) {
        e.setAttribute('name', e.getAttribute('name').replace(/\[\d+]/, '[' + i + ']'));
      });
    });

    this.reorderConnector.redraw();
    this._showAddPolicyButton();
  },

  _handleConnectorPolicyRowDeletePostDOMUpdate: function() {
    this.reorderConnector.redraw();
    this._handleRowModifications();
  },

  _hideAddPolicyButton() {
    Prime.Document.queryById('add-connector-policy').addClass('disabled');
    Prime.Document.queryById('add-connector-policy-disabled').removeClass('hidden');
  },

  _showAddPolicyButton() {
    Prime.Document.queryById('add-connector-policy').removeClass('disabled');
    Prime.Document.queryById('add-connector-policy-disabled').addClass('hidden');
  },
};
