/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.MessageTemplateForm = function(form) {
  Prime.Utils.bindAll(this);

  this.localizationDataSet = null;

  this.form = form;

  this.form.query('#text a[href$="preview"]').each(function(e) {
    e.addEventListener('click', this._handlePreviewClick);
  }.bind(this));

  // Setup the localized version table and template
  Prime.Document.queryById('add-localization').addEventListener('click', this._handleLocalizationAddClick);
  this.localizationTable = Prime.Document.queryById('localization-table');
  this.localizationExpandableTable = new FusionAuth.UI.ExpandableTable(this.localizationTable);

  this.localizationTable.query('td.action a[href="/ajax/message/template/validate-localization"]').each(function(e) {
    e.addEventListener('click', this._handleLocalizationEditClick);
  }.bind(this));

  this.localizationTable.query('td.action a[href="/ajax/message/template/preview"]').each(function(e) {
    e.addEventListener('click', this._handleLocalizationViewButtonPreviewClick);
  }.bind(this));

  this.textEditor = new FusionAuth.UI.TextEditor(form.queryFirst('textarea[name="messageTemplate.defaultTemplate"]'))
      .withOptions({'mode': 'freemarker', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true});
  new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withSelectCallback(this._renderTextEditor)
      .initialize();
};

FusionAuth.Admin.MessageTemplateForm.prototype = {
  _getDataFromLocalizationForm: function() {
    this.localizedEditor.sync();

    var form = this.localizationDialog.element.queryFirst('form');
    var data = {};
    data.localeDisplay = form.queryFirst('select').getSelectedTexts()[0];
    data.locale = form.queryFirst('select').getSelectedValues()[0];
    data.template = form.queryFirst('textarea[name=template]').getValue();
    return data;
  },

  _getLocalizationDataFromClickEvent: function(event) {
    var dataSet = Prime.Document.Element.wrap(event.target).queryUp('tr').getDataSet();
    return {
      locale: dataSet.locale,
      template: dataSet.template
    }
  },

  _renderTextEditor: function() {
    this.textEditor.render()
  },

  _handleLocalizationAddClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.localizationDataSet = null;

    var anchor = new Prime.Document.Element(event.currentTarget);
    this.localizationDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleLocalizationDialogOpenSuccess)
        .withAdditionalClasses('wide')
        .withFormHandling(true)
        .withFormPreSubmitCallback(this._handleLocalizationPreFormSubmit)
        .withFormSuccessCallback(this._handleLocalizationFormSuccess)
        .open(anchor.getAttribute('href'));
  },

  _handleLocalizationDialogOpenSuccess: function(dialog) {
    dialog.element.query('a[href$="preview"]').each(function(e) {
      e.addEventListener('click', this._handleLocalizationFormPreviewClick);
    }.bind(this));

    if (this.localizationDataSet !== null) {
      dialog.element.queryFirst('select').setSelectedValues(this.localizationDataSet.locale);
      dialog.element.queryFirst('textarea[name=template]').setValue(this.localizationDataSet.template);
    }

    this.localizedEditor = new FusionAuth.UI.TextEditor(dialog.element.queryFirst('textarea[name="template"]'))
        .withOptions({'mode': 'freemarker', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true});

    this.localizedEditor.render();
  },

  _handleLocalizationEditClick: function(event) {
    Prime.Utils.stopEvent(event);

    var anchor = new Prime.Document.Element(event.currentTarget);
    var tr = anchor.queryUp('tr');
    this.localizationDataSet = tr.getDataSet();
    this.localizationDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleLocalizationDialogOpenSuccess)
        .withAdditionalClasses('wide')
        .withFormHandling(true)
        .withFormPreSubmitCallback(this._handleLocalizationPreFormSubmit)
        .withFormSuccessCallback(this._handleLocalizationFormSuccess)
        .open(anchor.getAttribute('href'));
  },

  _handleLocalizationFormSuccess: function() {
    var data = this._getDataFromLocalizationForm();

    var row = null;
    this.localizationTable.query('tbody tr').each(function(r) {
      if (r.getDataSet().locale === data.locale) {
        row = r;
      }
    });

    if (row === null) {
      row = this.localizationExpandableTable.addRow(data);
      row.queryFirst('td.action a[href="/ajax/message/template/validate-localization"]')
         .addEventListener('click', this._handleLocalizationEditClick);
      row.queryFirst('td.action a[href="/ajax/message/template/preview"]')
         .addEventListener('click', this._handleLocalizationViewButtonPreviewClick);
    }

    var dataSet = row.getDataSet();
    dataSet.locale = data.locale;
    dataSet.template = data.template;

    Prime.Document.queryById("messageTemplate.localizedTemplates" + data.locale).setValue(data.template);

    // Finally close the dialog
    this.localizationDialog.close();
  },

  _handleLocalizationPreFormSubmit: function() {
    this.localizedEditor.sync();
  },

  _handleLocalizationFormPreviewClick: function(event) {
    this._handleLocalizationPreviewClick(event, true);
  },

  _handleLocalizationViewButtonPreviewClick: function(event) {
    this._handleLocalizationPreviewClick(event, false);
  },

  _handleLocalizationPreviewClick: function(event, formPreview) {
    Prime.Utils.stopEvent(event);

    var data = formPreview ? this._getDataFromLocalizationForm() : this._getLocalizationDataFromClickEvent(event);
    var extraData = {};
    extraData['previewLocale'] = data.locale;
    extraData['messageTemplate.localizedTemplates[' + data.locale + ']'] = data.template;

    var anchor = new Prime.Document.Element(event.target);
    new Prime.Widgets.AJAXDialog(anchor.getAttribute('title'))
        .withAdditionalClasses('wide')
        .openPost(anchor.getAttribute('href'), this.form, extraData);
  },

  _handlePreviewClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.textEditor.sync();

    var anchor = new Prime.Document.Element(event.target);
    new Prime.Widgets.AJAXDialog(anchor.getAttribute('title'))
        .withAdditionalClasses('wide')
        .openPost(anchor.getAttribute('href'), this.form, {});
  },
};
