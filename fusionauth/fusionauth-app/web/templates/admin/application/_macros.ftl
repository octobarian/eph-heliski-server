[#ftl/]
[#-- @ftlvariable name="accessTokenKeys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="adminRegistrationEditForms" type="java.util.List<io.fusionauth.domain.form.Form>" --]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="authorizedURLValidationPolicies" type="java.util.List<io.fusionauth.domain.oauth2.Oauth2AuthorizedURLValidationPolicy>" --]
[#-- @ftlvariable name="availableGrants" type="java.util.List<io.fusionauth.domain.oauth2.GrantType>" --]
[#-- @ftlvariable name="c14nMethods" type="io.fusionauth.domain.CanonicalizationMethod[]" --]
[#-- @ftlvariable name="cleanSpeakApplications" type="java.util.List<io.fusionauth.api.service.moderation.cleanspeak.Application>" --]
[#-- @ftlvariable name="clientAuthenticationPolicies" type="io.fusionauth.domain.oauth2.ClientAuthenticationPolicy[]" --]
[#-- @ftlvariable name="emailTemplates" type="java.util.List<io.fusionauth.domain.email.EmailTemplate>" --]
[#-- @ftlvariable name="fusionAuthId" type="java.util.UUID" --]
[#-- @ftlvariable name="idTokenAlgorithms" type="java.util.List<io.fusionauth.domain.Key.KeyAlgorithm>" --]
[#-- @ftlvariable name="integrations" type="io.fusionauth.domain.Integrations" --]
[#-- @ftlvariable name="jwtLambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="registrationLambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="keys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="logoutBehaviors" type="io.fusionauth.domain.oauth2.LogoutBehavior[]" --]
[#-- @ftlvariable name="multiFactorLoginPolicies" type="io.fusionauth.domain.MultiFactorLoginPolicy[]" --]
[#-- @ftlvariable name="multiFactorTrustPolicies" type="io.fusionauth.domain.ApplicationMultiFactorTrustPolicy[]" --]
[#-- @ftlvariable name="proofKeyForCodeExchangePolicies" type="io.fusionauth.domain.oauth2.ProofKeyForCodeExchangePolicy[]" --]
[#-- @ftlvariable name="refreshTokenExpirationPolicies" type="io.fusionauth.domain.RefreshTokenExpirationPolicy[]" --]
[#-- @ftlvariable name="refreshTokenUsagePolicies" type="io.fusionauth.domain.RefreshTokenUsagePolicy[]" --]
[#-- @ftlvariable name="registrationTypes" type="io.fusionauth.domain.Application.RegistrationConfiguration.RegistrationType[]" --]
[#-- @ftlvariable name="registrationForms" type="java.util.List<io.fusionauth.domain.form.Form>" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="samlv2EncryptionKeys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="samlv2Keys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="samlv2VerificationKeys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="samlv2Lambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="signatureLocations" type="io.fusionauth.domain.Application.SAMLv2Configuration.XMLSignatureLocation[]" --]
[#-- @ftlvariable name="samlAssertionEncryptionAlgorithms" type="io.fusionauth.samlv2.domain.EncryptionAlgorithm[]" --]
[#-- @ftlvariable name="samlAssertionEncryptionDigestAlgorithms" type="io.fusionauth.samlv2.domain.DigestAlgorithm[]" --]
[#-- @ftlvariable name="samlAssertionEncryptionKeyLocations" type="io.fusionauth.samlv2.domain.KeyLocation[]" --]
[#-- @ftlvariable name="samlAssertionEncryptionKeyTransportAlgorithms" type="io.fusionauth.samlv2.domain.KeyTransportAlgorithm[]" --]
[#-- @ftlvariable name="samlAssertionEncryptionMaskGenerationFunctions" type="io.fusionauth.samlv2.domain.MaskGenerationFunction[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[#macro configurations action]
  <ul class="tabs">
    [#if action == 'add']
      <li><a href="#role-configuration">[@message.print key="roles"/]</a></li>
    [/#if]
    [#if action == 'add' || applicationId != fusionAuthId]
      <li><a href="#oauth-configuration">[@message.print key="oauth"/]</a></li>
    [/#if]
    [#if action == 'add' || applicationId != fusionAuthId]
      <li><a href="#cleanspeak-configuration">[@message.print key="clean-speak-integration"/]</a></li>
    [/#if]
    <li><a href="#email-settings">[@message.print key="email"/]</a></li>
    <li><a href="#jwt-settings">[@message.print key="jwt"/]</a></li>
    <li><a href="#multi-factor-configuration">[@message.print key="multi-factor"/]</a></li>
    <li><a href="#webauthn-settings">[@message.print key="webauthn"/]</a></li>
    [#if !applicationId?has_content || applicationId != fusionAuthId]
      <li><a href="#registration-settings">[@message.print key="registration"/]</a></li>
    [/#if]
    [#if action == 'add' || applicationId != fusionAuthId]
    <li><a href="#samlv2-settings">[@message.print key="saml"/]</a></li>
    [/#if]
    <li><a href="#security-settings">[@message.print key="security"/]</a></li>
    <li><a href="#advanced-settings">[@message.print key="advanced"/]</a></li>
  </ul>
  [#if action == 'add']
    <div id="role-configuration" class="hidden">
      [@roleConfiguration/]
    </div>
  [/#if]
  [#if action == 'add' || applicationId != fusionAuthId]
    <div id="oauth-configuration" class="hidden">
      [@oauthConfiguration/]
    </div>
  [/#if]
  [#if action == 'add' || applicationId != fusionAuthId]
    <div id="cleanspeak-configuration" class="hidden">
      [@cleanSpeakConfiguration/]
    </div>
  [/#if]
  [#if !applicationId?has_content || applicationId != fusionAuthId]
    <div id="registration-settings" class="hidden">
      [@registrationConfiguration/]
    </div>
  [/#if]
  <div id="email-settings" class="hidden">
    [@emailConfiguration action/]
  </div>
  <div id="jwt-settings" class="hidden">
    [#local isFusionAuth = action == 'edit' && applicationId == fusionAuthId/]
    [@jwtConfiguration action isFusionAuth/]
  </div>
  <div id="multi-factor-configuration" class="hidden">
    [@multiFactorConfiguration/]
  </div>
  [#if action == 'add' || applicationId != fusionAuthId]
  <div id="samlv2-settings" class="hidden">
    [@samlv2Configuration/]
  </div>
  [/#if]
  <div id="webauthn-settings" class="hidden">
    [@webauthnConfiguration /]
  </div>
  <div id="security-settings" class="hidden">
    [@securityConfiguration action/]
  </div>
  <div id="advanced-settings" class="hidden">
    [@advancedConfiguration/]
  </div>
[/#macro]

[#macro advancedConfiguration]
<fieldset>
  <legend>[@message.print key="external-identifiers-duration"/]</legend>
  <p><em>[@message.print key="{description}external-identifiers"/]</em></p>
  [@control.text name="application.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(application.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" tooltip=function.message('{tooltip}application.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds') placeholder="Tenant configuration is ${ftlCurrentTenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds?string('#,###')} seconds, or ${helpers.approximateFromSeconds(ftlCurrentTenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds)?lower_case}"/]
</fieldset>
[/#macro]

[#macro emailConfiguration action]
<fieldset>
  <legend>[@message.print key="template-settings"/]</legend>
  <p><em>[@message.print key="{description}template-settings"/]</em></p>
    [#assign templateNames = fusionAuth.statics['io.fusionauth.domain.Application$ApplicationEmailConfiguration'].EmailTemplateIdFieldNames/]
    [#if emailTemplates?? && emailTemplates?size gt 0]
      [#list templateNames as templateName]
        [@control.select items=emailTemplates name="application.emailConfiguration.${templateName}" valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-use-tenant" tooltip=function.message('{tooltip}application.emailConfiguration.${templateName}')/]
      [/#list]
    [#else]
      [#list templateNames as templateName]
        [@control.hidden name="application.emailConfiguration.${templateName}"/]
      [/#list]
      [@message.print key="no-email-templates"/]
    [/#if]
</fieldset>
[/#macro]

[#macro webauthnConfiguration]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}webauthn-settings"/]</em>
  </p>
  <fieldset>
    [@control.checkbox name="application.webAuthnConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="application-webauthn-config"/]
  </fieldset>
  <div id="application-webauthn-config" class="slide-open [#if application.webAuthnConfiguration.enabled]open[/#if]">
    <fieldset>
      <legend>[@message.print key="webauthn-bootstrap-settings"/]</legend>
      <p><em>[@message.print key="{description}webauthn-bootstrap-settings"/]</em></p>
      [@control.checkbox name="application.webAuthnConfiguration.bootstrapWorkflow.enabled" value="true" uncheckedValue="false" /]
    </fieldset>
    <fieldset>
      <legend>[@message.print key="webauthn-reauthentication-settings"/]</legend>
      <p><em>[@message.print key="{description}webauthn-reauthentication-settings"/]</em></p>
      [@control.checkbox name="application.webAuthnConfiguration.reauthenticationWorkflow.enabled" value="true" uncheckedValue="false" /]
    </fieldset>
  </div>
[/#macro]

[#macro securityConfiguration action]
[#if action == 'add' || applicationId != fusionAuthId]
<fieldset>
  <legend>[@message.print key="login-settings"/]</legend>
  <p><em>[@message.print key="{description}login-settings"/]</em></p>
  [@control.checkbox name="application.loginConfiguration.requireAuthentication" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.loginConfiguration.requireAuthentication")/]
  [@control.checkbox name="application.loginConfiguration.generateRefreshTokens" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.loginConfiguration.generateRefreshTokens")/]
  [@control.checkbox name="application.loginConfiguration.allowTokenRefresh" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.loginConfiguration.allowTokenRefresh")/]
</fieldset>
[/#if]
<fieldset>
  <legend>[@message.print key="access-control-lists-settings"/]</legend>
  <p><em>[@message.print key="{description}access-control-lists-settings"/]</em></p>
  [@control.select name="application.accessControlConfiguration.uiIPAccessControlListId" items=ipAccessControlLists tooltip=function.message('{tooltip}application.accessControlConfiguration.uiIPAccessControlListId') valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-access-control-list-use-tenant" /]
</fieldset>
<fieldset>
  <legend>[@message.print key="passwordless-settings"/]</legend>
  <p><em>[@message.print key="{description}passwordless-settings"/]</em></p>
  [@control.checkbox name="application.passwordlessConfiguration.enabled" value="true" uncheckedValue="false" /]
</fieldset>
[#if action == 'add' || applicationId != fusionAuthId]
<fieldset>
  <legend>[@message.print key="authentication-token-settings"/]</legend>
  <p><em>[@message.print key="{description}authentication-token-settings"/]</em></p>
  [@control.checkbox name="application.authenticationTokenConfiguration.enabled" value="true" uncheckedValue="false" /]
</fieldset>
[/#if]
[/#macro]

[#macro registrationConfiguration]
  <fieldset>
    <legend>[@message.print key="registration-verification-settings"/]</legend>
    [#if emailTemplates?has_content]
      [@control.checkbox name="application.verifyRegistration" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.verifyRegistration") data_slide_open="verify-registration-configuration"/]
      <div id="verify-registration-configuration" class="slide-open [#if (application.verifyRegistration)!false]open[/#if]">
        <fieldset>
          [@control.select name="application.verificationEmailTemplateId" items=emailTemplates selected=application.verificationEmailTemplateId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" required=true tooltip=function.message('{tooltip}application.verificationEmailTemplateId')/]
          [@control.select name="application.verificationStrategy" items=registrationVerificationStrategies wideTooltip=function.message("{tooltip}application.verificationStrategy")/]
          [@control.select name="application.unverified.behavior" items=unverifiedRegistrationBehaviors tooltip=function.message("{tooltip}application.unverified.behavior")/]
        </fieldset>
        <fieldset>
          [@control.checkbox name="application.registrationDeletePolicy.unverified.enabled" value="true" uncheckedValue="false" data_slide_open="delete-unverified-settings" tooltip=function.message("{tooltip}application.registrationDeletePolicy.unverified.enabled")/]
          <div id="delete-unverified-settings" class="slide-open [#if application.registrationDeletePolicy.unverified.enabled]open[/#if]">
            [@control.text name="application.registrationDeletePolicy.unverified.numberOfDaysToRetain" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}application.registrationDeletePolicy.unverified.numberOfDaysToRetain")/]
          </div>
        </fieldset>
      </div>
    [#else]
      [@control.hidden name="application.verifyRegistration"/]
      [@message.print key="no-email-templates-available-registration-validation"/]
    [/#if]
  </fieldset>

  <fieldset class="mt-5">
    <legend>[@message.print key="registration-settings"/]</legend>
    <p><em>[@message.print key="{description}registration-settings"/]</em></p>
    [@control.checkbox name="application.registrationConfiguration.enabled"  value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.registrationConfiguration.enabled") data_slide_open="registration-configuration"/]
  </fieldset>

  <div id="registration-configuration" class="slide-open [#if (application.registrationConfiguration.enabled)!false]open[/#if]">
    <fieldset>
      [@control.radio_list name="application.registrationConfiguration.type" items=registrationTypes tooltip=function.message("{tooltip}application.registrationConfiguration.type") data_slide_open="advanced-registration-configuration" data_slide_closed="basic-registration-configuration" /]
    </fieldset>
    <div id="advanced-registration-configuration" class="slide-open[#if (application.registrationConfiguration.type == "advanced")!false] open[/#if]">
      [@control.select name="application.registrationConfiguration.formId" items=registrationForms valueExpr="id" textExpr="name" headerValue="" required=true headerL10n="select-form" tooltip=function.message("{tooltip}application.registrationConfiguration.formId")/]
      [@control.select name="application.lambdaConfiguration.selfServiceRegistrationValidationId" items=registrationLambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
    </div>
    <div id="basic-registration-configuration" class="slide-open[#if (application.registrationConfiguration.type == "basic")!false] open[/#if]">
      [@control.checkbox name="application.registrationConfiguration.confirmPassword" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.registrationConfiguration.confirmPassword")/]
      [@control.radio_list name="application.registrationConfiguration.loginIdType" items=loginIdTypes tooltip=function.message("{tooltip}application.registrationConfiguration.loginIdType")/]
      <div class="form-row">
        <label>[@message.print key="registration-fields"/]</label>
        <table>
          <thead>
          <tr>
            <th>[@message.print key="field"/]</th>
            <th class="tight" data-select-col="enabled">[@message.print key="enabled"/]</th>
            <th class="tight" data-select-col="required">[@message.print key="required"/]</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.birthDate"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.birthDate.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.birthDate.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.firstName"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.firstName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.firstName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.fullName"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.fullName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.fullName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.lastName"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.lastName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.lastName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.middleName"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.middleName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.middleName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.mobilePhone"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.mobilePhone.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.mobilePhone.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          <tr>
            <td data-select-row="true">[@message.print key="application.registrationConfiguration.preferredLanguages"/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.preferredLanguages.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            <td class="tight">[@control.checkbox name="application.registrationConfiguration.preferredLanguages.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <fieldset class="mt-5">
    <legend>[@message.print key="form-settings"/]</legend>
    <p><em>[@message.print key="{description}form-settings"/]</em></p>
    [@control.select name="application.formConfiguration.adminRegistrationFormId" items=adminRegistrationForms valueExpr="id" textExpr="name" tooltip=function.message("{tooltip}application.formConfiguration.adminRegistrationFormId")/]
    [@control.select name="application.formConfiguration.selfServiceFormId" items=selfServiceUserForms valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-self-service-user-empty" data_slide_open="selfServiceConfig" data_slide_closed_value="" tooltip=function.message("{tooltip}application.formConfiguration.selfServiceFormId")/]
    <div id="selfServiceConfig" class="slide-open ${application.formConfiguration.selfServiceFormId?has_content?then('open', '')}">
      [@control.checkbox name="application.formConfiguration.selfServiceFormConfiguration.requireCurrentPasswordOnPasswordChange" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.formConfiguration.selfServiceFormConfiguration.requireCurrentPasswordOnPasswordChange")/]
    </div>
  </fieldset>
[/#macro]

[#macro jwtConfiguration action isFusionAuth]
<p class="mt-0">
  <em>[@message.print key="jwt-settings-description"/]</em>
</p>
<fieldset>
  [@control.checkbox name="application.jwtConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="jwt-settings-body" disabled=isFusionAuth/]
</fieldset>

<div id="jwt-settings-body" data-jwt-settings-body="true" class="slide-open ${application.jwtConfiguration.enabled?then('open', '')}">
  <fieldset>
    <legend>[@message.print key="jwt-settings"/]</legend>
    <p><em>[@message.print key="{description}jwt-settings"/]</em></p>
    [#if action == "edit"]
      [@helpers.fauxInput type="text" name="application.jwtConfiguration.issuer" labelKey="application.jwtConfiguration.issuer" value="${helpers.tenantById(tenantId).issuer!''}" autocapitalize="none" autocorrect="off" disabled=true tooltip=function.message('{tooltip}jwtConfiguration.issuer')/]
    [/#if]
    [@control.text name="application.jwtConfiguration.timeToLiveInSeconds" title="${helpers.approximateFromSeconds(application.jwtConfiguration.timeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message("{tooltip}jwtConfiguration.timeToLiveInSeconds")/]
    [@control.select name="application.jwtConfiguration.accessTokenKeyId" items=accessTokenKeys![] required=false valueExpr="id" textExpr="displayName" headerValue="" headerL10n="generate-signing-key"  tooltip=function.message('{tooltip}jwtConfiguration.accessTokenKeyId')/]
    [@control.select name="application.jwtConfiguration.idTokenKeyId" items=keys![] required=false valueExpr="id" textExpr="displayName" headerValue="" headerL10n="generate-signing-key"  tooltip=function.message('{tooltip}jwtConfiguration.idTokenKeyId')/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="refresh-token-settings"/]</legend>
    <p><em>[@message.print key="{description}refresh-token-settings"/]</em></p>
    [@control.select name="application.jwtConfiguration.refreshTokenExpirationPolicy" items=refreshTokenExpirationPolicies disabled=isFusionAuth wideTooltip=function.message('{tooltip}jwtConfiguration.refreshTokenExpirationPolicy') data_slide_open="sliding-window-max-ttl" data_slide_open_value="SlidingWindowWithMaximumLifetime" /]
    [@control.text name="application.jwtConfiguration.refreshTokenTimeToLiveInMinutes" title="${helpers.approximateFromMinutes(application.jwtConfiguration.refreshTokenTimeToLiveInMinutes)}" rightAddonText="${function.message('MINUTES')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenTimeToLiveInMinutes')/]
      <div id="sliding-window-max-ttl" class="slide-open ${(application.jwtConfiguration.refreshTokenExpirationPolicy == "SlidingWindowWithMaximumLifetime")?then('open', '')}">
        [@control.text name="application.jwtConfiguration.refreshTokenSlidingWindowConfiguration.maximumTimeToLiveInMinutes" required=true title="${helpers.approximateFromMinutes(application.jwtConfiguration.refreshTokenSlidingWindowConfiguration.maximumTimeToLiveInMinutes!0)}" rightAddonText="${function.message('MINUTES')}" required=true tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenSlidingWindowConfiguration.maximumTimeToLiveInMinutes')/]
      </div>
    [@control.select name="application.jwtConfiguration.refreshTokenUsagePolicy" items=refreshTokenUsagePolicies required=false disabled=isFusionAuth tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenUsagePolicy')/]
  </fieldset>
</div>

<fieldset>
  <legend>[@message.print key="custom-claim-configuration"/]</legend>
  <p><em>[@message.print key="{description}custom-claim-configuration"/]</em></p>
  [@control.select name="application.lambdaConfiguration.accessTokenPopulateId" items=jwtLambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
  [@control.select name="application.lambdaConfiguration.idTokenPopulateId" items=jwtLambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
</fieldset>
[/#macro]

[#macro multiFactorConfiguration]
<fieldset>
  <p><em>[@message.print key="{description}multi-factor-settings"/]</em></p>
</fieldset>
<fieldset>
  [@control.select name="application.multiFactorConfiguration.loginPolicy" items=multiFactorLoginPolicies![]  headerValue="" headerL10n="none-selected-use-tenant-policy" data_slide_open="mfa-trust-policy" data_slide_open_value="Enabled"/]
  <div id="mfa-trust-policy" class="slide-open ${(application.multiFactorConfiguration.loginPolicy?? && application.multiFactorConfiguration.loginPolicy == "Enabled")?then('open', '')}">
    [@control.select name="application.multiFactorConfiguration.trustPolicy" items=multiFactorTrustPolicies![]  /]
  </div>
</fieldset>
<fieldset>
  [@control.select name="application.multiFactorConfiguration.email.templateId" items=emailTemplates![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-use-tenant" tooltip=function.message("{tooltip}application.multiFactorConfiguration.email.templateId")/]
  [@control.select name="application.multiFactorConfiguration.sms.templateId" items=smsMessageTemplates![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-use-tenant" tooltip=function.message("{tooltip}application.multiFactorConfiguration.email.templateId")/]
</fieldset>
[/#macro]

[#macro samlv2Configuration]
<p class="mt-0 mb-4">
  <em>[@message.print key="{description}samlv2-settings"/]</em>
</p>
<fieldset>
  [@control.checkbox name="application.samlv2Configuration.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-settings-body"/]
</fieldset>

[#-- If SAMLv2 is enabled, or we have an error to show. --]
[#local showSAMLv2 = application.samlv2Configuration.enabled /]
[#list fieldMessages?keys as fieldMessage]
  [#if fieldMessage?starts_with("application.samlv2Configuration.")]
    [#local showSAMLv2 = true/]
    [#break]
  [/#if]
[/#list]
<div id="samlv2-settings-body" class="slide-open ${showSAMLv2?then('open', '')}">
  <fieldset>
    [@control.text name="application.samlv2Configuration.issuer" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="e.g. google.com" required=true tooltip=function.message('{tooltip}application.samlv2Configuration.issuer')/]
    [@control.text name="application.samlv2Configuration.audience" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder=function.message('{placeholder}application.samlv2Configuration.audience') tooltip=function.message('{tooltip}application.samlv2Configuration.audience')/]
    [@control.select items=application.samlv2Configuration.authorizedRedirectURLs multiple=true name="application.samlv2Configuration.authorizedRedirectURLs" class="select no-wrap" required=true tooltip=function.message('{tooltip}application.samlv2Configuration.authorizedRedirectURLs')/]
    [@control.text name="application.samlv2Configuration.logoutURL" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="e.g. https://www.example.com/logout" tooltip=function.message('{tooltip}application.samlv2Configuration.logoutURL')/]
    [@control.checkbox name="application.samlv2Configuration.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}application.samlv2Configuration.debug')/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="saml-authn-request"/]</legend>
    <p><em>[@message.print key="{description}saml-authn-request"/]</em></p>
    [@control.checkbox name="application.samlv2Configuration.requireSignedRequests" value="true" uncheckedValue="false" data_slide_open="samlv2-require-signed-requests" tooltip=function.message('{tooltip}application.samlv2Configuration.requireSignedRequests')/]
    <div id="samlv2-require-signed-requests" class="slide-open ${application.samlv2Configuration.requireSignedRequests?then('open', '')}">
     [@control.select name="application.samlv2Configuration.defaultVerificationKeyId" items=samlv2VerificationKeys![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="select-verification-key" tooltip=function.message('{tooltip}application.samlv2Configuration.defaultVerificationKeyId')/]
    </div>

    [@control.checkbox name="application.samlv2Configuration.loginHintConfiguration.enabled" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}application.samlv2Configuration.loginHintConfiguration.enabled') data_slide_open="saml-login-hint-config"/]
    <div id="saml-login-hint-config" class="slide-open [#if application.samlv2Configuration.loginHintConfiguration.enabled]open[/#if]">
      [@control.text name="application.samlv2Configuration.loginHintConfiguration.parameterName" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" placeholder=function.message('{placeholder}application.samlv2Configuration.loginHintConfiguration.parameterName') tooltip=message.inline('{tooltip}application.samlv2Configuration.loginHintConfiguration.parameterName')/]
    </div>
  </fieldset>

  <fieldset>
    <legend>[@message.print key="saml-authn-response"/]</legend>
    <p><em>[@message.print key="{description}saml-authn-response"/]</em></p>
    [@control.select name="application.samlv2Configuration.keyId" items=samlv2Keys![] required=false valueExpr="id" textExpr="name" headerValue="" headerL10n="generate-signing-key"  tooltip=function.message('{tooltip}application.samlv2Configuration.keyId')/]
    [@control.select name="application.samlv2Configuration.xmlSignatureC14nMethod" items=c14nMethods![] required=false tooltip=function.message('{tooltip}application.samlv2Configuration.xmlSignatureC14nMethod')/]
    [@control.select name="application.samlv2Configuration.xmlSignatureLocation" items=signatureLocations![] required=false tooltip=function.message('{tooltip}application.samlv2Configuration.xmlSignatureLocation')/]
    [@control.select name="application.lambdaConfiguration.samlv2PopulateId" items=samlv2Lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
  </fieldset>
  <fieldset>
    [@control.checkbox name="application.samlv2Configuration.initiatedLogin.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-initiate-login" tooltip=function.message('{tooltip}application.samlv2Configuration.initiatedLogin.enabled')/]
    <div id="samlv2-initiate-login" class="slide-open ${application.samlv2Configuration.initiatedLogin.enabled?then('open', '')}">
      [@control.select name="application.samlv2Configuration.initiatedLogin.nameIdFormat" items={'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent':'Persistent [urn:oasis:names:tc:SAML:2.0:nameid-format:persistent]', 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress':'Email [urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress]'} /]
    </div>
  </fieldset>

  <fieldset>
   <legend>[@message.print key="saml-logout-request"/]</legend>
    <p><em>[@message.print key="{description}saml-logout-request"/]</em></p>
    [@control.checkbox name="application.samlv2Configuration.logout.requireSignedRequests" value="true" uncheckedValue="false" data_slide_open="samlv2-logout-require-signed-requests" tooltip=function.message('{tooltip}application.samlv2Configuration.logout.requireSignedRequests')/]
    <div id="samlv2-logout-require-signed-requests" class="slide-open ${application.samlv2Configuration.logout.requireSignedRequests?then('open', '')}">
      [@control.select name="application.samlv2Configuration.logout.defaultVerificationKeyId" items=samlv2VerificationKeys![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="select-verification-key" tooltip=function.message('{tooltip}application.samlv2Configuration.defaultVerificationKeyId')/]
    </div>
    [@control.select name="application.samlv2Configuration.logout.behavior" items=samlv2LogoutBehaviors![] tooltip=function.message('{tooltip}application.samlv2Configuration.logout.behavior')/]
    [@control.checkbox name="application.samlv2Configuration.logout.singleLogout.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-single-logout" tooltip=function.message('{tooltip}application.samlv2Configuration.logout.singleLogout.enabled')/]
    <div id="samlv2-single-logout" class="slide-open ${application.samlv2Configuration.logout.singleLogout.enabled?then('open', '')}">
      [@control.text name="application.samlv2Configuration.logout.singleLogout.url" required=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}application.samlv2Configuration.singleLogout.url')/]
      [@control.select name="application.samlv2Configuration.logout.singleLogout.keyId" items=samlv2Keys![] required=false valueExpr="id" textExpr="name" headerValue="" headerL10n="use-primary-signing-key"  tooltip=function.message('{tooltip}application.samlv2Configuration.keyId')/]
      [@control.select name="application.samlv2Configuration.logout.singleLogout.xmlSignatureC14nMethod" items=c14nMethods![]  tooltip=function.message('{tooltip}application.samlv2Configuration.xmlSignatureC14nMethod')/]
    </div>
  </fieldset>

  <fieldset>
     <legend>[@message.print key="saml-logout-response"/]</legend>
      <p><em>[@message.print key="{description}saml-logout-response"/]</em></p>
      [@control.select name="application.samlv2Configuration.logout.keyId" items=samlv2Keys![]  valueExpr="id" textExpr="name" headerValue="" headerL10n="use-primary-signing-key"  tooltip=function.message('{tooltip}application.samlv2Configuration.keyId')/]
      [@control.select name="application.samlv2Configuration.logout.xmlSignatureC14nMethod" items=c14nMethods![]  tooltip=function.message('{tooltip}application.samlv2Configuration.xmlSignatureC14nMethod')/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="saml-assertion-encryption"/]</legend>
    <p><em>[@message.print key="{description}saml-assertion-encryption"/]</em></p>
    <fieldset>
      [@control.checkbox name="application.samlv2Configuration.assertionEncryptionConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-assertion-encryption-body"/]
    </fieldset>
    [#local showAssertionEncryption = application.samlv2Configuration.assertionEncryptionConfiguration.enabled /]
    <div id="samlv2-assertion-encryption-body" class="slide-open ${showAssertionEncryption?then('open', '')}">
      [@control.select name="application.samlv2Configuration.assertionEncryptionConfiguration.encryptionAlgorithm" items=samlAssertionEncryptionAlgorithms![] tooltip=function.message('{tooltip}application.samlv2Configuration.assertionEncryptionConfiguration.encryptionAlgorithm')/]
      [@control.select name="application.samlv2Configuration.assertionEncryptionConfiguration.keyLocation" items=samlAssertionEncryptionKeyLocations![] wideTooltip=function.message('{tooltip}application.samlv2Configuration.assertionEncryptionConfiguration.keyLocation')/]
      [@control.select name="application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportAlgorithm" items=samlAssertionEncryptionKeyTransportAlgorithms![] tooltip=function.message('{tooltip}application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportAlgorithm') data_slide_open="samlv2-assertion-encryption-mgf" data_slide_open_value="RSA_OAEP" /]
      [@control.select name="application.samlv2Configuration.assertionEncryptionConfiguration.digestAlgorithm" items=samlAssertionEncryptionDigestAlgorithms![] tooltip=function.message('{tooltip}application.samlv2Configuration.assertionEncryptionConfiguration.digestAlgorithm')/]
      <div id="samlv2-assertion-encryption-mgf" class="slide-open ${(application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportAlgorithm == "RSA_OAEP")?then('open', '')}">
        [@control.select name="application.samlv2Configuration.assertionEncryptionConfiguration.maskGenerationFunction" items=samlAssertionEncryptionMaskGenerationFunctions![] tooltip=function.message('{tooltip}application.samlv2Configuration.assertionEncryptionConfiguration.maskGenerationFunction')/]
      </div>
      [@control.select name="application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportEncryptionKeyId" items=samlv2EncryptionKeys![] required=true  valueExpr="id" textExpr="name" headerValue="" headerL10n="select-assertion-encryption-key"  tooltip=function.message('{tooltip}application.samlv2Configuration.assertionEncryptionConfiguration.keyTransportEncryptionKeyId')/]
    </div>
  </fieldset>

</div>
[/#macro]

[#macro cleanSpeakConfiguration]
<fieldset>
  [#if integrations.cleanspeak.enabled]
    [#if cleanSpeakApplications?has_content]
      <p class="mt-0">
        <em>[@message.print key="clean-speak-settings.description"/]</em>
      </p>
      [@control.checkbox_list items=cleanSpeakApplications textExpr="name" valueExpr="id" name="application.cleanSpeakConfiguration.applicationIds" tooltip=function.message("clean-speak-mapping-info")/]
      [@control.checkbox name="application.cleanSpeakConfiguration.usernameModeration.enabled" value="true" uncheckedValue="false"/]
      <div id="clean-speak-settings">
        [@control.select name="application.cleanSpeakConfiguration.usernameModeration.applicationId" textExpr="name" valueExpr="id" items=cleanSpeakApplications headerValue="" headerL10n="selection-required"/]
      </div>
    [#else]
      [@message.print key="clean-speak-down-or-has-no-applications"/]
    [/#if]
  [#else]
    <p class="mt-0">
      <em>[@message.print key="clean-speak-not-enabled"/]</em>
    </p>
  [/#if]
</fieldset>
[/#macro]

[#macro oauthConfiguration]
  <p class="mt-0 mb-4">
    <em>[@message.print key="oauth-settings-description"/]</em>
  </p>
  <fieldset>
    [@control.text name="application.oauthConfiguration.clientId" value="${application.oauthConfiguration.clientId?has_content?then(application.oauthConfiguration.clientId, function.message('{placeholder}application.oauth.clientId'))}" disabled=true/]
    [@control.hidden name="application.oauthConfiguration.clientId"/]
    [@control.text id="client-secret-input" name="application.oauthConfiguration.clientSecret" disabled=true rightAddonButton="<i class=\"fa fa-arrow-circle-right\"></i> <span class=\"text\">${message.inline('regenerate')?markup_string}</span>"?no_esc data_hidden="client-secret-hidden"/]
    [@control.hidden id="client-secret-hidden" name="application.oauthConfiguration.clientSecret"/]
    [@control.select name="application.oauthConfiguration.clientAuthenticationPolicy" items=clientAuthenticationPolicies![] labelKey="oauth.clientAuthenticationPolicy" tooltip=function.message('{tooltip}oauth.clientAuthenticationPolicy')/]
    [@control.select name="application.oauthConfiguration.proofKeyForCodeExchangePolicy"  items=proofKeyForCodeExchangePolicies![] labelKey="oauth.proofKeyForCodeExchangePolicy" tooltip=function.message('{tooltip}oauth.proofKeyForCodeExchangePolicy')/]
    [@control.checkbox name="application.oauthConfiguration.generateRefreshTokens" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.oauthConfiguration.generateRefreshTokens")/]
    [@control.checkbox name="application.oauthConfiguration.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}application.oauthConfiguration.debug')/]
    [@control.select items=authorizedURLValidationPolicies name="application.oauthConfiguration.authorizedURLValidationPolicy" wideTooltip=function.message('{tooltip}application.oauthConfiguration.authorizedURLValidationPolicy') /]
    [@control.select id="redirectURLs" items=application.oauthConfiguration.authorizedRedirectURLs multiple=true name="application.oauthConfiguration.authorizedRedirectURLs" class="select no-wrap" labelKey="oauth.redirectURLs"  tooltip=function.message('{tooltip}oauth.redirectURLs')/]
    [@control.select id="origins" items=application.oauthConfiguration.authorizedOriginURLs multiple=true name="application.oauthConfiguration.authorizedOriginURLs" class="select no-wrap" labelKey="oauth.origin" tooltip=function.message('{tooltip}oauth.origin')/]
    [@control.text name="application.oauthConfiguration.logoutURL" autocapitalize="none" autocomplete="on" autocorrect="off" labelKey="oauth.logoutURL" placeholder="e.g. https://www.example.com" tooltip=function.message('{tooltip}oauth.logoutURL')/]
    [@control.select name="application.oauthConfiguration.logoutBehavior" items=logoutBehaviors![] labelKey="oauth.logoutBehavior" tooltip=function.message('{tooltip}oauth.logoutBehavior')/]
    [@control.checkbox_list id="enabled-grants" items=availableGrants name="application.oauthConfiguration.enabledGrants" data_slide_open="device-verification-url" data_slide_open_value="device_code" /]
    <div id="device-verification-url" class="slide-open [#if application.oauthConfiguration.enabledGrants?seq_contains(fusionAuth.statics['io.fusionauth.domain.oauth2.GrantType'].device_code)]open[/#if]">
      [@control.text name="application.oauthConfiguration.deviceVerificationURL" required=true autocapitalize="none" autocomplete="on" autocorrect="off" labelKey="oauth.deviceVerificationURL" placeholder="e.g. https://www.example.com/device" tooltip=function.message('{tooltip}oauth.deviceVerificationURL')/]
    </div>
    [@control.checkbox name="application.oauthConfiguration.requireRegistration" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.oauthConfiguration.requireRegistration")/]
  </fieldset>
[/#macro]

[#macro roleConfiguration]
  <fieldset>
    <table id="role-table" data-template="role-row-template" data-add-button="role-add-button">
      <thead>
      <tr>
        <th>[@message.print key="name"/]</th>
        <th>[@message.print key="default"/]</th>
        <th>[@message.print key="superRole"/]</th>
        <th>[@message.print key="description"/]</th>
        <th data-sortable="false" class="action">[@message.print key="action"/]</th>
      </tr>
      </thead>
      <tbody>
      <tr class="empty-row">
        <td colspan="5">[@message.print key="no-roles"/]</td>
      </tr>
        [#if application?? && application.roles?size > 0]
          [#list application.roles as role]
          <tr>
            <td><input type="text" class="tight" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="application.roles[${role_index}].name" value="${((role.name)!'')}"/></td>
            <td><input type="checkbox" class="tight" name="application.roles[${role_index}].isDefault" value="true" [#if (role.isDefault)!false]checked[/#if]/></td>
            <td><input type="checkbox" class="tight" name="application.roles[${role_index}].isSuperRole" value="true" [#if (role.isSuperRole)!false]checked[/#if]/></td>
            <td><input type="text" class="tight" autocomplete="off" placeholder="${function.message("description")}" name="application.roles[${role_index}].description" value="${((role.description)!'')}"/></td>
            <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
          </tr>
          [/#list]
        [/#if]
      </tbody>
    </table>
    <script type="x-handlebars" id="role-row-template">
      <tr>
        <td><input type="text" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="application.roles[{{index}}].name"/></td>
        <td><label class="checkbox"><input type="checkbox" name="application.roles[{{index}}].isDefault"/><span class="box"></span></label></td>
        <td><label class="checkbox"><input type="checkbox" name="application.roles[{{index}}].isSuperRole"/><span class="box"></span></label></td>
        <td><input type="text" autocomplete="off" placeholder="${function.message("description")}" name="application.roles[{{index}}].description"/></td>
        <td>[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
      </tr>
    </script>
    [@button.iconLinkWithText href="#" color="blue" id="role-add-button" icon="plus" textKey="add-role"/]
  </fieldset>
[/#macro]

[#macro applicationsTable deactivated]
<table id="application-table" class="hover listing" data-sortable="false">
  <thead>
  <tr>
    [@helpers.tableHeader "name"/]
    [@helpers.tableHeader "id" "hide-on-mobile"/]
    <th class="hide-on-mobile" data-sortable="false">[@message.print key="roles"/]</th>
    [#if tenants?size > 1]
      [@helpers.tableHeader "tenant" "hide-on-mobile"/]
    [/#if]
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </tr>
  </thead>
  <tbody>
    [#list results![] as application]
    <tr>
      <td>${application.name}</td>
      <td class="hide-on-mobile">${properties.display(application, "id")}</td>
      <td class="hide-on-mobile">${properties.displayNumber(application, "roles")}</td>
      [#if tenants?size > 1]
        <td class="hide-on-mobile"> ${helpers.tenantName(application.tenantId)}</td>
      [/#if]
      <td class="action">
        [#if deactivated]
          [@button.action href="/ajax/application/reactivate/${application.id}" icon="plus-circle" key="reactivate" color="green" ajaxForm=true/]
          [@button.action href="../delete/${application.id}?tenantId=${application.tenantId}" icon="remove" key="delete" color="red"/]
        [#else]
          [#if application.id != fusionAuthId]
            [@button.action href="edit?applicationId=${application.id}&tenantId=${application.tenantId}" icon="edit" key="edit" color="blue"/]
            [@button.action href="add?applicationId=${application.id}" icon="copy" key="duplicate" color="purple"/]
            [@button.action href="manage-roles?applicationId=${application.id}" icon="user" key="manage-roles" color="purple"/]
            [@button.action href="/ajax/application/view/${application.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
            [@button.action href="/ajax/application/deactivate/${application.id}" icon="minus-circle" key="deactivate" color="gray" ajaxForm=true/]
            [@button.action href="delete/${application.id}?tenantId=${application.tenantId}" icon="trash" key="delete" color="red"/]
          [#else]
            [@button.action href="edit?applicationId=${application.id}&tenantId=${application.tenantId}" icon="edit" key="edit" color="blue"/]
            [@button.action href="/ajax/application/view/${application.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
          [/#if]
        [/#if]
      </td>
    </tr>
    [#else]
    <tr>
      <td colspan="5">[@message.print key="no-results"/]</td>
    </tr>
    [/#list]
  </tbody>
</table>
[/#macro]
