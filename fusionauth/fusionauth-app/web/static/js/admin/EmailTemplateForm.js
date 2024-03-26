/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.EmailTemplateForm = function(form) {
  Prime.Utils.bindAll(this);

  this.localizationDataSet = null;

  this.form = form;

  Prime.Document.query('#text a[href$="preview"], #html a[href$="preview"]').each(function(e) {
    e.addEventListener('click', this._handlePreviewClick);
  }.bind(this));

  // Setup the localized version table and template
  Prime.Document.queryById('add-localization').addEventListener('click', this._handleLocalizationAddClick);
  this.localizationTable = Prime.Document.queryById('localization-table');
  this.localizationExpandableTable = new FusionAuth.UI.ExpandableTable(this.localizationTable);

  this.localizationTable.query('td.action a[href="/ajax/email/template/validate-localization"]').each(function(e) {
    e.addEventListener('click', this._handleLocalizationEditClick);
  }.bind(this));

  this.localizationTable.query('td.action a[href="/ajax/email/template/preview"]').each(function(e) {
    e.addEventListener('click', this._handleLocalizationViewButtonPreviewClick);
  }.bind(this))

  this.textEditor = new FusionAuth.UI.TextEditor(form.queryFirst('textarea[name="emailTemplate.defaultTextTemplate"]'))
      .withOptions({'mode': 'freemarker', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true});
  this.htmlEditor = new FusionAuth.UI.TextEditor(form.queryFirst('textarea[name="emailTemplate.defaultHtmlTemplate"]'))
      .withOptions({'mode': 'freemarker', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true});

  // Init the tabs
  new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withSelectCallback(this._handleTabSelect)
      .initialize();
};

