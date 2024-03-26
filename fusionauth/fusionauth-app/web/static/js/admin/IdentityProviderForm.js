/*
 * Copyright (c) 2020-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit Identity Provider form. The row table is managed by the ExpandableTable object.
 *
 * @constructor
 */
FusionAuth.Admin.IdentityProviderForm = function(type) {
  Prime.Utils.bindAll(this);

  this.form  = Prime.Document.queryById('identity-provider-form');
  this.type = type;

  this.apiProperties = null;
  this.buttonProperties = null;

  switch (this.type) {
    case 'OpenIDConnect':
      this._setupOpenIdConnect();
      break;
    case 'ExternalJWT':
      this._setupJWTType();
      break;
  }

  this.tenantConfigTable = Prime.Document.queryById('idp-tenant-config-table');
  if (this.tenantConfigTable !== null) {
    new FusionAuth.UI.ExpandableTable(this.tenantConfigTable);
    // focusin bubbles, focus does not.
    this.tenantConfigTable.addEventListener('focusin', this._handleTenantConfigFocus);
  }

  var tabs = Prime.Document.queryFirst('.tabs');
  if (tabs !== null) {
    new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
        .withErrorClassHandling('error')
        .withLocalStorageKey(this.addIdentityProvider ? null : 'settings.identity-provider.' + this.type.toLowerCase() + '.tabs')
        .withSelectCallback(this._handleTabSelect)
        .initialize();
  }

  var domains = this.form.queryFirst('textarea[name="domains"]');
  if (domains !== null) {
    this.domainEditor = new FusionAuth.UI.TextEditor(this.form.queryFirst('textarea[name="domains"]'))
        .withOptions({
          'mode': 'properties',
          'lineNumbers': true,
        });
  }

  // We may have thousands of applications, use a single event listener to improve page performance.
  this.form.addDelegatedEventListener('click', '.slide-open-toggle', this._handleOverrideClick);

  // For everything except the red headed step child
  if (type !== 'ExternalJWT') {
    this._expandOverrides();
  }

  if (type === 'SAMLv2') {
    this._setupDestinationAlternates();
  }
};

