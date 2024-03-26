/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles User Search page.
 *
 * @constructor
 */
FusionAuth.Admin.UserSearch = function(queryString) {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('user-search-form');
  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.userSearch.advancedControls').initialize();

  // Global Bulk Actions
  Prime.Document.query('.bulk-actions a[data-ajax-form="true"]').addEventListener('click', this._handleAddRemoverMembersClick);

  if (queryString !== null) {
    history.replaceState({}, '', FusionAuth.requestContextPath + '/admin/user/');
  }

  new AdvancedUserSearch(this.form, queryString);
};

FusionAuth.Admin.UserSearch.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAddRemoverMembersClick: function(event) {
    Prime.Utils.stopEvent(event);
    var button = new Prime.Document.Element(event.currentTarget);
    var uri = button.getAttribute('href');

    // This is called from the Manage Users - Group Member tab, and the multi-select on the Users search page
    // - When called from the Users search page there is not a form on the page that uses the POST method so no CSRF token
    //   is provided in the form submit.
    var csrfField = Prime.Document.queryFirst('form input[type="hidden"][name="primeCSRFToken"]');
    if (csrfField !== null) {
      var csrfToken = encodeURIComponent(csrfField.getValue());
      uri += '?primeCSRFToken=' + csrfToken;
    }

    var data = {'userIds': []};
    var table = Prime.Document.queryFirst('[data-user-table]');
    table.query('tbody input[type="checkbox"]:checked').each(function(e) {
      data.userIds.push(e.getValue());
    });

    new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
        .withAjaxRequest(new Prime.Ajax.Request(uri, 'POST').withJSON(data))
        .open(uri);
  }
};
