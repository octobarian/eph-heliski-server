/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @param {Prime.Document.Element|PrimeElement} form the form
 * @param {number} userCodeLength the length of the code
 * @constructor
 */
FusionAuth.OAuth2.Device = function(form, userCodeLength) {
  Prime.Utils.bindAll(this);

  this.form = form;
  this.userCodeLength = userCodeLength;
  this.form.addEventListener('submit', this._handleFormSubmit);

  this.container = Prime.Document.queryById("user_code_container")
      .addEventListener('keydown', this._handleOnKeyDown)
      .addEventListener('keyup', this._handleOnKeyUp);

  this.inputs = this.container.query("input[type=text]");
  this.inputs.addEventListener('focus', this._handleFocus);

  // Pre-populate the user_code when provided on initial page render
  var uc = document.getElementsByName("user_code")[0].value;
  if (uc != null && uc !== "") {
    for (var i = 0; i < uc.length; i++) {
      document.getElementById("user_code_" + i).value = uc.charAt(i);
    }
  }
};

FusionAuth.OAuth2.Device.constructor = FusionAuth.OAuth2.Device;
FusionAuth.OAuth2.Device.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleFocus: function(e) {
    e.target.select();
  },

  _handleOnKeyDown: function(e) {
    var target = e.target;
    var id = target.attributes["id"].value;
    var index = parseInt(id.substring(id.length - 1));

    // Handle backspace on keyDown so we can see if the input value is empty
    if (e.keyCode === 8) {
      // If current value is already empty, move to previous
      if (target.value.length === 0) {
        if (index > 0) {
          this._setFocus(index - 1);
        }
      }
    } else if (e.keyCode === 37 || e.keyCode === 39) {
      // Left arrow & Right arrow move focus left and right
      e.preventDefault();
      var nextIndex = index + (e.keyCode === 37 ? -1 : 1);
      this._setFocus(nextIndex);
    }
  },

  _handleOnKeyUp: function(e) {
    // Ignore backspace, tab, shift, alt, Ignore shift, tab, backspace, left and right
    if (e.keyCode === 8 || e.keyCode === 9 || e.keyCode === 16 || e.keyCode === 18 || e.keyCode === 37 || e.keyCode === 39) {
      return;
    }

    var target = e.target;
    var id = target.attributes["id"].value;
    var index = parseInt(id.substring(id.length - 1));

    if (target.value.length !== 0) {
      // Move to the next field if we aren't at the end and the next value is still empty
      var next = this.inputs[index + 1];
      if (next) {
        this._setFocus(index + 1);
      }
    }
  },

  _handleFormSubmit: function() {
    var newCode = "";
    for (var i = 0; i < this.userCodeLength; i++) {
      newCode += document.getElementById("user_code_" + i).value;
    }
    document.getElementById("interactive_user_code").value = newCode;
  },

  _setFocus: function(index) {
    if (index >= 0 && index <= (this.inputs.length - 1)) {
      var input = this.inputs[index];
      input.domElement.focus();
      input.domElement.setSelectionRange(0, 1);
    }
  }
};
