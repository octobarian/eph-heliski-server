/*
 * Copyright (c) 2018-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * JavaScript for the manage user page.
 *
 * @constructor
 * @param userId {string} the user id.
 */
FusionAuth.Admin.ManageUser = function(userId) {
  Prime.Utils.bindAll(this);

  // Last Login table
  this.userId = userId;
  new FusionAuth.Admin.LastLogins(this.userId);
  this.formErrors = null;

  // Attach a delegated listener to all the ajax forms anchors
  Prime.Document.addDelegatedEventListener('click', '[data-ajax-form="true"], [data-ajax-view="true"]', this._handleActionClick);
  if (typeof(PublicKeyCredential) === 'undefined') {
    // WebAuthn is not supported in this browser. Disable the Add button.
    Prime.Document.queryById('add-webauthn')
      ?.setAttribute('disabled', 'disabled')
      .addClass('disabled');
  }

  // Set up the entity search
  var resultDiv = Prime.Document.queryById('entity-search-results');
  var container = Prime.Document.queryById('entities');
  var form = Prime.Document.queryById('entity-search-form');
  this.ajaxSearch = new FusionAuth.Admin.AJAXSearchForm()
      .withContainer(container)
      .withDatabaseSort()
      .withDefaultSearchCriteria({
        's.userId': userId,
        's.orderBy': 'name asc'
      })
      .withForm(form)
      .withResultDiv(resultDiv)
      .withStorageKey('io.fusionauth.user[' + userId + '].entities')
      .initialize();

  this.entityAJAXSearchInitialized = false;

  // Initialize last since the handleTabSelect may need to use the search form
  this.tabs = new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey('user.manage.tabs')
      .withSelectCallback(this._handleTabSelect)
      .initialize();
};

FusionAuth.Admin.ManageUser.constructor = FusionAuth.Admin.ManageUser;
FusionAuth.Admin.ManageUser.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleActionUserDialogOpen: function() {
    new FusionAuth.Admin.UserActioningForm(Prime.Document.queryById('user-actioning-form'));
  },

  _handleAddConsentDialogOpen: function() {
    new FusionAuth.Admin.AddUserConsentForm(Prime.Document.queryById('add-user-consent-form'));
  },

  _handleTabSelect: function(tab, tabContent) {
    // Search the first time we render this tab
    if (tabContent.getId() === 'entities' && !this.entityAJAXSearchInitialized) {
      this.ajaxSearch.search();
      this.entityAJAXSearchInitialized = true;
    }
  },

  _handleTwoFactorDialogOpen: function() {
    // When we do an admin disable, or a recovery code panel, we won't have this form Id.
    var form = Prime.Document.queryById('two-factor-form');
    if (form !== null) {
      this.twoFactorObject = new FusionAuth.Admin.TwoFactor(form);
    }
  },

  _handleWebAuthnAddDialogOpen: function() {
    const form = document.getElementById('webauthn-register-form');
    form.querySelector('input[type="text"]').focus();
    form.addEventListener('submit', this._handleWebAuthnRegisterFormSubmit);
  },

  _handleWebAuthnRegisterFormSubmit: function(event) {
    event.stopPropagation();
    event.preventDefault()

    const form = document.getElementById('webauthn-register-form');
    const formData = new FormData();
    formData.set('displayName', form.querySelector('input[type="text"][name="displayName"]').value);
    formData.set('primeCSRFToken', form.querySelector('input[type="hidden"][name="primeCSRFToken"]').value);
    formData.set('userAgent', window.navigator.userAgent);
    formData.set('userId', form.querySelector('input[type="hidden"][name="userId"]').value);

    var options = {
      method: 'POST',
      body: formData
    };

    fetch('/ajax/user/webauthn/start-registration', options)
      .then(async response => {
       if (response.ok) {
          return response.json();
        } else {
         if (this.formErrors !== null) {
           this.formErrors.destroy();
         }

         this.formErrors = new FusionAuth.UI.Errors()
           .withErrors(await response.json())
           .withForm( Prime.Document.Element.wrap(form))
           .initialize();

          const body = JSON.stringify(await response.json(), null, 2);
          throw new Error(`\nStatus: ${response.status}\n${body}`);
        }
      })
      .then(response => WebAuthnHelper.registerCredential(response.options))
      .then(cred => {
        // Set the credential into the form and then submit.
        form.querySelector('input[name="webAuthnRegisterRequest"]').value = btoa(JSON.stringify(cred));
        return fetch(form.getAttribute('action'), {
          method: form.getAttribute('method'),
          body: new FormData(form)
        });
      })
      .then(_response => window.location.reload())
      .catch(error => {
        console.debug(error);
      });
  },

  _handleActionClick: function(event, target) {
    Prime.Utils.stopEvent(event);
    var button = new Prime.Document.Element(target);
    var uri = button.getAttribute('href');

    if (uri.indexOf('/ajax/user/consent/add') !== -1) {
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(true)
          .withCallback(this._handleAddConsentDialogOpen)
          .withFormErrorCallback(this._handleAddConsentDialogOpen)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    } else if (uri.indexOf('/ajax/user/two-factor') !== -1) {
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(true)
          .withCallback(this._handleTwoFactorDialogOpen)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    } else if (uri.indexOf('/ajax/user/webauthn/add') !== -1) {
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(false)
          .withCallback(this._handleWebAuthnAddDialogOpen)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    } else if (uri.indexOf('/ajax/user/action') === -1 && uri.indexOf('/ajax/user/modify-action') === -1) {
      // General handling - not for User Action
      var formHandling = uri.indexOf("/view") === -1; // if this isn't a view ajax, it has a form
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(formHandling)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    } else {
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(true)
          .withCallback(this._handleActionUserDialogOpen)
          .withFormErrorCallback(this._handleActionUserDialogOpen)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    }
  }
};