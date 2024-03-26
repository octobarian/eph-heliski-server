/*
 * Copyright (c) 2019-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @constructor
 */
FusionAuth.OAuth2.LocaleSelect = function(element) {
  Prime.Utils.bindAll(this);

  this.element = element;
  element.addEventListener('change', this._handleChange)

  // Write the cookie on load as well so that we can localize this better even when the user has not changed the
  // value since page load. For example, if you add &locale=fr to the URL for the initial page load we should write
  // the cookie for this value.
  document.cookie = 'fusionauth.locale=' + this.element.getSelectedValues()[0] + '; path=/';
};

FusionAuth.OAuth2.LocaleSelect.constructor = FusionAuth.OAuth2.LocaleSelect;
FusionAuth.OAuth2.LocaleSelect.prototype = {
  _handleChange: function() {
    document.cookie = 'fusionauth.locale=' + this.element.getSelectedValues()[0] + '; path=/';

    var urlParams = new URLSearchParams(window.location.search);

    // Strip off the parameter if there is one so that it doesn't override the cookie
    if (urlParams.has('locale')) {
      urlParams.delete('locale');
    }

    // Parameters may already be set in the form.
    var url = document.location.href;
    if (url.indexOf("client_id") === -1) {
      var clientId = Prime.Document.queryFirst('form input[name="client_id"]');
      if (clientId !== null) {

        var form = clientId.queryUp('form');
        form.query('input[type="hidden"]').each(function(element) {

          var name = element.getAttribute('name');
          if (!urlParams.has(name)){
            var value = element.getValue();
            if (value !== '') {
              urlParams.append(name, value);
            }
          }
        });
      }
    }

    window.location.search = urlParams.toString();
  }
};
