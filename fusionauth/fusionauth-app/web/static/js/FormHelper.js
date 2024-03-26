/*
 * Copyright (c) 2022, FusionAuth, All Rights Reserved
 */
'use strict';

/**
* Form related helper methods.
*
* @author Daniel DeGroff
*/
class FormHelper {
  /**
  * Collect the name and value from an event submitter. This is useful if you want to use the name and value on a submit button but are handling the request via AJAX.
  *
  * @param {Event} event the event
  * @return {HTMLInputElement} an input element or null.
  */
  static buildInputElementFromEventSubmitterValue(event) {
    if (typeof(event.submitter) !== 'undefined') {
      const name = event.submitter.getAttribute('name');
      const value = event.submitter.getAttribute('value');

      if (name !== null && value !== null) {
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = name;
        input.value = value;
        return input;
      }
    }

    return null;
  }
}
