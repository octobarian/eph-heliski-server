/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.WebhookTest = function() {
  Prime.Utils.bindAll(this);

  this.localStorageKeyPrefix = "webhook-test.";
  this.editors = {};
  Prime.Document.query("textarea").each((function(e) {
    this.editors[e.getId()] = new FusionAuth.UI.TextEditor(e)
         .withOptions({
            'gutters': ['CodeMirror-lint-markers'],
            'lint': true,
            'lineWrapping': true,
            'mode': {
              name: 'javascript',
              json: true
             },
            'tabSize': 2
          });
  }).bind(this));

  this.select = Prime.Document.queryById("event-type-select").addEventListener("change", this._handleEventTypeSelect);
  Prime.Document.queryById("webhook-test-reset").addEventListener("click", this._handleResetButtonClick);
  Prime.Document.queryById("webhook-test-form").addEventListener("submit", this._handleFormSubmit);

  this._handleEventTypeSelect();
};

FusionAuth.Admin.WebhookTest.constructor = FusionAuth.Admin.WebhookTest;
FusionAuth.Admin.WebhookTest.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleEventTypeSelect: function() {
    var eventName = this.select.getSelectedValues()[0];

    Prime.Document.query("#form-container > div").hide();
    Prime.Document.query("#form-container > div input,textarea").setDisabled(true);

    Prime.Document.queryById(eventName).show().query('input,textarea').setDisabled(false);

    // Take the viewport height and subtract a bit, but don't go smaller than 350. We should really get the style to just
    // auto size for the height of hte panel.
    const editorHeight = Math.max(window.innerHeight - 450, 350);

    var editor = this.editors[eventName + 'Example'];
    editor.render().setHeight(editorHeight);

    // Look to see if we have an event defined in local storage
    var savedEvent = sessionStorage.getItem(this.localStorageKeyPrefix + eventName);
    if (savedEvent !== null) {
      editor.setValue(savedEvent);
    }
  },

  _handleFormSubmit: function() {
    var eventName = this.select.getSelectedValues()[0];
    var editor = this.editors[eventName + 'Example'];
    var textEditorValue =  editor.getValue();
    var textareaValue = Prime.Document.queryById(eventName + 'Example').getValue();

    // if the value's been edited, save it to session storage
    if (textEditorValue !== textareaValue) {
      if (sessionStorage.getItem(this.localStorageKeyPrefix + 'original.' + eventName) === null) {
        sessionStorage.setItem(this.localStorageKeyPrefix +  'original.' + eventName, textareaValue);
      }

      sessionStorage.setItem(this.localStorageKeyPrefix + eventName, textEditorValue);
    }
  },

  _handleResetButtonClick: function(event) {
    event.preventDefault();
    event.stopPropagation();

    var eventName = this.select.getSelectedValues()[0];
    var editor = this.editors[eventName + 'Example'];
    var inProgress = new Prime.Widgets.InProgress(editor.element.queryUp('.form-row').queryFirst('div'))
                                      .withMinimumTime(500)
                                      .open();

    sessionStorage.removeItem(this.localStorageKeyPrefix + eventName);
    var original = sessionStorage.getItem(this.localStorageKeyPrefix + 'original.' + eventName);
    if (original !== null) {
      editor.setValue(original);
      editor.sync();
    }

    inProgress.close();
  }
};
