/*
 * Copyright (c) 2019-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

FusionAuth.IdentityProvider.Helper = {
  /**
   * URL Safe Base64 Encoding. Replace the + (plus) and a / (slash) with - (dash) and _ (under bar)
   *
   *  Code   Base64   URL Safe
   *  ------------------------
   *  62     +        -
   *  63     /        _
   *
   * Also remove trailing padding characters (=)
   *
   * @param s
   * @returns {string}
   */
  base64URLEncode: function(s) {
    return btoa(s).replace(/\+/g, '-')
                  .replace(/\//g, '_')
                  .replace(/=+$/, '');
  },

  captureState: function(additionalFields) {
    // Not all fields will be present in older themes, so check for null.
    function safeEncode(selector) {
      var element = document.querySelector(selector);
      if (element === null) {
        return '';
      }

      return encodeURIComponent(element.value);
    }

    var federatedCSRFToken = document.getElementById('login-button-container').dataset['federatedCsrf'];

    var state =
        'client_id=' + safeEncode('input[name=client_id]')
        + '&code_challenge=' + safeEncode('input[name="code_challenge"]')
        + '&code_challenge_method=' + safeEncode('input[name="code_challenge_method"]')
        + '&metaData.device.name=' + safeEncode('input[name="metaData.device.name"]')
        + '&metaData.device.type=' + safeEncode('input[name="metaData.device.type"]')
        + '&nonce=' + safeEncode('input[name="nonce"]')
        + '&redirect_uri=' + safeEncode('input[name=redirect_uri]')
        + '&response_mode=' + safeEncode('input[name="response_mode"]')
        + '&response_type=' + safeEncode('input[name=response_type]')
        + '&scope=' + safeEncode('input[name=scope]')
        + '&state=' + safeEncode('input[name=state]')
        + '&tenantId=' + safeEncode('input[name=tenantId]')
        + '&timezone=' + safeEncode('input[name=timezone]')
        + '&user_code=' + safeEncode('input[name="user_code"]')
        + '&csrf=' + (federatedCSRFToken === undefined ? '' : encodeURIComponent(federatedCSRFToken));

    // This map will be parameter name and value (already extracted from the DOM)
    // - Assuming the parameter name does not need escaping.
    if (additionalFields) {
      Object.keys(additionalFields).forEach(function(key) {
        var value = additionalFields[key];
        if (value !== null && typeof(value) !== 'undefined') {
          state += '&' + key + '=' + encodeURIComponent(value);
        }
      });
    }

    // It should not be necessary to encode this Base64 encoded string, but it should not hurt.
    return encodeURIComponent(FusionAuth.IdentityProvider.Helper.base64URLEncode(state));
  },

  findIdentityProviderScriptByFileName: function(fileName) {
    // The src attribute will include the base URL, for example https://login.piedpiper.com/js/identityProvider/...
    // - Build the web app fully qualified value and ensure we end with this value to be defensive against making a false
    //   match because we can't control what script tags are added by a theme. We could optionally just look at the
    //   script.outerHTML but using parsed src attribute seems safer.
    var fullyQualifiedFileName = "/js/identityProvider/" + fileName + "?version=" + (FusionAuth.Version || '1.11.0');
    var scripts = document.getElementsByTagName('script');
    // Iterate through the scripts until we find ourselves. Very existential.
    // - More likely the script we want is near the end so look in reverse insertion order.
    for (let i = scripts.length - 1; i >= 0; i--) {
      if (typeof scripts[i].src !== 'undefined' && scripts[i].src.endsWith(fullyQualifiedFileName)) {
        return scripts[i];
      }
    }

    // Unexpected, dev time error.
    console.log('Integration error. Failed to find script element with src [' + fullyQualifiedFileName + '].');
    return null;
  }
};