FusionAuth.Admin.IdentityProviderForm.constructor = FusionAuth.Admin.IdentityProviderForm;
FusionAuth.Admin.IdentityProviderForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _expandOverrides: function() {
    var localStorage = Prime.Storage.getSessionObject('identityProvider.overrides') || {};
    for (var key in localStorage) {
      if (localStorage.hasOwnProperty(key)) {
        var target = Prime.Document.queryById(key);
        if (target !== null) {
          var icon = Prime.Document.queryFirst('[data-expand-open="' + key + '"]').queryFirst('i.fa');
          if (localStorage[key] === 'open') {
            icon.addClass('open');
            target.addClass('open');
          }
        }
      }
    }
  },

  _handleTenantConfigFocus: function(event) {
    var target = new Prime.Document.Element(event.target);
    if (target.is('.tenant-search')) {
      if (!Prime.Utils.isDefined(target.domElement.searchWidget)) {
        var hiddenInput = target.queryUp('tr').queryFirst('.tenant-search-hidden');
        target.domElement.searchWidget = new FusionAuth.Admin.AJAXSearchWidget(target, hiddenInput)
            .withRenderer(FusionAuth.Admin.AJAXSearchForm.TenantSearchRenderer)
            .withResultProvider(this._tenantSearchResultsProvider)
            .withSelectCallback(this._handleTenantSearchCallback)
            .withEmptyMessage(this.tenantConfigTable.getDataAttribute('noResults'))
            .withSearchURI('/ajax/tenant/search.json')
            .withRequestFunction(function(value) {
              return {
                'queryString': value
              };
            })
            .initialize();
      }
    }
  },

  _handleTenantSearchCallback: function(widget) {
    var tenantName = widget.searchInput.getValue();
    var tenantId = widget.hiddenInput.getValue();

    widget.searchInput.domElement.searchWidget.destroy();
    widget.searchInput.domElement.searchWidget = null;

    var nameInput = widget.searchInput.queryUp('td');
    var idInput = widget.searchInput.queryUp('td').getNextSibling();
    var inputs = widget.searchInput.queryUp('tr').query('input');
    var maxCount = widget.searchInput.queryUp('tr').queryFirst('input[name$=maximumLinks]');
    // Set the default value on this new row
    maxCount.setValue(this.tenantConfigTable.getDataAttribute('defaultMaxCount'));

    // There is another listener that I can't seem to get rid of, even though I am destroying the widget.
    // - If I don't delay this just a moment, I get an error in the AutoComplete._handleItemClick handler.
    setTimeout(function() {
      nameInput.setHTML(tenantName);
      idInput.setHTML(tenantId);

      inputs.each(function(e) {
        if (e.getAttribute('id')) {
          e.setAttribute('id', e.getAttribute('id').replace('tenantConfiguration[]', 'tenantConfiguration[' + tenantId + ']'));
        }

        if (e.getAttribute('name')) {
          e.setAttribute('name', e.getAttribute('name').replace('tenantConfiguration[]', 'tenantConfiguration[' + tenantId + ']'));
        }
      });
    }.bind(this), 2);
  },

  _tenantSearchResultsProvider: function(json) {
    var tenants = json['tenants'];
    // Remove any configured tenants from the search results
    this.tenantConfigTable.query('tbody tr[data-tenant-id]').each(function(e) {
      var tenantId = e.getDataAttribute('tenantId');
      for (var i=0; i < tenants.length; i++) {
        if (tenants[i]['id'] === tenantId) {
          tenants.splice(i, 1);
          break;
        }
      }
    });

    return tenants;
  },

  _setupOpenIdConnect: function() {
    this.openIdIssuer = Prime.Document.queryFirst('input[name="identityProvider.oauth2.issuer"]');
    this.useOpenIdDiscovery = Prime.Document.queryById('useOpenIdDiscovery').addEventListener('change', this._handleUserOpenIdDiscoveryChange);

    this.openIdIssuerSlideOpen = this.openIdIssuer.queryUp('.slide-open');
    this.openIdIssuerSlideOpen._open = this.useOpenIdDiscovery.isChecked();

    this.clientAuthenticationMethodSelector = Prime.Document.queryById('identityProvider_oauth2_clientAuthenticationMethod');
    if (this.clientAuthenticationMethodSelector != null) {
      this.openIdClientSecret = new Prime.Effects.SlideOpen(Prime.Document.queryById('openid-client-secret'));
      this.clientAuthenticationMethodSelector.addEventListener('change', this._handleClientAuthenticationMethodChange);
    }
  },

  _handleOverrideClick: function(event, target) {
    Prime.Utils.stopEvent(event);

    var toggle = new Prime.Document.Element(target);
    var div = Prime.Document.queryById(toggle.getDataAttribute("expandOpen"));

    var localStorage = Prime.Storage.getSessionObject('identityProvider.overrides') || {};
    var storageKey = div.getId();

    var icon = toggle.queryFirst('i.fa');
    if (div.hasClass('open')) {
      icon.removeClass('open');
      localStorage[storageKey] = 'closed';
      new Prime.Effects.SlideOpen(div).toggle();
    } else {
      icon.addClass('open');
      localStorage[storageKey] = 'open';
      new Prime.Effects.SlideOpen(div).toggle();
    }

    Prime.Storage.setSessionObject('identityProvider.overrides', localStorage);
  },

  _handleClientAuthenticationMethodChange: function() {
    if (this.clientAuthenticationMethodSelector.getValue() !== 'none') {
      this.openIdClientSecret.open();
    } else {
      this.openIdClientSecret.close();
    }
  },

  _handleUserOpenIdDiscoveryChange: function() {
    if (this.openIdIssuerSlideOpen._open) {
      this.openIdIssuer.setDisabled(true);
      this.openIdIssuerSlideOpen._open = false;
    } else {
      this.openIdIssuer.setDisabled(false);
      this.openIdIssuerSlideOpen._open = true;
    }
  },

  _setupJWTType: function() {
    this.form = Prime.Document.queryById('identity-provider-form');
    this.addIdentityProvider = this.form.getAttribute('action') === '/admin/identity-provider/add';

    // Add Claims
    this.claimTable = Prime.Document.queryById('claims-map-table');
    this.expandableClaimTable = new FusionAuth.UI.ExpandableTable(this.claimTable);

    this.claimDataSet = null;
    Prime.Document.queryById('add-claim').addEventListener('click', this._handleAddClaimClick);
  },

  _getDataFromClaimForm: function() {
    var form = this.claimDialog.element.queryFirst('form');
    var data = {};
    data.incomingClaim = form.queryFirst('input[name="incomingClaim"]').getValue();
    data.fusionAuthClaim = form.queryFirst('select[name="fusionAuthClaim"]').getValue();
    return data;
  },

  _handleAddClaimClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.claimDataSet = null;
    var anchor = new Prime.Document.Element(event.currentTarget);
    this.claimDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleAddClaimDialogOpenSuccess)
        .withFormHandling(true)
        .withFormErrorCallback(this._handleAddClaimDialogOpenSuccess)
        .withFormSuccessCallback(this._handleAddClaimFormSuccess)
        .open(anchor.getAttribute('href') + '?identityProviderId=' + anchor.getAttribute('identityProviderId'));
  },

  _handleAddClaimFormSuccess: function() {
    var data = this._getDataFromClaimForm();

    var row = null;
    this.claimTable.query('tbody tr').each(function(r) {
      if (r.getDataSet().incomingClaim === data.incomingClaim) {
        row = r;
      }
    });

    if (row === null) {
      row = this.expandableClaimTable.addRow(data);
    }

    var dataSet = row.getDataSet();
    dataSet.incomingClaim = data.incomingClaim;
    dataSet.fusionAuthClaim = data.fusionAuthClaim;

    this._replaceClaimFieldValues(data);

    // Finally close the dialog
    this.claimDialog.close();
  },

  _handleAddClaimDialogOpenSuccess: function(dialog) {
    if (this.claimDataSet !== null) {
      dialog.element.queryFirst('input[name="incomingClaim"]').setValue(this.claimDataSet.incomingClaim);
      dialog.element.queryFirst('select[name="fusionAuthClaim"]').setValue(this.claimDataSet.fusionAuthClaim);
    }

    dialog.element.queryFirst('input[name="incomingClaim"]').focus();
  },

  /**
   * Handles the tab selection and enables CodeMirror on the Data Definition tab.
   *
   * @param {Object} tab The &lt;li&gt; tab element that was selected.
   * @param {Object} tabContent The &lt;div&gt; that contains the tab contents.
   * @private
   */
  _handleTabSelect: function(tab, tabContent) {
    if (tabContent.getId() === 'domains') {
      this.domainEditor
          .render()
          .setHeight(125);
    }

    if (tabContent.getId() === 'options') {
      if (this.apiProperties === null) {
        const apiProperties = document.querySelector('textarea[name="identityProvider.properties.api"]');
        this.apiProperties = new FusionAuth.UI.TextEditor(apiProperties)
            .withOptions({
              'mode': 'properties',
              'lineNumbers': true
            })
            .render()
            .setHeight(150);
      }

      if (this.buttonProperties === null) {
        const buttonProperties = document.querySelector('textarea[name="identityProvider.properties.button"]');
        this.buttonProperties = new FusionAuth.UI.TextEditor(buttonProperties)
            .withOptions({
              'mode': 'properties',
              'lineNumbers': true
            })
            .render()
            .setHeight(150);
      }
    }
  },

  /**
   * Need to move the updated data-XXX attributes into the row, otherwise the edits won't get passed to the action.
   */
  _replaceClaimFieldValues: function(data) {
    var input = Prime.Document.queryById('identityProviders.claimMap_' + data.incomingClaim);
    input.setValue(data.fusionAuthClaim);

    input.queryUp('td').getNextSibling().setHTML(data.fusionAuthClaim);
  },

  /**
   * Destination alternate list for SAMLv2 assertion configuration
   */
  _setupDestinationAlternates: function() {
    const alternates = Prime.Document.queryById('alternateDestinations');
    if (!!alternates) {
      new Prime.Widgets.MultipleSelect(alternates)
        .withPlaceholder('e.g. https://previous-idp.com/samlv2/acs')
        .withRemoveIcon('')
        .withCustomAddLabel(alternates.getDataAttribute('alternateDestinationAddLabel'))
        .initialize();
    }
  }
};
