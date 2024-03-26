[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="accessTokenKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="accessTokenPopulateLambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="idTokenPopulateLambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="samlv2PopulateLambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="fusionAuthHost" type="java.lang.String" --]
[#-- @ftlvariable name="idTokenKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlv2AuthNSigningKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlv2LogoutRequestSigningKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlv2LogoutResponseSigningKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlv2AuthNVerificationKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlv2LogoutVerificationKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlv2AssertionEncryptionTransportKey" type="io.fusionauth.domain.Key" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#-- TODO : Future :
 - Display Form name & Id
 - We may want to re-work the self-service registration section and form stuff?
 - We kind of have a mix of "tab" to "section" but it isn't all that way.
--]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=application propertyName="name"/]
    [@properties.rowEval nameKey="id" object=application propertyName="id"/]
    [@properties.row nameKey="tenant" value=helpers.tenantName(application.tenantId)/]
    [@properties.rowEval nameKey="verifyRegistration" object=application propertyName="verifyRegistration" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="verificationEmailTemplateId" object=application propertyName="forgotPasswordEmailTemplateId" /]
    [@properties.rowEval nameKey="insertInstant" object=application propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=application propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#-- OAuth v2 / OpenID Connect Integration --]
  <h3>[@message.print key="oauth.integration-information"/]</h3>
  [@properties.table]
    [#setting url_escaping_charset='UTF-8']
[#--    [@properties.row nameKey="simpleLogin" value=(fusionAuthHost + "/app/login/" + application.oauthConfiguration.clientId) /]--]
    [#assign redirectValues]
      [#list application.oauthConfiguration.authorizedRedirectURLs as redirect ]
      <div ${redirect?is_last?then("", "class='mb-2'")}>
        ${fusionAuthHost}/oauth2/authorize?client_id=${application.oauthConfiguration.clientId}&response_type=code&redirect_uri=<span class='blue-text'><strong>${redirect.toString()?url}</strong></span>
      </div>
      [#else]
      <div>
        ${fusionAuthHost}/oauth2/authorize?client_id=${application.oauthConfiguration.clientId}&response_type=code&redirect_uri=<span class='red-text'><strong>{your redirect URI here}</strong></span>
      </div>
      [/#list]
    [/#assign]
    [@properties.row nameKey="${(application.oauthConfiguration.authorizedRedirectURLs?size > 1)?then('oauth.idpLoginURLs', 'oauth.idpLoginURL')}" value=redirectValues/]
    [#if application.registrationConfiguration.enabled]
    [#assign redirectValues]
      [#list application.oauthConfiguration.authorizedRedirectURLs as redirect ]
      <div ${redirect?is_last?then("", "class='mb-2'")}>
        ${fusionAuthHost}/oauth2/register?client_id=${application.oauthConfiguration.clientId}&response_type=code&redirect_uri=<span class='blue-text'><strong>${redirect.toString()?url}</strong></span>
      </div>
      [#else]
      <div>
        ${fusionAuthHost}/oauth2/register?client_id=${application.oauthConfiguration.clientId}&response_type=code&redirect_uri=<span class='red-text'><strong>{your redirect URI here}</strong></span>
      </div>
      [/#list]
    [/#assign]
    [@properties.row nameKey="${(application.oauthConfiguration.authorizedRedirectURLs?size > 1)?then('oauth.idpRegisterURLs', 'oauth.idpRegisterURL')}" value=redirectValues/]
    [/#if]
    [@properties.row nameKey="oauth.idpLogoutURL" value=(fusionAuthHost + "/oauth2/logout?client_id=" + application.oauthConfiguration.clientId)/]
    [@properties.row nameKey="oauth.introspectURL" value=(fusionAuthHost + "/oauth2/introspect")/]
    [@properties.row nameKey="oauth.tokenURL" value=(fusionAuthHost + "/oauth2/token")/]
    [@properties.row nameKey="oauth.userinfoURL" value=(fusionAuthHost + "/oauth2/userinfo")/]
    [@properties.row nameKey="oauth.deviceURL" value=(fusionAuthHost + "/oauth2/device_authorize")/]
    [@properties.row nameKey="oauth.openIdConfiguration" value=(fusionAuthHost + "/${application.tenantId}/.well-known/openid-configuration") /]
    [@properties.row nameKey="oauth.jwks" value=(fusionAuthHost + "/.well-known/jwks.json") /]
    [@properties.row nameKey="accountURL" value=(fusionAuthHost + "/account/?client_id=" + application.oauthConfiguration.clientId) /]
  [/@properties.table]

  [#-- OAuth Configuration --]
  <h3>[@message.print key="oauth"/]</h3>
  [@properties.table]
    [@properties.row nameKey="oauth.clientId" value=properties.display(application.oauthConfiguration, "clientId", application.id.toString())/]
    [@properties.rowEval nameKey="oauth.clientSecret" object=application.oauthConfiguration propertyName="clientSecret" classes="scrollable horizontal"/]
    [@properties.row nameKey="oauth.clientAuthenticationPolicy" value=message.inline("ClientAuthenticationPolicy." + application.oauthConfiguration.clientAuthenticationPolicy)/]
    [@properties.row nameKey="oauth.proofKeyForCodeExchangePolicy" value=message.inline("ProofKeyForCodeExchangePolicy." + application.oauthConfiguration.proofKeyForCodeExchangePolicy)/]
    [@properties.rowEval nameKey="oauth.generateRefreshTokens" object=application.oauthConfiguration propertyName="generateRefreshTokens" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="oauth.debug" object=application.oauthConfiguration propertyName="debug" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="oauth.authorizedRedirects" object=application.oauthConfiguration propertyName="authorizedRedirectURLs"/]
    [@properties.rowEval nameKey="oauth.authorizedOriginURLs" object=application.oauthConfiguration propertyName="authorizedOriginURLs"/]
    [@properties.rowEval nameKey="oauth.logoutURL" object=application.oauthConfiguration propertyName="logoutURL"/]
    [@properties.row nameKey="oauth.logoutBehavior" value=message.inline(application.oauthConfiguration.logoutBehavior)/]
    [@properties.row nameKey="oauth.enabledGrants" value=properties.join(application.oauthConfiguration.enabledGrants, true)/]
    [@properties.rowEval nameKey="oauth.deviceVerificationURL" object=application.oauthConfiguration propertyName="deviceVerificationURL"/]
    [@properties.rowEval nameKey="oauth.requireRegistration" object=application.oauthConfiguration propertyName="requireRegistration" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- CleanSpeak Configuration --]
  [#if (application.cleanSpeakConfiguration.enabled)!false]
    <h3>[@message.print key="cleanSpeak-configuration"/]</h3>
    [@properties.table]
      [@properties.rowEval nameKey="cleanspeak.applicationIds" object=application.cleanSpeakConfiguration propertyName="applicationIds"/]
      [@properties.rowEval nameKey="cleanspeak.username.moderation.enabled" object=application.cleanSpeakConfiguration.usernameModeration propertyName="enabled" booleanAsCheckmark=false/]
      [@properties.rowEval nameKey="cleanspeak.username.moderation.applicationId" object=application.cleanSpeakConfiguration.usernameModeration propertyName="applicationId"/]
    [/@properties.table]
  [/#if]

  [#-- Email Configuration --]
  <h3>[@message.print key="email-settings"/]</h3>
  [@properties.table]
    [#list [
    "emailVerificationEmailTemplateId",
    "emailVerifiedEmailTemplateId",
    "forgotPasswordEmailTemplateId",
    "loginNewDeviceEmailTemplateId",
    "loginSuspiciousEmailTemplateId",
    "passwordlessEmailTemplateId",
    "passwordResetSuccessEmailTemplateId",
    "setPasswordEmailTemplateId"
     ] as templateName]
      [@properties.row nameKey="emailConfiguration.${templateName}" value=properties.display(application, "emailConfiguration.${templateName}", message.inline("none-selected-use-tenant") false) /]
    [/#list]
  [/@properties.table]

  [#-- JWT Configuration --]
  <h3>[@message.print key="jwt"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="jwtConfiguration.issuer" object=helpers.tenantById(application.tenantId) propertyName="issuer"/]
    [@properties.rowEval nameKey="jwtConfiguration.enabled" object=application.jwtConfiguration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="jwtConfiguration.timeToLiveInSeconds" object=application.jwtConfiguration propertyName="timeToLiveInSeconds"/]
    [#if accessTokenKey?has_content]
      [@properties.row nameKey="jwtConfiguration.accessTokenKeyName" value=properties.display(accessTokenKey, "name") /]
      [@properties.row nameKey="jwtConfiguration.accessTokenKeyId" value=properties.display(accessTokenKey, "id") /]
    [#else]
      [@properties.row nameKey="jwtConfiguration.accessTokenKeyId" value="\x2013"/]
    [/#if]
    [#if idTokenKey?has_content]
      [@properties.row nameKey="jwtConfiguration.idTokenKeyName" value=properties.display(idTokenKey, "name") /]
      [@properties.row nameKey="jwtConfiguration.idTokenKeyId" value=properties.display(idTokenKey, "id") /]
    [#else]
      [@properties.row nameKey="jwtConfiguration.idTokenKeyId" value="\x2013"/]
    [/#if]
    [@properties.rowEval nameKey="jwtConfiguration.refreshTokenTimeToLiveInMinutes" object=application.jwtConfiguration propertyName="refreshTokenTimeToLiveInMinutes"/]
    [@properties.row nameKey="jwtConfiguration.refreshTokenExpirationPolicy" value=application.jwtConfiguration.refreshTokenExpirationPolicy?has_content?then(message.inline('RefreshTokenExpirationPolicy.' + application.jwtConfiguration.refreshTokenExpirationPolicy), '&ndash;'?no_esc) /]
    [@properties.row nameKey="jwtConfiguration.refreshTokenUsagePolicy" value=application.jwtConfiguration.refreshTokenUsagePolicy?has_content?then(message.inline(application.jwtConfiguration.refreshTokenUsagePolicy), '&ndash;'?no_esc) /]
    [#if accessTokenPopulateLambda?has_content]
      [@properties.row nameKey="lambdaConfiguration.accessTokenPopulateName" value=properties.display(accessTokenPopulateLambda, "name") /]
      [@properties.row nameKey="lambdaConfiguration.accessTokenPopulateId" value=properties.display(accessTokenPopulateLambda, "id") /]
    [#else]
      [@properties.row nameKey="lambdaConfiguration.accessTokenPopulateId" value=message.inline("none-selected-lambda-disabled")/]
    [/#if]
    [#if idTokenPopulateLambda?has_content]
      [@properties.row nameKey="lambdaConfiguration.idTokenPopulateName" value=properties.display(idTokenPopulateLambda, "name") /]
      [@properties.row nameKey="lambdaConfiguration.idTokenPopulateId" value=properties.display(idTokenPopulateLambda, "id") /]
    [#else]
      [@properties.row nameKey="lambdaConfiguration.idTokenPopulateId" value=message.inline("none-selected-lambda-disabled")/]
    [/#if]
  [/@properties.table]

  [#-- Multi-Factor Configuration --]
  <h3>[@message.print key="multi-factor-configuration"/]</h3>
  [@properties.table]
  [@properties.row nameKey="multiFactorConfiguration.email.templateId" value=properties.display(application.multiFactorConfiguration.email, "templateId", message.inline("none-selected-use-tenant") false) /]
  [@properties.row nameKey="multiFactorConfiguration.sms.templateId" value=properties.display(application.multiFactorConfiguration.sms, "templateId", message.inline("none-selected-use-tenant") false) /]
  [/@properties.table]

  [#-- Registration Configuration --]
  <h3>[@message.print key="registration-configuration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="registrationConfiguration.enabled" object=application.registrationConfiguration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="registrationConfiguration.confirmPassword" object=application.registrationConfiguration propertyName="confirmPassword" booleanAsCheckmark=false/]
    [@properties.row nameKey="registrationConfiguration.loginIdType" value=message.inline("${application.registrationConfiguration.loginIdType}")/]
    <tr>
      <td class="top" style="padding-left: 0"> 
        [@message.print key="registration-fields"/]
        [@message.print key="propertySeparator"/]
      </td>
      <td style="padding-left: 0">
        <table class="nested">
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th class="text-center">[@message.print key="field-enabled"/]</th>
            <th class="text-center">[@message.print key="field-required"/]</th>
          </tr>
          </thead>
          <tbody>

          [#list ["birthDate", "firstName", "fullName", "lastName", "middleName", "mobilePhone"] as field]
            <tr>
              <td>[@message.print key="registrationConfiguration." + field /]</td>
              <td class="text-center">${properties.display(application.registrationConfiguration, field + ".enabled")}</td>
              <td class="text-center">${properties.display(application.registrationConfiguration, field + ".required")}</td>
            </tr>
          [/#list]
          </tbody>
        </table>
      </td>
    </tr>
  [/@properties.table]

  [#-- Form Configuration --]
  [@properties.table]
    <h3>[@message.print key="form-settings"/]</h3>
    [@properties.rowEval nameKey="formConfiguration.adminRegistrationFormId" object=application.formConfiguration propertyName="adminRegistrationFormId"/]
    [@properties.row nameKey="formConfiguration.userSelfServiceId" value=properties.display(application.formConfiguration, "selfServiceFormId", message.inline("none-selected-self-service-user-empty") false) /]
    [@properties.rowEval nameKey="formConfiguration.selfServiceFormConfiguration.requireCurrentPasswordOnPasswordChange" object=application.formConfiguration.selfServiceFormConfiguration propertyName="requireCurrentPasswordOnPasswordChange" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- SAMLv2 Integration
    Always show this regardless if SAML v2 is enabled as an IdP because this allows us to potentially use this information to set up
     an SP first. Setting the up the SP first is often necessary to get the entity Id, ACS etc from the SP. So this way you don't have to
     enable SAML and set up dummy values first just to get this to show up.
  --]
  <h3>[@message.print key="samlv2.integration-information"/]</h3>
  [@properties.table]
    [@properties.row nameKey="samlv2.entityId" value=(fusionAuthHost + "/samlv2/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.idpLoginURL" value=(fusionAuthHost + "/samlv2/login/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.idpLogoutURL" value=(fusionAuthHost + "/samlv2/logout/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.metadataURL" value=(fusionAuthHost + "/samlv2/metadata/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.nameIdFormat" value="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"/]
    [@properties.row nameKey="samlv2.initiateLoginURL"  value=(fusionAuthHost + "/samlv2/initiate-login/" + application.tenantId + "/" + application.oauthConfiguration.clientId)/]
  [/@properties.table]

  [#-- SAML v2 Configuration --]
  <h3>[@message.print key="saml"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="samlv2.enabled" object=application.samlv2Configuration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="samlv2.issuer" object=application.samlv2Configuration propertyName="issuer"/]
    [@properties.row nameKey="samlv2.audience" value=properties.display(application.samlv2Configuration, "audience", application.samlv2Configuration.issuer)/]
    [@properties.rowEval nameKey="samlv2.authorizedRedirectURLs" object=application.samlv2Configuration propertyName="authorizedRedirectURLs"/]
    [@properties.row nameKey="samlv2.logoutURL" value=properties.display(application.samlv2Configuration, "logoutURL")/]
    [@properties.rowEval nameKey="samlv2.debug" object=application.samlv2Configuration propertyName="debug" booleanAsCheckmark=false/]

    [#-- AuthN Requests --]
    [@properties.rowEval nameKey="samlv2.requireSignedRequests" object=application.samlv2Configuration propertyName="requireSignedRequests" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="samlv2.loginHintConfiguration.enabled" object=application.samlv2Configuration.loginHintConfiguration propertyName="enabled"/]
    [@properties.rowEval nameKey="samlv2.loginHintConfiguration.parameterName" object=application.samlv2Configuration.loginHintConfiguration propertyName="parameterName"/]
    [#if samlv2AuthNVerificationKey?has_content]
    [@properties.rowNestedValue nameKey="samlv2.defaultVerificationKeyId"]
       ${properties.display(samlv2AuthNVerificationKey, "name")} <br> ${properties.display(samlv2AuthNVerificationKey, "id")}
    [/@properties.rowNestedValue]
    [/#if]

    [#if samlv2AuthNSigningKey?has_content]
      [@properties.rowNestedValue nameKey="samlv2.keyId"]
         ${properties.display(samlv2AuthNSigningKey, "name")} <br> ${properties.display(samlv2AuthNSigningKey, "id")}
      [/@properties.rowNestedValue]
      [@properties.row nameKey="samlv2.xmlSignatureC14nMethod" value=message.inline(application.samlv2Configuration.xmlSignatureC14nMethod)/]
      [@properties.row nameKey="samlv2.xmlSignatureLocation" value=message.inline(application.samlv2Configuration.xmlSignatureLocation)/]
    [#else]
      [@properties.row nameKey="samlv2.keyId" value="\x2013"/]
    [/#if]
    [#if samlv2PopulateLambda?has_content]
      [@properties.row nameKey="lambdaConfiguration.samlv2PopulateName" value=properties.display(samlv2PopulateLambda, "name") /]
      [@properties.row nameKey="lambdaConfiguration.samlv2PopulateId" value=properties.display(samlv2PopulateLambda, "id") /]
    [#else]
      [@properties.row nameKey="lambdaConfiguration.samlv2PopulateId" value=message.inline("none-selected-lambda-disabled")/]
    [/#if]

    [#-- Initiated Login --]
    [@properties.rowEval nameKey="samlv2.initiatedLogin.enabled" object=application propertyName="samlv2Configuration.initiatedLogin.enabled" booleanAsCheckmark=false/]
    [@properties.row nameKey="samlv2.initiatedLogin.nameIdFormat" value=properties.display(application, "samlv2Configuration.initiatedLogin.nameIdFormat") /]

    [#-- Logout Requests --]
    [@properties.rowEval nameKey="samlv2.logout.requireSignedRequests" object=application.samlv2Configuration propertyName="logout.requireSignedRequests" booleanAsCheckmark=false/]
    [#if samlv2LogoutVerificationKey?has_content]
    [@properties.rowNestedValue nameKey="samlv2.logout.defaultVerificationKeyId"]
       ${properties.display(samlv2LogoutVerificationKey, "name")} <br> ${properties.display(samlv2LogoutVerificationKey, "id")}
    [/@properties.rowNestedValue]
    [/#if]

    [@properties.row nameKey="samlv2.logout.behavior" value=application.samlv2Configuration.logout.behavior?has_content?then(message.inline(application.samlv2Configuration.logout.behavior), '&ndash;'?no_esc)/]
    [@properties.rowEval nameKey="samlv2.logout.singleLogout.enabled" object=application.samlv2Configuration propertyName="logout.singleLogout.enabled" booleanAsCheckmark=false/]
    [@properties.row nameKey="samlv2.logout.singleLogout.url" value=properties.display(application.samlv2Configuration, "logout.singleLogout.url")/]

    [#if samlv2LogoutRequestSigningKey?has_content]
      [@properties.rowNestedValue nameKey="samlv2.logout.singleLogout.keyId"]
         ${properties.display(samlv2LogoutRequestSigningKey, "name")} <br> ${properties.display(samlv2LogoutRequestSigningKey, "id")}
      [/@properties.rowNestedValue]
      [@properties.row nameKey="samlv2.logout.singleLogout.xmlSignatureC14nMethod" value=message.inline(application.samlv2Configuration.xmlSignatureC14nMethod)/]
    [#else]
      [@properties.row nameKey="samlv2.logout.singleLogout.keyId" value="\x2013"/]
    [/#if]

    [#-- Logout Response --]
    [#if samlv2LogoutResponseSigningKey?has_content]
      [@properties.rowNestedValue nameKey="samlv2.logout.keyId"]
         ${properties.display(samlv2LogoutResponseSigningKey, "name")} <br> ${properties.display(samlv2LogoutResponseSigningKey, "id")}
      [/@properties.rowNestedValue]
      [@properties.row nameKey="samlv2.logout.xmlSignatureC14nMethod" value=message.inline(application.samlv2Configuration.xmlSignatureC14nMethod)/]
    [#else]
      [@properties.row nameKey="samlv2.logout.keyId" value="\x2013"/]
    [/#if]

    [#-- SAML Encryption --]
    [@properties.rowEval nameKey="samlv2.assertionEncryptionConfiguration.enabled" object=application.samlv2Configuration.assertionEncryptionConfiguration propertyName="enabled" booleanAsCheckmark=false/]
    [#if application.samlv2Configuration.assertionEncryptionConfiguration.enabled]
      [@properties.row nameKey="samlv2.assertionEncryptionConfiguration.encryptionAlgorithm" value=message.inline("EncryptionAlgorithm." + application.samlv2Configuration.assertionEncryptionConfiguration.encryptionAlgorithm)/]
      [@properties.row nameKey="samlv2.assertionEncryptionConfiguration.keyLocation" value=message.inline("KeyLocation." + application.samlv2Configuration.assertionEncryptionConfiguration.keyLocation)/]
      [@properties.row nameKey="samlv2.assertionEncryptionConfiguration.keyTransportAlgorithm" value=message.inline("KeyTransportAlgorithm." + application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportAlgorithm)/]
      [@properties.row nameKey="samlv2.assertionEncryptionConfiguration.digestAlgorithm" value=message.inline("DigestAlgorithm." + application.samlv2Configuration.assertionEncryptionConfiguration.digestAlgorithm)/]
      [#if application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportAlgorithm == "RSA_OAEP"]
        [@properties.row nameKey="samlv2.assertionEncryptionConfiguration.maskGenerationFunction" value=message.inline("MaskGenerationFunction." + application.samlv2Configuration.assertionEncryptionConfiguration.maskGenerationFunction)/]
      [/#if]
      [@properties.rowNestedValue nameKey="samlv2.assertionEncryptionConfiguration.keyTransportEncryptionKeyId"]
        ${properties.display(samlv2AssertionEncryptionTransportKey, "name")} <br> ${properties.display(samlv2AssertionEncryptionTransportKey, "id")}
      [/@properties.rowNestedValue]
    [/#if]
  [/@properties.table]

  [#-- Security Configuration --]
  <h3>[@message.print key="login-configuration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="loginConfiguration.requireAuthentication" object=application propertyName="loginConfiguration.requireAuthentication" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="loginConfiguration.generateRefreshTokens" object=application propertyName="loginConfiguration.generateRefreshTokens" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="loginConfiguration.allowTokenRefresh" object=application propertyName="loginConfiguration.allowTokenRefresh" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- ACL Configuration --]
    <h3>[@message.print key="aclConfiguration"/]</h3>
    [@properties.table]
      [@properties.row nameKey="accessControlConfiguration.uiIPAccessControlListId" value=properties.display(application.accessControlConfiguration, "uiIPAccessControlListId", message.inline("no-acl-selected-use-tenant")) /]
    [/@properties.table]

  [#-- Passwordless Configuration --]
  <h3>[@message.print key="passwordlessConfiguration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="passwordlessConfiguration.enabled" object=application propertyName="passwordlessConfiguration.enabled" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- Authentication Tokens --]
  <h3>[@message.print key="authenticationTokenConfiguration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="authenticationTokenConfiguration.enabled" object=application propertyName="authenticationTokenConfiguration.enabled" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- Roles --]
  <h3>[@message.print key="roles"/]</h3>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="name"/]</th>
      <th>[@message.print key="id"/]</th>
      <th class="text-center">[@message.print key="default"/]</th>
      <th class="text-center">[@message.print key="superRole"/]</th>
      <th>[@message.print key="description"/]</th>
    </tr>
    </thead>
    <tbody>
      [#if (application.roles)?has_content]
        [#list application.roles as role]
        <tr>
          <td>${properties.display(role, 'name')}</td>
          <td>${properties.display(role, 'id')}</td>
          <td class="text-center">${properties.display(role, 'isDefault')}</td>
          <td class="text-center">${properties.display(role, 'isSuperRole')}</td>
          <td>${properties.display(role, 'description')}</td>
        </tr>
        [/#list]
      [#else]
      <tr>
        <td colspan="3">[@message.print key="no-roles"/]</td>
      </tr>
      [/#if]
    </tbody>
  </table>

  [#if (application.data)?? && application.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(application.data)}</pre>
  [/#if]
[/@dialog.view]
