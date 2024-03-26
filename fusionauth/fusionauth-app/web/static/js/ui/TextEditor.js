/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

/**
 * Constructs a new TextEditor instance for the given element.
 *
 * @constructor
 * @param {PrimeElement|Element} element The element to create the TextEditor for.
 */
FusionAuth.UI.TextEditor = function(element) {
  Prime.Utils.bindAll(this);

  this.initialized = false;
  this.options = {
    autofocus: false,
    lineNumbers: true,
    lineWrapping: true,
    mode: 'freemarker'
  };

  this.keys = [];
  this.element = Prime.Document.Element.wrap(element);
};

FusionAuth.UI.TextEditor.constructor = FusionAuth.UI.TextEditor;
FusionAuth.UI.TextEditor.prototype = {

  /**
   * Adds the given class (or list of space separated classes) to the Code Mirror DOM element.
   *
   * @param {string} classNames The class name(s) separated by a space.
   * @returns {FusionAuth.UI.TextEditor}
   */
  addClass: function(classNames) {
    if (this.initialized) {
      this.editorElement.addClass(classNames);
    }
    return this;
  },

  /**
   * Destroy the editor instance and revert back to the original text area.
   * @returns {FusionAuth.UI.TextEditor}
   */
  destroy: function() {
    this.editor.toTextArea();
    this.initialized = false;
  },

  /**
   * Give focus to the CodeMirror widget.
   *
   * @returns {FusionAuth.UI.TextEditor}
   */
  focus: function() {
    this.editor.focus();
    return this;
  },

  /**
   * Returns the current value of the text editor
   * @returns {String}
   */
  getValue: function() {
    return this.editor.getDoc().getValue();
  },

  /**
   * Refresh the CodeMirror widget to re-flow any automatically calculated dimensions.
   *
   * @returns {FusionAuth.UI.TextEditor}
   */
  refresh: function() {
    if (this.initialized) {
      this.editor.refresh();
    }
    return this;
  },

  /**
   * Removes the given class (or list of space separated classes) from the Code Mirror DOM element.
   *
   * @param {string} classNames The class name(s).
   * @returns {FusionAuth.UI.TextEditor}
   */
  removeClass: function(classNames) {
    if (this.initialized) {
      this.editorElement.removeClass(classNames);
    }
    return this;
  },

  /**
   * Call render() to complete the initialization of the TextEditor. All options must be set prior to calling render.
   *
   * @returns {FusionAuth.UI.TextEditor} This TextEditor.
   */
  render: function() {
    if (this.initialized) {
      return this;
    }

    this.editor = CodeMirror.fromTextArea(this.element.domElement, this.options);
    this.editorElement = new Prime.Document.Element(this.editor.getWrapperElement());
    this.initialized = true;
    return this;
  },

  /**
   * Set the height of the editor.
   *
   * @param {Number} height The new height of the editor.
   * @returns {FusionAuth.UI.TextEditor} This TextEditor.
   */
  setHeight: function(height) {
    if (this.initialized) {
      this.editor.setSize(null, height);
    }

    return this;
  },

  /**
   * Set the option on the CodeMirror editor
   *
   * @param {String} name The name of the option.
   * @param {Object} value The value of the option.
   * @returns {FusionAuth.UI.TextEditor} This TextEditor.
   */
  setOption: function(name, value) {
    if (this.initialized) {
      this.editor.setOption(name, value);
    }
    return this;
  },

  /**
   * Set the value of the editor.
   *
   * @param {String} value The value to set into the text editor.
   * @returns {FusionAuth.UI.TextEditor} This TextEditor.
   */
  setValue: function(value) {
    this.editor.getDoc().setValue(value);

      this.editor.save();

    return this;
  },

  /**
   * Save the contents of the text editor back to the original text area. This happens automatically on form submit,
   * but there may be instances you'd like to save this prior to submit. When previewing the content for example.
   *
   * @returns {FusionAuth.UI.TextEditor} This TextEditor.
   */
  sync: function() {
    if (this.initialized) {
      this.editor.save();
    }
    return this;
  },

  /**
   * Set more than one option at a time by providing a map of key value pairs. This is considered an advanced
   * method to set options on the widget. The caller needs to know what properties are valid in the options object.
   *
   * @param {Object} options Key value pair of configuration options.
   * @returns {FusionAuth.UI.TextEditor} This TextEditor.
   */
  withOptions: function(options) {
    if (typeof options === 'undefined' || options === null) {
      return this;
    }

    for (var option in options) {
      if (options.hasOwnProperty(option)) {
        this.options[option] = options[option];
      }
    }
    return this;
  }

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

};
