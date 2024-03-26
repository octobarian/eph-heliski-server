/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the messenger form by setting up an ExpandableTable for the headers used with Generic messengers.
 *
 * @constructor
 */
FusionAuth.Admin.MessengerForm = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('messenger-form');
  this.type = this.form.queryFirst('[type="hidden"][name="type"]').getValue();
  this.errors = null;
  this.currentTestElement = null; // Initialize to null so we can check for null later.

  // Generic
  if (this.type === "Generic") {
    // Setup the header table
    new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('header-table'));

    // Setup the editor
    this.certificateEditor = new FusionAuth.UI.TextEditor(this.form.queryFirst('textarea[name="messenger.sslCertificate"]')).withOptions({'mode': 'text/plain', 'lineWrapping': true});

    // Setup the tabs
    new Prime.Widgets.Tabs(this.form.queryFirst('.tabs')).withSelectCallback(this._handleTabSelect).initialize();

    this.genericSettings = Prime.Document.queryById('generic-settings');
    this.errorResponse = Prime.Document.queryById('generic-error-response');
    this.errorEditor = null;
    this.errorMessage = Prime.Document.queryById('generic-error');
    this.okMessage = Prime.Document.queryById('generic-ok');

    this.testConfiguration = Prime.Document.queryById('send-test-generic').addEventListener('click', this._handleGenericTestClick);
    this.testGeneric = this.testConfiguration.getPreviousSibling();
  }

  // Twilio
  if (this.type === "Twilio") {
    this.twilioSettings = Prime.Document.queryById('twilio-settings');
    this.errorResponse = Prime.Document.queryById('twilio-error-response');
    this.errorEditor = null;
    this.errorMessage = Prime.Document.queryById('twilio-error');
    this.okMessage = Prime.Document.queryById('twilio-ok');

    this.testConfiguration = Prime.Document.queryById('send-test-message').addEventListener('click', this._handleTwilioTestClick);
    this.testPhoneNumber = Prime.Document.queryById('test-phone-number');
  }

  // Kafka
  if (this.type === "Kafka") {
    this.producer = Prime.Document.queryById('producerConfiguration');
    this.errorResponse = Prime.Document.queryById('kafka-error-response');
    this.errorEditor = null;
    this.errorMessage = Prime.Document.queryById('kafka-error');
    this.okMessage = Prime.Document.queryById('kafka-ok');

    this.producerEditor = new FusionAuth.UI.TextEditor(this.producer)
        .withOptions({
          'mode': 'properties',
          'lineNumbers': true,
          'gutters': ['CodeMirror-lint-markers']
        })
        .render()
        .setHeight(150);

    this.testConfiguration = Prime.Document.queryById('send-test-message').addEventListener('click', this._handleKafkaTestClick);
  }
};

