/*
 * Copyright (c) 2022, FusionAuth, All Rights Reserved
 */
'use strict';

/**
* Contains methods to help with WebAuthn credential registration
*
* @author Spencer Witt
*/
class WebAuthnHelper {
  /**
  * Call the WebAuthn API to create a new credential
  *
  * @param {PublicKeyCredentialCreationOptions} options the creation options returned by the server
  * @return {Promise<PublicKeyCredential>} the credential created by the authenticator
  */
  static registerCredential(options) {
    // base64-encoded fields must be converted to buffers
    const creationOptions = {
      // publicKey indicates this is for WebAuthn
      publicKey: {
        ...options,
        challenge: FusionAuth.Util.base64URLToBuffer(options.challenge),
        excludeCredentials: options.excludeCredentials?.map(c => {
          return {
            ...c,
            id: FusionAuth.Util.base64URLToBuffer(c.id)
          }
        }) ?? [],
        user: {
          ...options.user,
          id: FusionAuth.Util.base64URLToBuffer(options.user.id)
        }
      }
    }
    return navigator.credentials.create(creationOptions)
      .then(credential => {
        if (credential === null) {
          // Note: MDN docs claim that sometimes the credential will come back as null. If that happens, can we be more specific?
          //       See: https://developer.mozilla.org/en-US/docs/Web/API/CredentialsContainer/create
          throw new Error('Failed to create new credential');
        } else {
          return {
            id: credential.id,
            response: {
              attestationObject: FusionAuth.Util.bufferToBase64URL(credential.response.attestationObject),
              clientDataJSON: FusionAuth.Util.bufferToBase64URL(credential.response.clientDataJSON)
            },
            rpId: creationOptions.publicKey.rp.id || null,
            type: credential.type,
            clientExtensionResults: credential.getClientExtensionResults(),
            transports: typeof credential.response.getTransports === 'undefined' ? [] : credential.response.getTransports()
          };
        }
      });
  }

  /**
  * Checks whether WebAuthn is supported by the current browser
  *
  * @returns {boolean} true if WebAuthn is supported, false otherwise
  */
  static isWebAuthnSupported() {
    return typeof(PublicKeyCredential) !== 'undefined';
  }
}
