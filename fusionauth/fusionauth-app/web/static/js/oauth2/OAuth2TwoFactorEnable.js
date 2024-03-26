/*
 * Copyright (c) 2022-2023, FusionAuth, All Rights Reserved
 */
'use strict';

class OAuth2TwoFactorEnable {
  #enableForm;
  #qrCode;
  #selectMethod;
  #sendForm;

  /**
   * @constructor
  */
  constructor(enableForm, sendForm, qrCode, qrCodeURI){
    this.#enableForm = enableForm;
    this.#sendForm = sendForm;
    this.#qrCode = qrCode;

    if (this.#qrCode !== null) {
      new QRCode(this.#qrCode, {
        text: qrCodeURI
      });
    }

    if (this.#enableForm !== null) {
      this.#enableForm.addEventListener('submit', this.#handleOnSubmit.bind(this));
    }

    this.#selectMethod = document.getElementById('select-method');
    if (this.#selectMethod !== null) {
      // Bind an event listener, and call on page load to set the currently selected value.
      this.#selectMethod.addEventListener('change', this.#handleSelectChange.bind(this));
      this.#handleSelectChange();
    }
  }

  #handleOnSubmit() {
    // Sync the email & mobile phone between forms
    if (this.#sendForm !== null) {
      const email = this.#sendForm.querySelector('input[name="email"]');
      if (email !== null) {
        this.#enableForm.querySelector('input[name="email"]').value = email.value;
      }

      const mobilePhone = this.#sendForm.querySelector('input[name="mobilePhone"]');
      if (mobilePhone !== null) {
        this.#enableForm.querySelector('input[name="mobilePhone"]').value = mobilePhone.value;
      }
    }
  }

  #handleSelectChange() {
    document.querySelectorAll("[data-method-instructions]").forEach(element => {
      if (element.matches('[data-method-instructions=' + this.#selectMethod.value + ']')) {
        element.style.display = '';
      } else {
        element.style.display = 'none';
      }
    });

    // Update the hidden field for 'method' with the currently selected value.
    document.querySelectorAll('form input[type="hidden"][name="method"]').forEach(e => e.value = this.#selectMethod.value);
  }
}
