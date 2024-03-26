/*
 * Copyright (c) 2019-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the theme form by setting up an ExpandableTable for the headers.
 *
 * @param {array} templateNames The named templates.
 * @constructor
 */
FusionAuth.Admin.ThemeForm = function(templateNames) {
  Prime.Utils.bindAll(this);

  // Create all the editors and put them in a hash keyed of the name (which is the id of the tab)
  this.editors = {};
  templateNames.forEach(function(name) {
    var element = Prime.Document.queryFirst('textarea[name="theme.templates.' + name + '"]');
    this.editors[name] = new FusionAuth.UI.TextEditor(element)
        .withOptions({'mode': 'freemarker', 'lineWrapping': true, 'readOnly': element.isDisabled()});
  }.bind(this));

  // Add the CSS editor
  var element = Prime.Document.queryFirst('textarea[name="theme.stylesheet"]');
  this.editors['stylesheet'] = new FusionAuth.UI.TextEditor(element)
      .withOptions({'mode': 'css', 'lineWrapping': true, 'readOnly': element.isDisabled()});

  var defaultMessages = Prime.Document.queryFirst('textarea[name="theme.defaultMessages"]');
  if (defaultMessages !== null) {
    this.editors['messages'] = new FusionAuth.UI.TextEditor(defaultMessages)
        .withOptions({
          'mode': 'properties',
          'lint': true,
          'gutters': ['CodeMirror-lint-markers'],
          'lineWrapping': true,
          'readOnly': defaultMessages.isDisabled()
        });
  }

  new Prime.Widgets.Tabs(Prime.Document.queryById('ui-tabs'))
      .withErrorClassHandling('error')
      .withSelectCallback(this._handleUITabSelect)
      .withLocalStorageKey('settings.theme.ui-configuration.tabs')
      .initialize();

  // Set up the localized version table and template
  var addLocalizationButton = Prime.Document.queryById('add-localization');
  if (addLocalizationButton !== null) {
    addLocalizationButton.addEventListener('click', this._handleLocalizationAddClick)
  }

  this.localizationDataSet = null;
  this.localizationTable = Prime.Document.queryById('localization-table');
  if (this.localizationTable !== null) {
    this.localizationExpandableTable = new FusionAuth.UI.ExpandableTable(this.localizationTable);
    this.localizationTable.query('td.action a:first-of-type').each(function(e) {
      e.addEventListener('click', this._handleLocalizationEditClick);
    }.bind(this));
  }

  Prime.Document.query('a[href^="/ajax/theme/copy-default-template"]').addEventListener('click', this._handleCopyTemplateClick);
};

FusionAuth.Admin.ThemeForm.constructor = FusionAuth.Admin.ThemeForm;
FusionAuth.Admin.ThemeForm.prototype = {
  /**
   * @private
   */
  _getDataFromLocalizationForm: function() {
    var form = this.localizationDialog.element.queryFirst('form');
    var data = {};
    var select = form.queryFirst('select');
    if (select !== null) {
      data.localeDisplay = select.getSelectedTexts()[0];
      data.locale = select.getSelectedValues()[0];
    }
    data.isDefault = form.queryFirst('input[name=isDefault]').getValue() === 'true';
    data.messages = form.queryFirst('textarea').getValue();
    return data;
  },

  _handleCopyTemplateClick: function(event) {
    Prime.Utils.stopEvent(event);
    var button = new Prime.Document.Element(event.currentTarget);
    var href = button.getAttribute('href');
    var templateName = href.substr(href.indexOf('?templateName=') + 14);
    var editor = this.editors[templateName];
    new Prime.Ajax.Request(button.getAttribute('href'), 'GET')
        .withSuccessHandler(function(xhr) {
          var response = JSON.parse(xhr.responseText);
          editor.setValue(response.template);
        })
        .go();
  },

  /**
   * @private
   */
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

  /**
   * @private
   */
  _handleLocalizationDialogOpenSuccess: function(dialog) {
    if (this.localizationDataSet !== null) {
      // The select is optional for the default messages
      var select = dialog.element.queryFirst('select');
      if (select !== null) {
        select.setSelectedValues(this.localizationDataSet.locale);
      }
      dialog.element.queryFirst('textarea').setValue(this.localizationDataSet.messages);
    }

    this.localizedEditor = new FusionAuth.UI.TextEditor(dialog.element.queryFirst('textarea'))
        .withOptions({'mode': 'properties', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true})
        .render();

    var missingPropertiesElement = Prime.Document.queryById('missingProperties');
    if (missingPropertiesElement !== null) {
      new FusionAuth.UI.TextEditor(missingPropertiesElement)
          .withOptions({'mode': 'properties', 'lint': true, 'gutters': ['CodeMirror-lint-markers'], 'lineWrapping': true, 'readOnly': true})
          .render()
          .setHeight(100);
    }
  },

  /**
   * @private
   */
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

  /**
   * @private
   */
  _handleLocalizationFormSuccess: function() {
    var data = this._getDataFromLocalizationForm();
    var row = null;
    if (data.isDefault) {
      row = this.localizationTable.queryFirst('tr[data-is-default=true]');
    } else {
      this.localizationTable.query('tbody tr').each(function(r) {
        if (r.getDataSet().locale === data.locale) {
          row = r;
        }
      });
    }

    if (row === null) {
      row = this.localizationExpandableTable.addRow(data);
      row.queryFirst('a:first-of-type').addEventListener('click', this._handleLocalizationEditClick);
    }

    var dataSet = row.getDataSet();
    dataSet.isDefault = data.isDefault;
    dataSet.locale = data.locale;
    dataSet.messages = data.messages;

    this._replaceFieldValues(data);

    // Finally close the dialog
    this.localizationDialog.close();
  },

  /**
   * @private
   */
  _handleLocalizationPreFormSubmit: function() {
    // Sync up the text area since we're submitting the form through AJAX.
    if (this.localizedEditor) {
      this.localizedEditor.sync();
    }
  },

  /**
   * @private
   */
  _handleUITabSelect: function(tab, tabContent) {
    if (this.editors.hasOwnProperty(tabContent.getId())) {
      this.editors[tabContent.getId()].render().setHeight(890);
    }
  },

  /**
   * Need to move the updated data-XXX attributes into the row, otherwise the edits won't get passed to the action.
   */
  _replaceFieldValues: function(data) {
    if (data.isDefault) {
      Prime.Document.queryById("theme.defaultMessages").setValue(data.messages);
    } else {
      Prime.Document.queryById("theme.localizedMessages" + data.locale).setValue(data.messages);
    }
  }
};
