/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit consent form.
 *
 * @constructor
 */
FusionAuth.Admin.ConsentForm = function() {
  Prime.Utils.bindAll(this);

  new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey('settings.consent.tabs')
      .initialize();

  // Setup the values table
  new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('values-table'));
  new FusionAuth.Admin.LocalizationTable(Prime.Document.queryById('consent-age-table'))
      .withFormPreSubmitCallback(this._handleSubmit);
};

FusionAuth.Admin.ConsentForm.prototype = {
  _handleSubmit: function() {
    // Remove empty values
    var table = Prime.Document.queryById('consent-age-table');
    table.query('tbody tr').each(function(element) {
      var input = element.queryFirst('td input');
      if (input !== null && input.getValue() === '') {
        element.removeFromDOM();
      }
    });
  }
};
