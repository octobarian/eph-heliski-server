[#ftl/]
[#-- @ftlvariable name="connectorNames" type="java.util.Map<java.lang.String, java.lang.String>" --]
[#-- @ftlvariable name="encryptionSchemeDisplayName" type="java.lang.String" --]
[#-- @ftlvariable name="eventTypes" type="java.util.List<io.fusionauth.domain.event.EventType>" --]
[#-- @ftlvariable name="fusionAuthHost" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]


[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
[#-- TODO : Missing :
 - Display User Action name & Id
 - Display Email template names & Id
 - Display Key names & Id
 - Display Form name & Id
--]

  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=tenant propertyName="name"/]
    [@properties.rowEval nameKey="id" object=tenant propertyName="id"/]
    [@properties.rowEval nameKey="issuer" object=tenant propertyName="issuer"/]
    [@properties.rowEval nameKey="insertInstant" object=tenant propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=tenant propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#-- Login Theme --]
  <h3>[@message.print key="theme-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="themeId" value=properties.display(tenant, "themeId") /]
    [@properties.row nameKey="theme.name" value=properties.display(theme, "name") /]
  [/@properties.table]

  [#--  Forms Settings --]
  <h3>[@message.print key="form-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="adminUserFormId" value=properties.display(tenant, "formConfiguration.adminUserFormId") /]
  [/@properties.table]

  [#--  Username Settings --]
  <h3>[@message.print key="usernames"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="usernameConfiguration.unique.enabled" object=tenant propertyName="usernameConfiguration.unique.enabled" booleanAsCheckmark=false/]
      [#if tenant.usernameConfiguration.unique.enabled]
        [@properties.rowEval nameKey="usernameConfiguration.unique.strategy" object=tenant propertyName="usernameConfiguration.unique.strategy"/]
        [@properties.rowEval nameKey="usernameConfiguration.unique.numberOfDigits" object=tenant propertyName="usernameConfiguration.unique.numberOfDigits" /]
        [@properties.rowEval nameKey="usernameConfiguration.unique.separator" object=tenant propertyName="usernameConfiguration.unique.separator" /]
      [/#if]
  [/@properties.table]

[#--Connector tab--]
  [#-- Connector Policies --]
  <h3>[@message.print key="connector-policies"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print "connector"/]</th>
        <th>[@message.print "connectorPolicies.domains"/]</th>
        <th>[@message.print "connectorPolicies.migrate"/]</th>
      </tr>
    </thead>
    <tbody>
      [#list tenant.connectorPolicies as connectorPolicy]
        <tr>
          <td>${connectorNames[connectorPolicy.connectorId]!''}</td>
          <td>${properties.display(connectorPolicy, "domains")}</td>
          <td>${properties.display(connectorPolicy, "migrate")}</td>
        </tr>
      [/#list]
    </tbody>
  </table>

[#--Email Template Settings--]
  [#-- SMTP settings--]
  <h3>[@message.print key="smtp-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="emailConfiguration.host" value=properties.display(tenant, "emailConfiguration.host") /]
    [@properties.row nameKey="emailConfiguration.port" value=properties.display(tenant, "emailConfiguration.port") /]
    [@properties.row nameKey="emailConfiguration.username" value=properties.display(tenant, "emailConfiguration.username") /]
    [@properties.row nameKey="emailConfiguration.password" value=message.inline("smtp-password") /]
    [@properties.row nameKey="emailConfiguration.security" value=properties.display(tenant, "emailConfiguration.security") /]
    [@properties.row nameKey="emailConfiguration.defaultFromEmail" value=properties.display(tenant, "emailConfiguration.defaultFromEmail") /]
    [@properties.row nameKey="emailConfiguration.defaultFromName" value=properties.display(tenant, "emailConfiguration.defaultFromName") /]
    [@properties.rowNestedValue nameKey="emailConfiguration.additionalHeaders"]
      [#list tenant.emailConfiguration.additionalHeaders as header][#t]
        ${properties.display(header, "name")}=${properties.display(header, "value")}[#if !header?is_last]<br>[/#if][#else]${"\x2013"}[#t]
      [/#list]
    [/@properties.rowNestedValue]
  [/@properties.table]

  [#-- Email Verification settings --]
  <h3>[@message.print key="email-verification-settings"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="emailConfiguration.verifyEmail" object=tenant propertyName="emailConfiguration.verifyEmail" booleanAsCheckmark=false/]
    [#if tenant.emailConfiguration.verifyEmail]
      [@properties.rowEval nameKey="emailConfiguration.implicitEmailVerificationAllowed" object=tenant propertyName="emailConfiguration.implicitEmailVerificationAllowed" booleanAsCheckmark=false/]
      [@properties.rowEval nameKey="emailConfiguration.verifyEmailWhenChanged" object=tenant propertyName="emailConfiguration.verifyEmailWhenChanged" booleanAsCheckmark=false/]
      [@properties.row nameKey="emailConfiguration.verificationEmailTemplateId" value=properties.display(tenant, "emailConfiguration.verificationEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
      [@properties.row nameKey="emailConfiguration.verificationCompleteTemplateId" value=properties.display(tenant, "emailConfiguration.emailVerifiedEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
      [@properties.rowEval nameKey="emailConfiguration.verificationStrategy" object=tenant propertyName="emailConfiguration.verificationStrategy"/]
      [@properties.rowEval nameKey="emailConfiguration.unverified.behavior" object=tenant propertyName="emailConfiguration.unverified.behavior"/]
      [@properties.rowEval nameKey="emailConfiguration.unverified.allowEmailChangeWhenGated" object=tenant propertyName="emailConfiguration.unverified.allowEmailChangeWhenGated" booleanAsCheckmark=false/]
      [@properties.rowEval nameKey="userDeletePolicy.unverified.enabled" object=tenant propertyName="userDeletePolicy.unverified.enabled" booleanAsCheckmark=false/]
      [@properties.rowEval nameKey="userDeletePolicy.unverified.numberOfDaysToRetain" object=tenant propertyName="userDeletePolicy.unverified.numberOfDaysToRetain" booleanAsCheckmark=false/]
    [/#if]

    [@properties.rowNestedValue nameKey="emailConfiguration.properties"]
      [#if tenant.emailConfiguration.properties?has_content]
        <pre class="code not-pushed">${tenant.emailConfiguration.properties}</pre>
      [#else]
        &ndash;
      [/#if]
    [/@properties.rowNestedValue]
  [/@properties.table]

  <h3>[@message.print key="email-template-settings"/]</h3>
  [@properties.table]
    [#assign disablesFeature = ["forgotPasswordEmailTemplateId", "setPasswordEmailTemplateId"]/]
    [#assign templateNames = fusionAuth.statics['io.fusionauth.domain.EmailConfiguration'].EmailTemplateIdFieldNames/]
    [#list templateNames as templateName]
      [#-- The emailVerifiedEmailTemplateId & verificationEmailTemplateId are rendered in the previous section as part of email verification. --]
      [#if templateName != "verificationEmailTemplateId" && templateName != "emailVerifiedEmailTemplateId"]
        [#assign noneSelected = disablesFeature?seq_contains(templateName)?then(message.inline("none-selected-email-template-disabled"), "\x2013") /]
        [@properties.row nameKey="emailConfiguration.${templateName}" value=properties.display(tenant, "emailConfiguration.${templateName}", noneSelected false) /]
      [/#if]
    [/#list]
  [/@properties.table]

  [#-- Family configuration--]
  [#if tenant.familyConfiguration.enabled]
    <h3>[@message.print key="families"/]</h3>
    [@properties.table]
      [@properties.row nameKey="familyConfiguration.maximumChildAge" value=properties.display(tenant, "familyConfiguration.maximumChildAge") /]
      [@properties.row nameKey="familyConfiguration.minimumOwnerAge" value=properties.display(tenant, "familyConfiguration.minimumOwnerAge") /]
      [@properties.rowEval nameKey="familyConfiguration.parentEmailRequired" object=tenant propertyName="familyConfiguration.parentEmailRequired" booleanAsCheckmark=false /]
      [@properties.row nameKey="familyConfiguration.familyRequestEmailTemplateId" value=properties.display(tenant, "familyConfiguration.familyRequestEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
      [@properties.row nameKey="familyConfiguration.confirmChildEmailTemplateId" value=properties.display(tenant, "familyConfiguration.confirmChildEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
      [@properties.row nameKey="familyConfiguration.parentRegistrationEmailTemplateId" value=properties.display(tenant, "familyConfiguration.parentRegistrationEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
    [/@properties.table]
  [/#if]

  [#-- Multi-Factor settings --]
  <h3>[@message.print key="multi-factor-settings"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="multiFactorConfiguration.authenticator.enabled" object=tenant propertyName="multiFactorConfiguration.authenticator.enabled"/]
    [@properties.rowEval nameKey="multiFactorConfiguration.email.enabled" object=tenant propertyName="multiFactorConfiguration.email.enabled"/]
    [@properties.rowEval nameKey="multiFactorConfiguration.email.templateId" object=tenant propertyName="multiFactorConfiguration.email.templateId"/]
    [@properties.rowEval nameKey="multiFactorConfiguration.sms.enabled" object=tenant propertyName="multiFactorConfiguration.sms.enabled"/]
    [@properties.rowEval nameKey="multiFactorConfiguration.sms.messengerId" object=tenant propertyName="multiFactorConfiguration.sms.messengerId"/]
    [@properties.rowEval nameKey="multiFactorConfiguration.sms.templateId" object=tenant propertyName="multiFactorConfiguration.sms.templateId"/]
  [/@properties.table]

  [#--  OAuth Settings --]
  <h3>[@message.print key="oauth-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="httpSessionMaxInactiveInterval" value=properties.display(tenant, "httpSessionMaxInactiveInterval") /]
    [@properties.row nameKey="logoutURL" value=properties.display(tenant, "logoutURL") /]
    [@properties.row nameKey="clientCredentialsAccessTokenPopulateLambdaId" value=properties.display(tenant, "oauthConfiguration.clientCredentialsAccessTokenPopulateLambdaId", message.inline("none-selected-lambda-disabled") false) /]
  [/@properties.table]

  [#-- JWT --]
  <h3>[@message.print key="jwt-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="jwtConfiguration.timeToLiveInSeconds" value="${properties.display(tenant, 'jwtConfiguration.timeToLiveInSeconds')} ${message.inline('SECONDS')?markup_string?lower_case}"/]
    [@properties.row nameKey="jwtConfiguration.accessTokenKeyId" value=properties.display(tenant, "jwtConfiguration.accessTokenKeyId") /]
    [@properties.row nameKey="jwtConfiguration.idTokenKeyId" value=properties.display(tenant, "jwtConfiguration.idTokenKeyId") /]
    [@properties.row nameKey="jwtConfiguration.refreshTokenTimeToLiveInMinutes" value="${properties.display(tenant, 'jwtConfiguration.refreshTokenTimeToLiveInMinutes')} ${message.inline('MINUTES')?markup_string?lower_case}" /]
    [@properties.row nameKey="jwtConfiguration.refreshTokenExpirationPolicy" value=message.inline('RefreshTokenExpirationPolicy.' +  tenant.jwtConfiguration.refreshTokenExpirationPolicy) /]
    [@properties.rowNestedValue nameKey="jwtConfiguration.refreshTokenRevocationPolicy" ]
       <table class="mb-0">
         <tbody>
          <tr style="border-top: none;">
            <td class="p-1">${properties.display(tenant, "jwtConfiguration.refreshTokenRevocationPolicy.onLoginPrevented")}</td>
            <td class="p-1">${message.inline("jwtConfiguration.refreshTokenRevocationPolicy.onLoginPrevented")}</td>
          </tr>
         <tr style="border-top: none;">
            <td class="p-1">${properties.display(tenant, "jwtConfiguration.refreshTokenRevocationPolicy.onMultiFactorEnable")}</td>
            <td class="p-1">${message.inline("jwtConfiguration.refreshTokenRevocationPolicy.onMultiFactorEnable")}</td>
          </tr>
          <tr style="border-top: none;">
            <td class="p-1">${properties.display(tenant, "jwtConfiguration.refreshTokenRevocationPolicy.onPasswordChanged")}</td>
            <td class="p-1">${message.inline("jwtConfiguration.refreshTokenRevocationPolicy.onPasswordChanged")}</td>
          </tr>
        </tbody>
      </table>
    [/@properties.rowNestedValue]
    [@properties.row nameKey="jwtConfiguration.refreshTokenUsagePolicy" value=message.inline(tenant.jwtConfiguration.refreshTokenUsagePolicy) /]

  [/@properties.table]

  [#-- Failed Authentication --]
  [#if tenant.failedAuthenticationConfiguration.userActionId??]
    <h3>[@message.print key="failed-login-settings"/]</h3>
    [@properties.table]
      [@properties.row nameKey="failedAuthenticationConfiguration.userActionId" value=properties.display(tenant, "failedAuthenticationConfiguration.userActionId") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.tooManyAttempts" value=properties.display(tenant, "failedAuthenticationConfiguration.tooManyAttempts") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.resetCountInSeconds" value=properties.display(tenant, "failedAuthenticationConfiguration.resetCountInSeconds") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.actionDuration" value=properties.display(tenant, "failedAuthenticationConfiguration.actionDuration") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.actionDurationUnit" value=properties.display(tenant, "failedAuthenticationConfiguration.actionDurationUnit") /]
    [/@properties.table]
  [/#if]

  [#-- Breached password detection settings --]
  <h3>[@message.print key="breached-password-detection-settings"/]</h3>
  [@properties.table]
 [@properties.rowEval nameKey="passwordValidationRules.breachDetection.enabled" object=tenant propertyName="passwordValidationRules.breachDetection.enabled"/]
    [@properties.row nameKey="passwordValidationRules.breachDetection.matchMode" value=properties.display(tenant, "passwordValidationRules.breachDetection.matchMode") /]
    [@properties.row nameKey="passwordValidationRules.breachDetection.onLogin" value=properties.display(tenant, "passwordValidationRules.breachDetection.onLogin") /]
    [@properties.row nameKey="passwordValidationRules.breachDetection.notifyUserEmailTemplateId" value=properties.display(tenant, "passwordValidationRules.breachDetection.notifyUserEmailTemplateId") /]
  [/@properties.table]

  [#-- Password --]
  <h3>[@message.print key="password-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="passwordValidationRules.minLength" value=properties.display(tenant, "passwordValidationRules.minLength") /]
    [@properties.row nameKey="passwordValidationRules.maxLength" value=properties.display(tenant, "passwordValidationRules.maxLength") /]
    [@properties.rowEval nameKey="passwordValidationRules.requireMixedCase" object=tenant propertyName="passwordValidationRules.requireMixedCase" booleanAsCheckmark=false /]
    [@properties.rowEval nameKey="passwordValidationRules.requireNonAlpha" object=tenant propertyName="passwordValidationRules.requireNonAlpha" booleanAsCheckmark=false /]
    [@properties.rowEval nameKey="passwordValidationRules.requireNumber" object=tenant propertyName="passwordValidationRules.requireNumber" booleanAsCheckmark=false /]
    [#if tenant.minimumPasswordAge.enabled]
      [@properties.row nameKey="minimumPasswordAge.seconds" value="${properties.display(tenant, 'minimumPasswordAge.seconds')} ${message.inline('SECONDS')?markup_string?lower_case}" /]
    [#else]
      [@properties.rowEval nameKey="minimumPasswordAge.seconds" object=tenant propertyName="minimumPasswordAge.enabled" booleanAsCheckmark=false /]
    [/#if]
    [#if tenant.maximumPasswordAge.enabled]
      [@properties.row nameKey="maximumPasswordAge.days" value="${properties.display(tenant, 'maximumPasswordAge.days')} ${message.inline('DAYS')?markup_string?lower_case}" /]
    [#else]
      [@properties.rowEval nameKey="maximumPasswordAge.days" object=tenant propertyName="maximumPasswordAge.enabled" booleanAsCheckmark=false /]
    [/#if]
    [#if tenant.passwordValidationRules.rememberPreviousPasswords.enabled]
      [@properties.row nameKey="passwordValidationRules.rememberPreviousPasswords.count" value=properties.display(tenant, "passwordValidationRules.rememberPreviousPasswords.count") /]
    [#else]
      [@properties.rowEval nameKey="passwordValidationRules.rememberPreviousPasswords.count" object=tenant propertyName="passwordValidationRules.rememberPreviousPasswords.enabled" booleanAsCheckmark=false /]
    [/#if]
    [@properties.rowEval nameKey="passwordValidationRules.validateOnLogin" object=tenant propertyName="passwordValidationRules.validateOnLogin" booleanAsCheckmark=false /]
  [/@properties.table]

  [#-- Password Encryption --]
  <h3>[@message.print key="password-encryption-settings"/]</h3>
  [@properties.table]
    [@properties.rowNestedValue nameKey="passwordEncryptionConfiguration.encryptionScheme" ]
      ${encryptionSchemeDisplayName} (${tenant.passwordEncryptionConfiguration.encryptionScheme})
    [/@properties.rowNestedValue]
    [@properties.row nameKey="passwordEncryptionConfiguration.encryptionSchemeFactor" value=properties.display(tenant, "passwordEncryptionConfiguration.encryptionSchemeFactor") /]
    [@properties.row nameKey="passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin" value=properties.display(tenant, "passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin", "\x2013", false) /]
  [/@properties.table]

  [#-- Login API Settings  --]
  <h3>[@message.print key="login-configuration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="loginConfiguration.requireAuthentication" object=tenant propertyName="loginConfiguration.requireAuthentication" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- Access control lists Settings --]
  <h3>[@message.print key="acl-settings"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="accessControlConfiguration.uiIPAccessControlListId" object=tenant propertyName="accessControlConfiguration.uiIPAccessControlListId"/]
  [/@properties.table]

  [#-- Captcha settings --]
  <h3>[@message.print key="captcha-settings"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="captchaConfiguration.enabled" object=tenant propertyName="captchaConfiguration.enabled"/]
    [@properties.rowEval nameKey="captchaConfiguration.captchaMethod" object=tenant propertyName="captchaConfiguration.captchaMethod"/]
    [@properties.rowEval nameKey="captchaConfiguration.secretKey" object=tenant propertyName="captchaConfiguration.secretKey"/]
    [@properties.rowEval nameKey="captchaConfiguration.siteKey" object=tenant propertyName="captchaConfiguration.siteKey"/]
    [@properties.rowEval nameKey="captchaConfiguration.threshold" object=tenant propertyName="captchaConfiguration.threshold"/]
  [/@properties.table]

  [#-- Blocked domain settings --]
  <h3>[@message.print key="blocked-domain-settings"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="blocked-domains" object=tenant propertyName="registrationConfiguration.blockedDomains"/]
  [/@properties.table]

  [#-- Rate limiting settings --]
  <h3>[@message.print key="rate-limiting-settings"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print "rateLimiting.action"/]</th>
        <th>[@message.print "rateLimiting.enabled"/]</th>
        <th>[@message.print "rateLimiting.limit"/]</th>
        <th>[@message.print "rateLimiting.timePeriodInSeconds"/]</th>
      </tr>
    </thead>
    <tbody>
      [#list ["failedLogin",
              "forgotPassword",
              "sendEmailVerification",
              "sendPasswordless",
              "sendRegistrationVerification",
              "sendTwoFactor"] as action]
        <tr>
          <td>[@message.print "rateLimitConfiguration.${action}"/]</td>
          <td>${properties.display(tenant, "rateLimitConfiguration.${action}.enabled")}</td>
          <td>${properties.display(tenant, "rateLimitConfiguration.${action}.limit")}</td>
          <td>${properties.display(tenant, "rateLimitConfiguration.${action}.timePeriodInSeconds")} ${message.inline("SECONDS")?markup_string?lower_case}
            [#assign ttl = "tenant.rateLimitConfiguration.${action}.timePeriodInSeconds"?eval/]
            [#if ttl > 120] (${helpers.approximateFromSeconds(ttl)}) [/#if]
          </td>
        </tr>
      [/#list]
    </tbody>
  </table>

  [#--  SCIM Server --]
  <h3>[@message.print key="scim-server-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="scimServerConfiguration.enabled" value=properties.display(tenant, "scimServerConfiguration.enabled") /]
    [@properties.row nameKey="scimServer.url" value="${fusionAuthHost}/api/scim/resource/v2"/]
    [@properties.row nameKey="scimServer.resourceTypes.endpoint" value="${fusionAuthHost}/api/scim/resource/v2/ResourceTypes"/]
    [@properties.row nameKey="scimServer.schemas.endpoint" value="${fusionAuthHost}/api/scim/resource/v2/Schemas"/]
    [@properties.row nameKey="scimServer.serviceProviderConfig.endpoint" value="${fusionAuthHost}/api/scim/resource/v2/ServiceProviderConfig"/]
    [@properties.row nameKey="scimServerConfiguration.clientEntityTypeId" value=properties.display(tenant, "scimServerConfiguration.clientEntityTypeId") /]
    [@properties.row nameKey="scimServerConfiguration.serverEntityTypeId" value=properties.display(tenant, "scimServerConfiguration.serverEntityTypeId") /]
    [@properties.row nameKey="lambdaConfiguration.scimEnterpriseUserRequestConverterId" value=properties.display(tenant, "lambdaConfiguration.scimEnterpriseUserRequestConverterId") /]
    [@properties.row nameKey="lambdaConfiguration.scimEnterpriseUserResponseConverterId" value=properties.display(tenant, "lambdaConfiguration.scimEnterpriseUserResponseConverterId") /]
    [@properties.row nameKey="lambdaConfiguration.scimGroupRequestConverterId" value=properties.display(tenant, "lambdaConfiguration.scimGroupRequestConverterId") /]
    [@properties.row nameKey="lambdaConfiguration.scimGroupResponseConverterId" value=properties.display(tenant, "lambdaConfiguration.scimGroupResponseConverterId") /]
    [@properties.row nameKey="lambdaConfiguration.scimUserRequestConverterId" value=properties.display(tenant, "lambdaConfiguration.scimUserRequestConverterId") /]
    [@properties.row nameKey="lambdaConfiguration.scimUserResponseConverterId" value=properties.display(tenant, "lambdaConfiguration.scimUserResponseConverterId") /]
    [@properties.rowNestedValue nameKey="scimServerConfiguration.schemas" ]
      [#if tenant.scimServerConfiguration.schemas?has_content]
        <pre style="white-space: pre-wrap; word-break: break-word;" class="code not-pushed">${fusionAuth.stringify(tenant.scimServerConfiguration.schemas)}</pre>
      [#else]
        ${"\x2013"}
      [/#if]
    [/@properties.rowNestedValue]
  [/@properties.table]


  [#-- Events --]
  <h3>[@message.print key="event-settings"/]</h3>
  <table id="event-settings">
    <thead>
    <tr>
      <th>[@message.print key="event"/]</th>
      <th>[@message.print key="enabled"/]</th>
      <th>[@message.print key="transaction"/]</th>
    </tr>
    </thead>
    <tbody>
      [#list eventTypes as eventType]
      [#if eventType.instanceEvent]
        [#continue /]
      [/#if]
      <tr id="${eventType.eventName()?replace(".", "_")?replace("-", "_")}">
        <td>${eventType.eventName()}</td>
        [#-- When we add events and the object has not been saved from the UI the event config may be missing some events. --]
        [#if tenant.eventConfiguration.events(eventType)?? ]
          <td>${properties.display(tenant.eventConfiguration.events(eventType), "enabled")}</td>
          [#if eventType.eventName() == "user.action" ]
            <td>[@message.print "tx-managed-by-user.action"/]</td>
          [#elseif eventType.transactionalEvent ]
            <td>${properties.display(tenant.eventConfiguration.events(eventType), "transactionType")}</td>
          [#else]
            <td>[@message.print "non-txn-event"/]</td>
          [/#if]
        [#else]
          <td></td>
          <td>[@message.print key=(eventType.transactionalEvent?then("None", "non-txn-event"))/]</td>
        [/#if]
      </tr>
      [/#list]
    </tbody>
  </table>

  [#-- WebAuthn --]
  <h3>[@message.print key="webauthn"/]</h3>
  [@properties.table]
    [@properties.row nameKey="enabled" value=properties.display(tenant, "webAuthnConfiguration.enabled") /]
    [@properties.row nameKey="debug" value=properties.display(tenant, "webAuthnConfiguration.debug") /]
    [@properties.row nameKey="webAuthnConfiguration.relyingPartyId" value=properties.display(tenant, "webAuthnConfiguration.relyingPartyId") /]
    [@properties.row nameKey="webAuthnConfiguration.relyingPartyName" value=properties.display(tenant, "webAuthnConfiguration.relyingPartyName") /]
    [@properties.rowNestedValue nameKey="webAuthnConfiguration.bootstrapWorkflow"]
       <table class="mb-0">
         <tbody>
          <tr style="border-top: none;">
            <td class="pt-0" style="vertical-align: top">[@message.print key="enabled"/]</td>
            <td class="pt-0" style="vertical-align: top">${properties.display(tenant, "webAuthnConfiguration.bootstrapWorkflow.enabled")}</td>
          </tr>
          <tr style="border-top: none;">
            <td class="pt-0" style="vertical-align: top">[@message.print key="webAuthnConfiguration.bootstrapWorkflow.authenticatorAttachmentPreference"/]</td>
            <td class="pt-0" style="vertical-align: top">[@message.print key="AuthenticatorAttachmentPreference.${tenant.webAuthnConfiguration.bootstrapWorkflow.authenticatorAttachmentPreference}"/]</td>
          </tr>
          <tr style="border-top: none;">
            <td class="pt-0" style="vertical-align: top">[@message.print key="webAuthnConfiguration.bootstrapWorkflow.userVerificationRequirement"/]</td>
            <td class="pt-0" style="vertical-align: top">[@message.print key="UserVerificationRequirement.${tenant.webAuthnConfiguration.bootstrapWorkflow.userVerificationRequirement}"/]</td>
          </tr>
        </tbody>
      </table>
    [/@properties.rowNestedValue]
    [@properties.rowNestedValue nameKey="webAuthnConfiguration.reauthenticationWorkflow"]
      <table class="mb-0">
        <tbody>
          <tr style="border-top: none;">
            <td class="pt-0" style="vertical-align: top">[@message.print key="enabled"/]</td>
            <td class="pt-0" style="vertical-align: top">${properties.display(tenant, "webAuthnConfiguration.reauthenticationWorkflow.enabled")}</td>
          </tr>
          <tr style="border-top: none;">
            <td class="pt-0" style="vertical-align: top">[@message.print key="webAuthnConfiguration.reauthenticationWorkflow.authenticatorAttachmentPreference"/]</td>
            <td class="pt-0" style="vertical-align: top">[@message.print key="AuthenticatorAttachmentPreference.${tenant.webAuthnConfiguration.reauthenticationWorkflow.authenticatorAttachmentPreference}"/]</td>
          </tr>
          <tr style="border-top: none;">
            <td class="pt-0" style="vertical-align: top">[@message.print key="webAuthnConfiguration.reauthenticationWorkflow.userVerificationRequirement"/]</td>
            <td class="pt-0" style="vertical-align: top">[@message.print key="UserVerificationRequirement.${tenant.webAuthnConfiguration.reauthenticationWorkflow.userVerificationRequirement}"/]</td>
          </tr>
        </tbody>
      </table>
    [/@properties.rowNestedValue]
  [/@properties.table]

  [#-- External Identifier --]
  <h3>[@message.print key="external-identifiers"/]</h3>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="identifier"/]</th>
      <th>[@message.print key="generation-type"/]</th>
      <th>[@message.print key="ttl"/]</th>
    </tr>
    </thead>
    <tbody>
    [#list [
      "authorizationGrantId",
      "changePasswordId",
      "deviceCode",
      "emailVerificationId",
      "externalAuthenticationId",
      "oneTimePassword",
      "passwordlessLogin",
      "pendingAccountLink",
      "registrationVerificationId",
      "samlv2AuthNRequestId",
      "setupPasswordId",
      "trustToken",
      "twoFactorId",
      "twoFactorOneTimeCodeId",
      "twoFactorTrustId",
      "webAuthnAuthenticationChallenge",
      "webAuthnRegistrationChallenge"
      ] as id]
      <tr>
        <td [#if id =="deviceCode" || id == "emailVerificationId" || id == "registrationVerificationId"]class="top" rowspan="2"[/#if]>[@message.print key="externalIdentifierConfiguration.${id}"/]</td>
        <td>
        [#if ("(tenant.externalIdentifierConfiguration.${id}Generator.type)!''"?eval)?has_content]
          ${properties.display(tenant "externalIdentifierConfiguration.${id}Generator.length")}&nbsp;${message.inline("tenant.externalIdentifierConfiguration.${id}Generator.type"?eval)}
        [#elseif id == "deviceCode"]
           ${properties.display(tenant "externalIdentifierConfiguration.deviceUserCodeIdGenerator.length")}&nbsp;${message.inline(tenant.externalIdentifierConfiguration.deviceUserCodeIdGenerator.type)}  [@message.print key="userCode"/]
        [#else]
          32 [@message.print key="randomBytes"/]
        [/#if]
        </td>
        <td>
           ${properties.display(tenant, "externalIdentifierConfiguration.${id}TimeToLiveInSeconds")} ${message.inline("SECONDS")?markup_string?lower_case}
            [#assign ttl = "tenant.externalIdentifierConfiguration.${id}TimeToLiveInSeconds"?eval/]
            [#if ttl > 120] (${helpers.approximateFromSeconds(ttl)}) [/#if]
        </td>
      </tr>

      [#if id == "deviceCode"]
      <tr>
        <td>32 [@message.print key="randomBytes"/] [@message.print key="deviceCode"/]</td>
        <td>
         ${properties.display(tenant, "externalIdentifierConfiguration.${id}TimeToLiveInSeconds")} ${message.inline("SECONDS")?markup_string?lower_case}
         [#assign ttl = "tenant.externalIdentifierConfiguration.${id}TimeToLiveInSeconds"?eval/]
         [#if ttl > 120] (${helpers.approximateFromSeconds(ttl)}) [/#if]
        </td>
      </tr>
      [/#if]
      [#if id == "emailVerificationId"]
      <tr>
        <td>${properties.display(tenant "externalIdentifierConfiguration.emailVerificationOneTimeCodeGenerator.length")}&nbsp;${message.inline(tenant.externalIdentifierConfiguration.emailVerificationOneTimeCodeGenerator.type)}  [@message.print key="oneTimeCode"/]</td>
        <td>${properties.display(tenant, "externalIdentifierConfiguration.${id}TimeToLiveInSeconds")} ${message.inline("SECONDS")?markup_string?lower_case} (${helpers.approximateFromSeconds("tenant.externalIdentifierConfiguration.${id}TimeToLiveInSeconds"?eval)})</td>
      </tr>
      [/#if]
      [#if id == "registrationVerificationId"]
      <tr>
        <td>${properties.display(tenant "externalIdentifierConfiguration.registrationVerificationOneTimeCodeGenerator.length")}&nbsp;${message.inline(tenant.externalIdentifierConfiguration.registrationVerificationOneTimeCodeGenerator.type)}  [@message.print key="oneTimeCode"/]</td>
        <td>${properties.display(tenant, "externalIdentifierConfiguration.${id}TimeToLiveInSeconds")} ${message.inline("SECONDS")?markup_string?lower_case} (${helpers.approximateFromSeconds("tenant.externalIdentifierConfiguration.${id}TimeToLiveInSeconds"?eval)})</td>
      </tr>
      [/#if]
      [/#list]
    </tbody>
  </table>

  [#-- Data --]
  [#if (tenant.data)?? && tenant.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(tenant.data)}</pre>
  [/#if]
[/@dialog.view]
