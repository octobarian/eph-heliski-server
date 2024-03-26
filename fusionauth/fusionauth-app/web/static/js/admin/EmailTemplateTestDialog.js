/*
 * Copyright (c) 2020-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * @constructor
 */
FusionAuth.Admin.EmailTemplateTestDialog = function() {
  Prime.Utils.bindAll(this);

  this.errorEditor = null;
  Prime.Document.query('a[href^="/ajax/email/template/test/"]').addEventListener('click', this._handleTestClick);
};

FusionAuth.Admin.EmailTemplateTestDialog.constructor = FusionAuth.Admin.EmailTemplateTestDialog;
FusionAuth.Admin.EmailTemplateTestDialog.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleTestClick: function(event) {
    Prime.Utils.stopEvent(event);

    var anchor = new Prime.Document.Element(event.target);
    this.testDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleTestDialogOpen)
        .withAdditionalClasses('wide')
        .open(anchor.getAttribute('href'));
  },

  _handleTestDialogOpen: function() {
    // On open wire up the submit button and focus the first field, intentionally not using the default form handler.
    this.testDialog.element.queryFirst('form').addEventListener('submit', this._handleTestFormSubmit);
    this.testDialog.element.queryFirst('input[type="text"]').focus();

    var search = this.testDialog.element.queryFirst('input[name="q"]');
    var userInput = this.testDialog.element.queryFirst('input[name="userId"]');
    this.searchWidget = new FusionAuth.Admin.AJAXSearchWidget(search, userInput)
        .withRenderer(FusionAuth.Admin.AJAXSearchForm.UserIdSearchRenderer)
        .withResultProvider(function(json) {
          return json['users'];
        })
        .withSearchURI('/ajax/user/search.json')
        .initialize();
  },

  _handleTestFormSubmit: function(event) {
    Prime.Utils.stopEvent(event);
    Prime.Document.queryById('sent-ok').addClass('hidden');

    var submitButton = this.testDialog.element.queryFirst('button');
    var submitIcon = this.testDialog.element.queryFirst('button i');
    submitIcon.removeClass('fa-arrow-right').addClass('fa-spinner fa-spin fa-fw');
    submitButton.addClass('disabled').setAttribute('disabled', 'disabled');

    var search = this.testDialog.element.queryFirst('input[name="q"]');
    if (search.getValue() === '') {
      this.testDialog.element.queryFirst('input[name="userId"]').setValue('');
    }

    new Prime.Ajax.Request('/ajax/email/template/test', 'POST')
        .withDataFromForm(this.testDialog.element.queryFirst('form'))
        .withSuccessHandler(this._handleTestSuccess)
        .withErrorHandler(this._handleTestError)
        .go();
  },

  _handleTestSuccess: function(xhr) {
    var submitButton = this.testDialog.element.queryFirst('button');
    var submitIcon = this.testDialog.element.queryFirst('button i');
    submitButton.removeClass('disabled').removeAttribute('disabled');
    submitIcon.removeClass('fa-spinner fa-spin')
              .addClass('fa-arrow-right');

    // Always expecting this to be 200 or 202, so check for errors.
    var response = JSON.parse(xhr.responseText);
    var userId = this.testDialog.element.queryFirst('form').queryFirst('input[name="userId"]').getValue();
    var errors = response.results[userId] || {};
    if (errors && (Object.keys(errors.parseErrors).length > 0 || Object.keys(errors.renderErrors).length > 0)) {
    var errorResponse = Prime.Document.queryById('email-error-response');
      errorResponse.removeClass('hidden');
      if (this.errorEditor !== null) {
        this.errorEditor.destroy();
      }

      this.errorEditor = new FusionAuth.UI.TextEditor(Prime.Document.queryById('email-error-textarea'))
          .withOptions({
            'readOnly': true,
            'lineNumbers': true
          })
          .render()
          .setHeight(225);

      this.errorEditor.setValue(JSON.stringify(errors, null, 2));
    } else {
      Prime.Document.queryById('sent-ok').removeClass('hidden');
    }
  },

  _handleTestError: function(xhr) {
    this.testDialog.setHTML(xhr.responseText);
  }
};
