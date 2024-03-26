/*
 * Copyright (c) 2022, FusionAuth, All Rights Reserved
 */
'use strict';

/**
* @author Spencer Witt
*/
class OAuth2WebAuthnRegistration {
  #form;

  /**
  * @constructor
  *
  * @param {HTMLFormElement} form the HTML form element containing fields for WebAuthn registration
  */
  constructor(form) {
    this.#form = form;
    this.#form.addEventListener('submit', this.#handleFormSubmit.bind(this));
  }

  /**
  * Handle the form submit to WebAuthn authentication process
  *
  * @param {Event} event the submit event
  */
  #handleFormSubmit(event) {
    event.preventDefault();
    event.stopPropagation();

    var input = FormHelper.buildInputElementFromEventSubmitterValue(event);
    if (input !== null) {
      this.#form.appendChild(input);
    }

    let formData = new FormData(this.#form);
    formData.set('userAgent', window.navigator.userAgent);

    const options = {
      method: 'POST',
      body: formData
    };

    fetch(this.#form.dataset.startRegistrationAction, options)
      .then(async response => {
        if (response.ok) {
          return response.json();
        } else {
          const body = JSON.stringify(await response.json(), null, 2);
          throw new Error(`\nStatus: ${response.status}\n${body}`);
        }
      })
      .then(response => WebAuthnHelper.registerCredential(response.options))
      .then(cred => {
        this.#form.querySelector('input[name="webAuthnRegisterRequest"]').value = btoa(JSON.stringify(cred));
        this.#form.submit();
      })
      .catch(error => {
        console.debug(error);
        // Go ahead and submit the form so that we can complete the validation.
        this.#form.submit();
      });
  }
}
