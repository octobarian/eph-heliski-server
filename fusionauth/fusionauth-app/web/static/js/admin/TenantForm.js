/*
 * Copyright (c) 2020-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * @constructor
 */
FusionAuth.Admin.TenantForm = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('tenant-form');
  this.addTenant = this.form.getAttribute('action') === '/admin/tenant/add';
  this.smtpEditor = null;
  this.reorderConnector = null;
  this.addPolicyManager = new FusionAuth.Admin.TenantPolicyManager();
  this.additionalEmailHeaders = this.form.queryFirst('textarea[name=additionalEmailHeaders]');
  new FusionAuth.Admin.SMTPTestDialog(this);

  // Email headers
  this.additionalEmailHeadersEditor = new FusionAuth.UI.TextEditor(this.additionalEmailHeaders)
      .withOptions({
        'mode': 'properties',
        'lineNumbers': true
      });

  // Blocked domains
  this.blockedDomains = this.form.queryFirst('textarea[name=blockedDomains]');
  this.blockedDomainsEditor = null;
  if (this.blockedDomains !== null) {
    this.blockedDomainsEditor = new FusionAuth.UI.TextEditor(this.blockedDomains)
        .withOptions({
          'mode': 'properties',
          'lineNumbers': true,
        });
  }

  var scimSchemasTextarea = this.form.queryFirst('textarea[name="scimSchemas"]');
  this.scimSchemasEditor = new FusionAuth.UI.TextEditor(scimSchemasTextarea)
      .withOptions({
        'gutters': ['CodeMirror-lint-markers'],
        'lint': true,
        'lineWrapping': true,
        'mode': 'text/javascript',
        'tabSize': 2
      });

  new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withSelectCallback(this._handleTabSelect)
      .withLocalStorageKey(this.addTenant ? null : 'settings.tenant.tabs')
      .initialize();

  this.childRegistrationCheckbox = this.form.queryFirst('input[name="tenant.familyConfiguration.allowChildRegistrations"]')
                                       .addEventListener('change', this._handleChildRegistrationChange);
  this.noChildRegistrationDiv = new Prime.Effects.SlideOpen(Prime.Document.queryById('no-child-registration'));
  this.childRegistrationDiv = new Prime.Effects.SlideOpen(Prime.Document.queryById('child-registration'));

  this.failedAuthenticationUserAction = Prime.Document.queryById('tenant_failedAuthenticationConfiguration_userActionId')
                                             .addEventListener('change', this._handleFailedAuthenticationUserActionChange);
  this.failedAuthenticationSettings = new Prime.Effects.SlideOpen(Prime.Document.queryById('failed-authentication-options'));

  // Webhook select all column
  this.webhookSelectAllColumn = this.form.queryFirst('[data-toggle-column]').addEventListener('click', this._handleWebhookColumnClick);

};

FusionAuth.Admin.TenantForm.constructor = FusionAuth.Admin.TenantForm;
FusionAuth.Admin.TenantForm.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleChildRegistrationChange: function() {
    if (this.childRegistrationCheckbox.isChecked()) {
      this.noChildRegistrationDiv.close();
      this.childRegistrationDiv.open();
    } else {
      this.noChildRegistrationDiv.open();
      this.childRegistrationDiv.close();
    }
  },

  _handleFailedAuthenticationUserActionChange: function() {
    if (this.failedAuthenticationUserAction.getValue() === '') {
      this.failedAuthenticationSettings.close();
    } else {
      this.failedAuthenticationSettings.open();
    }
  },

  _handleTabSelect: function(tab, tabContent) {
    if (tabContent.getId() === 'advanced-configuration') {
      var smtpProperties = Prime.Document.queryFirst('textarea[name="tenant.emailConfiguration.properties"]');
      if (this.smtpEditor === null) {
        this.smtpEditor = new FusionAuth.UI.TextEditor(smtpProperties)
            .withOptions({
              'mode': 'properties',
              'lineNumbers': true
            })
            .render()
            .setHeight(100);
      }
    }

    if (tabContent.getId() === 'connector-configuration') {
      this.addPolicyManager.onTabSelect();
    }

    if (tabContent.getId() === 'email-configuration') {
      if (this.additionalEmailHeadersEditor !== null) {
        this.additionalEmailHeadersEditor
            .render()
            .setHeight(75);
      }
    }

    if (tabContent.getId() === 'security') {
      if (this.blockedDomainsEditor !== null) {
        this.blockedDomainsEditor
            .render()
            .setHeight(100);
      }
    }

    if (tabContent.getId() === 'scim-configuration') {
      // Set up the editor
      if (this.scimSchemasEditor !== null) {
        this.scimSchemasEditor
            .render();

        // Set auto height with a max of 1000px;
        this.scimSchemasEditor.editorElement.setStyles({
          'height': 'auto',
          'min-height': '75px',
          'max-height': '1000px'
        });

        this.scimSchemasEditor.editorElement.queryFirst('.CodeMirror-scroll').setStyles({
          'height': 'auto',
          'min-height': '75px',
          'max-height': '1000px'
        });

        this.scimSchemasEditor.refresh();
      }
    }
  },

  _handleWebhookColumnClick: function(event) {
    Prime.Utils.stopEvent(event);

    // Handle select all columns
    var state = this.webhookSelectAllColumn.getAttribute('data-checked') || 'true';
    this.webhookSelectAllColumn.setAttribute('data-checked', state === 'true' ? 'false' : 'true');

    this.form.query('input[type=checkbox][name^="tenant.eventConfiguration.events"]').each(function(checkbox) {
      checkbox.setChecked(state === "true");
    });
  },
};
