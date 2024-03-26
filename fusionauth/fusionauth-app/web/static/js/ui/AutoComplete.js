/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

FusionAuth.UI.AutoComplete = function(element) {
  Prime.Utils.bindAll(this);
  this.element = element;

  this._setInitialOptions();
};

FusionAuth.UI.AutoComplete.constructor = FusionAuth.UI.AutoComplete;
FusionAuth.UI.AutoComplete.prototype = {
  destroy: function() {
    this.div.removeEventListener('click', this._handleItemClick);
    if (this.options.inputAvailableCallback !== null) {
      this.element.removeEventListener('keyup', this._handleKeyUp)
          .removeEventListener('keydown', this._handleKeyDown);
    }

    return this;
  },

  initialize: function() {
    this.element.insertHTMLAfter(Prime.Document.newElement('<div/>', {'class': this.options.className}).getOuterHTML());
    this.div = this.element.getNextSibling();
    this.div.addEventListener('click', this._handleItemClick);

    if (this.options.inputAvailableCallback !== null) {
      this.element.addEventListener('keyup', this._handleKeyUp).addEventListener('keydown', this._handleKeyDown);
    }

    return this;
  },

  withInputAvailableCallback: function(callback) {
    this.options.inputAvailableCallback = callback;
    return this;
  },

  withClearValueCallback: function(callback) {
    this.options.clearValueCallback = callback;
    return this;
  },

  withSelectValueCallback: function(callback) {
    this.options.selectvalueCallback = callback;
    return this;
  },

  /* ===================================================================================================================
  * Private Methods
  * ===================================================================================================================*/

  _debounceEnd: function() {
    this.debounce = null;
  },

  _handleCallbackCallback: function(html) {
    if (Prime.Utils.isDefined(html) && html !== '') {
      this.div.setHTML('')
          .setWidth(this.element.getWidth())
          .appendHTML(html)
          .addClass('open');
    } else {
      this.div.setHTML('')
          .setWidth(this.element.getWidth())
          .removeClass('open');
      this.element.focus();
    }
  },

  _handleClearInput: function(event) {
    Prime.Utils.stopEvent(event);
    if (this.options.clearValueCallback !== null) {
      this.options.clearValueCallback();
    }

    if (Prime.Utils.isDefined(this.clearInput)) {
      this.clearInput.removeFromDOM();
      this.clearInput = null;
    }
    this.element.focus();
  },

  _handleItemClick: function(event) {
    var target = new Prime.Document.Element(event.target);
    if (target.is('a')) {
      Prime.Utils.stopEvent(event);

      this.div.removeClass('open');
      if (this.options.selectvalueCallback !== null) {
        this.options.selectvalueCallback(target.getDataAttribute('value'), target.getDataAttribute('display'));
      }

      this.element.insertHTMLAfter('<span class="clear-input"><i class="fa-times-circle fa"></i></span>');
      this.clearInput = this.element.getNextSibling().addEventListener('click', this._handleClearInput);
    }
  },

  _handleKeyDown: function(event) {
    // Keep the form from submitting, but instead pick up the field value and search
    if (event.key === 'Enter') {
      event.preventDefault();

      if (Prime.Utils.isDefined(this.debounce)) {
        // bail no need to hammer on the Enter key
        return;
      }

      this.debounce = setTimeout(this._debounceEnd, this.options.debounceTimeout);
      if (this.element.getValue().length >= this.options.minimumLength) {
        this.options.inputAvailableCallback(this.element.getValue(), this._handleCallbackCallback);
      }

      if (this.handle !== null) {
        clearTimeout(this.handle);
        this.handle = null;
      }
    }
  },

  _handleKeyUp: function() {
    // Not all key events will modify the input field
    if (this.element.getValue() === this.currentValue) {
      return;
    }
    this.currentValue = this.element.getValue();

    if (this.handle !== null) {
      clearTimeout(this.handle);
      this.handle = null;
    }

    if (this.element.getValue().length <= this.options.minimumLength) {
      this.div.setHTML('')
          .setWidth(this.element.getWidth())
          .removeClass('open');
      return;
    }

    this.handle = setTimeout(
        function() {
          this.options.inputAvailableCallback(this.element.getValue(), this._handleCallbackCallback)
        }.bind(this),
        this.options.autoCompleteTimeout);
  },

  _setInitialOptions: function() {
    // Defaults
    this.options = {
      autoCompleteTimeout: 700,
      className: 'autocomplete',
      clearValueCallback: null,
      debounceTimeout: 500,
      inputAvailableCallback: null,
      minimumLength: 1,
      selectValueCallback: null
    };
  }
};