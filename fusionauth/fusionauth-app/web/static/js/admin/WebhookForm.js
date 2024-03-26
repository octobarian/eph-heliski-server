/*
 * Copyright (c) 2018-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the webhook form by setting up an ExpandableTable for the headers.
 *
 * @constructor
 */
FusionAuth.Admin.WebhookForm = function(element) {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.Element.wrap(element);

  // uncheck the tenants when we select 'Use for All Tenants'. The API enforces this list to be empty if set to global.
  this.globalCheckbox = Prime.Document.queryById('webhook_global').addEventListener('click', this._handleGlobalClick);
  this.tenantSelect = Prime.Document.queryById('webhook_tenantIds');

  // Set up the header table
  new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('header-table'));

  // Set up the editor
  this.certificateEditor = new FusionAuth.UI.TextEditor(element.queryFirst('textarea[name="webhook.sslCertificate"]')).withOptions({'mode': 'text/plain', 'lineWrapping': true});

  // Set up the tabs
  new Prime.Widgets.Tabs(element.queryFirst('.tabs'))
        .withErrorClassHandling('error')
        .withSelectCallback(this._handleTabSelect).initialize();

  // handle a column click
  this.selectAllColumn = this.form.queryFirst('[data-toggle-column]').addEventListener('click', this._handleClick);

  // Handle a row click
  document.querySelector('#events-table tbody').addEventListener('click', this._handleBodyClick.bind(this));
};

FusionAuth.Admin.WebhookForm.constructor = FusionAuth.Admin.WebhookForm;
FusionAuth.Admin.WebhookForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleGlobalClick: function() {
    if (this.globalCheckbox.isChecked()) {
      this.tenantSelect.query('input').setChecked(false);
    }
  },

  _handleClick: function(event) {
    Prime.Utils.stopEvent(event);

    // Handle select all columns
    var state = this.selectAllColumn.getAttribute('data-checked') || 'false';
    this.selectAllColumn.setAttribute('data-checked', state === 'true' ? 'false' : 'true');

    // The default state will be false, but if none of the event checkboxes are checked, flip it so the first click on select-all will check them
    let noneChecked = true;
    document.querySelectorAll('input[type=checkbox][name^="webhook.eventsEnabled"]').forEach(checkbox => {
      if (checkbox.checked) {
        noneChecked = false;
      }
    });

    if (noneChecked) {
      state = 'true';
      this.selectAllColumn.setAttribute('data-checked', 'false');
    }

    this.form.query('input[type=checkbox][name^="webhook.eventsEnabled"]').each(function(checkbox) {
      checkbox.setChecked(state === 'true');
    });
  },

  _handleBodyClick: function(event) {
    // This is the checkbox itself, it can handle its click damnit.
    if (event.target.matches('span, input')) {
      return;
    }

    const row = event.target.matches('tr') ? event.target : event.target.closest('tr');
    if (row !== null) {
      const checkbox = row.querySelector('td input[type=checkbox]');
      checkbox.checked = !checkbox.checked;
    }
  },

  _handleTabSelect: function(tab) {
    if (tab.queryFirst('a').getAttribute('href') === '#security') {
      this.certificateEditor.render();
    }
  }
};
