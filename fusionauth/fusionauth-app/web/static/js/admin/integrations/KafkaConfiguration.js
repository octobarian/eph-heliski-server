/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};
'use strict';

/**
 * Handles the Kafka Configuration form.
 *
 * @constructor
 */
FusionAuth.Admin.KafkaConfiguration = function() {
  Prime.Utils.bindAll(this);

  this.kafkaSettings = Prime.Document.queryById('kafka-enabled-settings');
  this.producer = Prime.Document.queryById('producerConfiguration');

  this.errorResponse = Prime.Document.queryById('kafka-error-response');
  this.errorEditor = null;
  this.errorMessage = Prime.Document.queryById('kafka-error');
  this.okMessage = Prime.Document.queryById('kafka-ok');
  this.form = Prime.Document.queryById('kafka-integration');
  this.formErrors = null;

  this.producerEditor = new FusionAuth.UI.TextEditor(this.producer)
      .withOptions({
        'mode': 'properties',
        'lineNumbers': true,
        'gutters': ['CodeMirror-lint-markers']
      })
      .render();

  this.testConfiguration = Prime.Document.queryById('send-test-message').addEventListener('click', this._handleTestClick);
};

FusionAuth.Admin.KafkaConfiguration.constructor = FusionAuth.Admin.KafkaConfiguration;
FusionAuth.Admin.KafkaConfiguration.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleTestClick: function(event) {
    Prime.Utils.stopEvent(event);
    if (this.formErrors !== null) {
      this.formErrors.destroy();
    }
    var inProgress = new Prime.Widgets.InProgress(this.testConfiguration.queryUp('.panel')).withMinimumTime(400);
    this.producerEditor.sync();
    new Prime.Ajax.Request('/ajax/integration/kafka/test', 'POST')
        .withData({
          'primeCSRFToken' : this.kafkaSettings.queryUp('form').queryFirst('input[type="hidden"][name="primeCSRFToken"]').getValue(),
          'configuration.defaultTopic': this.kafkaSettings.queryFirst('input[name="integrations.kafka.defaultTopic"]').getValue(),
          'producerConfiguration': this.kafkaSettings.queryFirst('textarea[name="producerConfiguration"]').getValue()
        })
        .withInProgress(inProgress)
        .withSuccessHandler(this._handleTestSuccess)
        .withErrorHandler(this._handleTestFailure)
        .go();
  },

  _handleTestFailure: function(event) {
    if (event.status === 401) {
      location.reload();
    } else if (event.status === 400 && event.responseText){
      const errorResponse = JSON.parse(event.responseText);
      this.formErrors = new FusionAuth.UI.Errors()
                 .withErrors(errorResponse)
                 .withForm( Prime.Document.Element.wrap(this.form))
                 .initialize();
    }
  },

  _handleTestSuccess: function(event) {
    var response = JSON.parse(event.responseText);
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