FusionAuth.Admin.MessengerForm.constructor = FusionAuth.Admin.MessengerForm;
FusionAuth.Admin.MessengerForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleTabSelect: function(tab) {
    if (tab.queryFirst('a').getAttribute('href') === '#security') {
      this.certificateEditor
          .render();
    }
  },

  _handleTwilioTestClick: function(event) {
    this._handleTestClick(event, '/ajax/messenger/twilio/test', 'testNumber', this.testPhoneNumber);
  },

  _handleTestFailure: function(xhr) {
    // Handle 400 first, so we can remove the name attribute ASAP from the currentTestElement.
     if (xhr.status === 400) {
      this.errors = new FusionAuth.UI.Errors()
          .withErrors(JSON.parse(xhr.responseText))
          .withForm(this.form)
          .initialize();
    }

    if (this.currentTestElement !== null) {
      this.currentTestElement.removeAttribute('name');
    }

    if (xhr.status === 401) {
      location.reload();
    }

    this.okMessage.hide();
    this.errorMessage.show();

    this._buildErrorEditor();
    this.errorEditor.setValue("An unexpected error occurred, review the system logs for additional details.");
  },

  _buildErrorEditor: function() {
    if (this.errorEditor === null) {
      var options =  this.type === "Twilio"
          ? {
            'mode': 'xml',
            'readOnly': true,
            'lint': true,
            'lineNumbers': true,
            'gutters': ['CodeMirror-lint-markers']
          }
          : {
            'readOnly': true,
            'lineNumbers': true
          };

      this.errorEditor = new FusionAuth.UI.TextEditor(this.errorResponse)
          .withOptions(options)
          .render()
          .setHeight(200);
    }
  },

  _handleTestSuccess: function(xhr) {
    if (this.currentTestElement !== null) {
      this.currentTestElement .removeAttribute('name');
    }

    var response = JSON.parse(xhr.responseText);
    if (response.message) {
      this.okMessage.hide();
      this.errorMessage.show();
      if (this.errorEditor === null) {
        this._buildErrorEditor();
      }

      this.errorEditor.setValue(
          this.type === "Twilio"
              ? vkbeautify.xml(response.message || 'No response. Ensure you have filled out the required fields.')
              : response.message);
    } else {
      this.okMessage.show();
      this.errorMessage.hide();
      if (this.errorEditor !== null) {
        this.errorEditor.destroy();
        this.errorEditor = null;
      }
    }
  },

  _handleKafkaTestClick: function(event) {
    // This handler doesn't use the common one because it is using a specific success handler, but we could re-work that to take that as a parameter.
    Prime.Utils.stopEvent(event);
    var inProgress = new Prime.Widgets.InProgress(this.testConfiguration.queryUp('.panel')).withMinimumTime(400);
    this.producerEditor.sync();

    if (this.errors !== null) {
      this.errors.destroy();
      this.errors = null;
    }

    new Prime.Ajax.Request('/ajax/messenger/kafka/test', 'POST')
        .withDataFromForm(this.form)
        .withInProgress(inProgress)
        .withSuccessHandler(this._handleKafkaTestSuccess)
        .withErrorHandler(this._handleKafkaTestFailure)
        .go();
  },

  _handleKafkaTestFailure: function(xhr) {
    if (xhr.status === 400) {
      this.errors = new FusionAuth.UI.Errors()
          .withErrors(JSON.parse(xhr.responseText))
          .withForm(this.form)
          .initialize();
    } else {
      this._handleTestFailure(xhr);
    }
  },

  _handleTestClick: function(event, url, testKey, testElement) {
    Prime.Utils.stopEvent(event);

    // Adding a name attribute will cause this to get picked up in the form, remove it after we're done so it doesn't go in the form submit.
    this.currentTestElement = testElement;
    testElement.setAttribute('name', testKey);

    if (this.errors !== null) {
      this.errors.destroy();
      this.errors = null;
    }

    var inProgress = new Prime.Widgets.InProgress(this.testConfiguration.queryUp('.panel')).withMinimumTime(400);
    new Prime.Ajax.Request(url, 'POST')
        .withDataFromForm(this.form)
        .withInProgress(inProgress)
        .withSuccessHandler(this._handleTestSuccess)
        .withErrorHandler(this._handleTestFailure)
        .go();
  },

  _handleGenericTestClick: function(event) {
    this._handleTestClick(event, '/ajax/messenger/generic/test', 'testURL', this.testGeneric);
  },

  _handleKafkaTestSuccess: function(xhr) {
    var response = JSON.parse(xhr.responseText);
    if (response.status === 200) {
      this.okMessage.show();
      this.errorMessage.hide();
      if (this.errorEditor !== null) {
        this.errorEditor.destroy();
        this.errorEditor = null;
      }
    } else {
      this.okMessage.hide();
      this.errorMessage.show();
      if (this.errorEditor === null) {
        this.errorEditor = new FusionAuth.UI.TextEditor(this.errorResponse)
            .withOptions({
              'mode': 'json',
              'readOnly': true,
              'lint': true,
              'lineNumbers': true,
              'gutters': ['CodeMirror-lint-markers']
            })
            .render();
      }
      this.errorEditor.setValue(response.message);
    }
  }
};
