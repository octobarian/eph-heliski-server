/*
 * Copyright (c) 2022-2023, FusionAuth, All Rights Reserved
 */
'use strict';

class OAuth2WebAuthnLogin {
  #uvpaAvailableField;
  #webAuthnRequestField;
  #form;

  /**
  * @constructor
  *
  * @param {HTMLFormElement} form the form containing WebAuthn authentication fields
  * @param {HTMLInputElement} webAuthnRequestField the form field where the serialized authenticator response will be placed
  */
  constructor(form, webAuthnRequestField) {
    this.#form = form;
    this.#webAuthnRequestField = webAuthnRequestField;
    this.#uvpaAvailableField = this.#form.querySelector('input[name="userVerifyingPlatformAuthenticatorAvailable"]');
    if (this.#uvpaAvailableField !== null && typeof(PublicKeyCredential) !== 'undefined' && PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable) {
      PublicKeyCredential
        .isUserVerifyingPlatformAuthenticatorAvailable()
        .then(result => this.#uvpaAvailableField.value = result);
    }

    this.#form.addEventListener('submit', this.#handleFormSubmit.bind(this));
  }

  /**
  * Handle the form submit to WebAuthn authentication process
  *
  * @param {Event} event the click event
  */
  #handleFormSubmit(event) {
    event.preventDefault();
    event.stopPropagation();

    var input = FormHelper.buildInputElementFromEventSubmitterValue(event);
    if (input !== null) {
      this.#form.appendChild(input);
    }

    let formData = new FormData(this.#form);
    const options = {
      method: 'POST',
      body: formData
    };

    fetch('/oauth2/ajax/webauthn/start-login', options)
      .then(async response => {
        if (response.ok) {
          return response.json();
        } else {
          const body = JSON.stringify(await response.json(), null, 2);
          throw new Error(`\nStatus: ${response.status}\n${body}`);
        }
      })
      .then(response => this.#assertCredential(response.options))
      .then(cred => {
        this.#webAuthnRequestField.value = btoa(JSON.stringify(cred)) || null;
        this.#form.submit();
      })
      .catch(error => {
        console.debug(error);
        // Go ahead and submit the form so that we can complete the validation.
        this.#form.submit();
      });
  }

  /**
  * Call the WebAuthn API to get a signature for an existing credential
  *
  * @param {PublicKeyCredentialRequestOptions} options the request options returned by the server
  * @returns {Promise<PublicKeyCredential>} the credential signature information
  */
  #assertCredential(options) {
    const requestOptions = {
      // publicKey indicates this is for WebAuthn
      publicKey: {
        ...options,
        challenge: FusionAuth.Util.base64URLToBuffer(options.challenge),
        allowCredentials: options.allowCredentials.map(c => {
          return {
            ...c,
            id: FusionAuth.Util.base64URLToBuffer(c.id)
          }
        })
      }
    };
    return navigator.credentials.get(requestOptions)
      .then(credential => {
        let userHandle = undefined;
        if (credential.response.userHandle) {
          userHandle = FusionAuth.Util.bufferToBase64URL(credential.response.userHandle);
        }
        return {
          id: credential.id,
          response: {
            authenticatorData: FusionAuth.Util.bufferToBase64URL(credential.response.authenticatorData),
            clientDataJSON: FusionAuth.Util.bufferToBase64URL(credential.response.clientDataJSON),
            signature: FusionAuth.Util.bufferToBase64URL(credential.response.signature),
            userHandle
          },
          rpId: requestOptions.publicKey.rpId || null,
          type: credential.type,
          clientExtensionResults: credential.getClientExtensionResults()
        };
      })
      .catch(_error => {
        console.debug(_error)
      });
  }
}
