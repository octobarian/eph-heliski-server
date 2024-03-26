/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit application form. The row table is managed by the ExpandableTable object.
 *
 * @constructor
 */
FusionAuth.Admin.ApplicationForm = function() {
  Prime.Utils.bindAll(this);

  this.cleanSpeakUsernameModerationCheckbox = Prime.Document.queryById('application_cleanSpeakConfiguration_usernameModeration_enabled');
  this.cleanSpeakUsernameSettings = Prime.Document.queryById('clean-speak-settings');

  this.form = Prime.Document.queryById('application-form');

  var formAction = Prime.Document.queryById('application-form').getAttribute('action');
  this.addApplication = formAction === '/admin/application/add';

  new FusionAuth.Admin.OAuthConfiguration(this.form);
  new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey(this.addApplication ? null : 'applications.tabs')
      .initialize();

  // Setup the role table
  if (this.addApplication) {
    new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('role-table'));
  }

  if (this.cleanSpeakUsernameModerationCheckbox !== null) {
    this.cleanSpeakUsernameModerationCheckbox.addEventListener('click', this._handleCleanSpeakClick);
    this._handleCleanSpeakClick();
  }

  this.samlv2AuthorizedRedirectURLs = this.form.queryFirst('select[name="application.samlv2Configuration.authorizedRedirectURLs"]');
  new Prime.Widgets.MultipleSelect(this.samlv2AuthorizedRedirectURLs)
      .withPlaceholder('e.g. https://www.example.com/saml/sp/acs')
      .withRemoveIcon('')
      .withCustomAddLabel('Add URL ')
      .initialize();
};

FusionAuth.Admin.ApplicationForm.prototype = {
  /**
   * Handles the CleanSpeak enable checkbox click.
   *
   * @returns {boolean} Always true.
   * @private
   */
  _handleCleanSpeakClick: function() {
    if (this.cleanSpeakUsernameModerationCheckbox.isChecked()) {
      this.cleanSpeakUsernameSettings.show();
    } else {
      this.cleanSpeakUsernameSettings.hide();
    }

    return true;
  }
};