FusionAuth.Admin.EmailTemplateForm.prototype = {
  _getDataFromLocalizationForm: function() {
    var form = this.localizationDialog.element.queryFirst('form');
    var data = {};
    data.localeDisplay = form.queryFirst('select').getSelectedTexts()[0];
    data.locale = form.queryFirst('select').getSelectedValues()[0];
    data.subject = form.queryFirst('input[name=subject]').getValue();
    data.fromName = form.queryFirst('input[name=fromName]').getValue();
    data.textTemplate = form.queryFirst('textarea[name=textTemplate]').getValue();
    data.htmlTemplate = form.queryFirst('textarea[name=htmlTemplate]').getValue();
    return data;
  },

  _getLocalizationDataFromClickEvent: function(event) {
    var dataSet = Prime.Document.Element.wrap(event.target).queryUp('tr').getDataSet();
    return {
      locale: dataSet.locale,
      textTemplate: dataSet.textTemplate,
      htmlTemplate: dataSet.htmlTemplate,
      fromName: dataSet.fromName,
      subject: dataSet.subject
    }
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
      dialog.element.queryFirst('input[name=subject]').setValue(this.localizationDataSet.subject);
      dialog.element.queryFirst('input[name=fromName]').setValue(this.localizationDataSet.fromName);
      dialog.element.queryFirst('textarea[name=htmlTemplate]').setValue(this.localizationDataSet.htmlTemplate);
      dialog.element.queryFirst('textarea[name=textTemplate]').setValue(this.localizationDataSet.textTemplate);
    }

    this.localizedTextEditor = new FusionAuth.UI.TextEditor(dialog.element.queryFirst('textarea[name="textTemplate"]'))
        .withOptions({'mode': 'freemarker', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true});
    this.localizedHtmlEditor = new FusionAuth.UI.TextEditor(dialog.element.queryFirst('textarea[name="htmlTemplate"]'))
        .withOptions({'mode': 'freemarker', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true});

    // Setup the tabs
    new Prime.Widgets.Tabs(dialog.element.queryFirst('.tabs'))
        .withSelectCallback(this._handleLocalizedTabSelect)
        .initialize();
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
      row.queryFirst('td.action a[href="/ajax/email/template/validate-localization"]').addEventListener('click', this._handleLocalizationEditClick);
      row.queryFirst('td.action a[href="/ajax/email/template/preview"]').addEventListener('click', this._handleLocalizationViewButtonPreviewClick);
    }

    var dataSet = row.getDataSet();
    dataSet.locale = data.locale;
    dataSet.fromName = data.fromName;
    dataSet.htmlTemplate = data.htmlTemplate;
    dataSet.subject = data.subject;
    dataSet.textTemplate = data.textTemplate;

    this._replaceFieldValues(data);

    // Finally close the dialog
    this.localizationDialog.close();
  },

  /**
   * @private
   */
  _handleLocalizationPreFormSubmit: function() {
    // Sync up the text areas since we're submitting the form through AJAX.
    if (this.localizedTextEditor) {
      this.localizedTextEditor.sync();
    }
    if (this.localizedHtmlEditor) {
      this.localizedHtmlEditor.sync();
    }
  },

  _handleLocalizationFormPreviewClick: function(event) {
    this._handleLocalizationPreviewClick(event, true);
  },

  _handleLocalizationViewButtonPreviewClick: function(event) {
    this._handleLocalizationPreviewClick(event, false);
  },

  _handleLocalizationPreviewClick: function(event, formPreview) {
    Prime.Utils.stopEvent(event);

    // Sync up the text areas since we're submitting the form through AJAX.
    if (this.localizedTextEditor) {
      this.localizedTextEditor.sync();
    }
    if (this.localizedHtmlEditor) {
      this.localizedHtmlEditor.sync();
    }

    var data = formPreview ? this._getDataFromLocalizationForm() : this._getLocalizationDataFromClickEvent(event);
    var extraData = {};
    extraData['previewLocale'] = data.locale;
    extraData['emailTemplate.localizedFromNames[' + data.locale + ']'] = data.fromName;
    extraData['emailTemplate.localizedHtmlTemplates[' + data.locale + ']'] = data.htmlTemplate;
    extraData['emailTemplate.localizedSubjects[' + data.locale + ']'] = data.subject;
    extraData['emailTemplate.localizedTextTemplates[' + data.locale + ']'] = data.textTemplate;

    var anchor = new Prime.Document.Element(event.target);
    new Prime.Widgets.AJAXDialog(anchor.getAttribute('title'))
        .withCallback(this._handlePreviewSuccess)
        .withAdditionalClasses('wide')
        .openPost(anchor.getAttribute('href'), this.form, extraData);
  },

  _handleLocalizedTabSelect: function(tab, tabContent) {
    if (tabContent.getId() === 'localization-text-template') {
      this.localizedTextEditor.render();
    } else if (tabContent.getId() === 'localization-html-template') {
      this.localizedHtmlEditor.render();
    }
  },

  _handlePreviewClick: function(event) {
    Prime.Utils.stopEvent(event);

    // Sync up the text areas for preview.
    if (this.htmlEditor) {
      this.htmlEditor.sync();
    }
    if (this.textEditor) {
      this.textEditor.sync();
    }

    var anchor = new Prime.Document.Element(event.target);
    new Prime.Widgets.AJAXDialog(anchor.getAttribute('title'))
        .withCallback(this._handlePreviewSuccess)
        .withAdditionalClasses('wide')
        .openPost(anchor.getAttribute('href'), this.form, {});
  },

  _handlePreviewSuccess: function(dialog) {
    new Prime.Widgets.Tabs(dialog.element.queryFirst('.tabs')).initialize();
    var htmlIframe = dialog.element.queryFirst('#html-localization iframe').domElement.contentWindow.document;
    var html = FusionAuth.Util.unescapeHTML(dialog.element.queryFirst('#html-localization #html-source').getHTML());
    htmlIframe.open();
    htmlIframe.write(html);
    htmlIframe.close();
  },

  _handleTabSelect: function(tab, tabContent) {
    if (tabContent.getId() === 'text') {
      this.textEditor.render();
    } else if (tabContent.getId() === 'html') {
      this.htmlEditor.render();
    }
  },

  /**
   * Need to move the updated data-XXX attributes into the row, otherwise the edits won't get passed to the action.
   */
  _replaceFieldValues: function(data) {
    Prime.Document.queryById("emailTemplate.localizedFromNames" + data.locale).setValue(data.fromName);
    Prime.Document.queryById("emailTemplate.localizedSubjects" + data.locale).setValue(data.subject);
    Prime.Document.queryById("emailTemplate.localizedHtmlTemplates" + data.locale).setValue(data.htmlTemplate);
    Prime.Document.queryById("emailTemplate.localizedTextTemplates" + data.locale).setValue(data.textTemplate);
  }
};
