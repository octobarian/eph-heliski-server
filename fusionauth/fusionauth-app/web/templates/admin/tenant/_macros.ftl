[#ftl/]
[#-- @ftlvariable name="messengers" type="java.util.List<io.fusionauth.domain.messenger.BaseMessengerConfiguration>" --]
[#-- @ftlvariable name="breachMatchModes" type="io.fusionauth.domain.PasswordBreachDetection.BreachMatchMode[]" --]
[#-- @ftlvariable name="breachActions" type="io.fusionauth.domain.PasswordBreachDetection.BreachAction[]" --]
[#-- @ftlvariable name="captchaMethods" type="io.fusionauth.domain.CaptchaMethod[]" --]
[#-- @ftlvariable name="connectorDomains" type="java.util.List<java.lang.String>" --]
[#-- @ftlvariable name="connectors" type="java.util.List<io.fusionauth.domain.connector.BaseConnectorConfiguration>" --]
[#-- @ftlvariable name="defaultTenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="editPasswordOption" type="io.fusionauth.app.action.admin.tenant.BaseFormAction.EditPasswordOption" --]
[#-- @ftlvariable name="forms" type="java.util.List<io.fusionauth.domain.form.Form>" --]
[#-- @ftlvariable name="emailSecurityTypes" type="io.fusionauth.domain.EmailConfiguration.EmailSecurityType[]" --]
[#-- @ftlvariable name="emailTemplates" type="java.util.List<io.fusionauth.domain.email.MessageTemplate>" --]
[#-- @ftlvariable name="ipAccessControlLists" type="java.util.List<io.fusionauth.domain.IPAccessControlList>" --]
[#-- @ftlvariable name="multiFactorLoginPolicies" type="io.fusionauth.domain.MultiFactorLoginPolicy[]" --]
[#-- @ftlvariable name="smsMessageTemplates" type="java.util.List<io.fusionauth.domain.message.MessageTemplate>" --]
[#-- @ftlvariable name="eventTypes" type="java.util.List<io.fusionauth.domain.event.EventType>" --]
[#-- @ftlvariable name="expiryUnits" type="io.fusionauth.domain.ExpiryUnit[]" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="transactionTypes" type="io.fusionauth.domain.TransactionType[]" --]
[#-- @ftlvariable name="uniqueUsernameStrategies" type="io.fusionauth.domain.TenantUsernameConfiguration.UniqueUsernameStrategy[]" --]
[#-- @ftlvariable name="webauthnAuthenticatorAttachments" type="java.util.List<io.fusionauth.domain.webauthn.AuthenticatorAttachmentPreference>" --]
[#-- @ftlvariable name="webauthnUserVerificationRequirements" type="java.util.List<io.fusionauth.domain.webauthn.UserVerificationRequirement>" --]
[#-- @ftlvariable name="webhooks" type="java.util.List<io.fusionauth.domain.Webhook>" --]


[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro tenantFields action]
  <fieldset>
    [#if action=="edit"]
      [@control.hidden name="tenantId"/]
      [#-- Hard code the Id so we don't get browser warnings because two elements will have the same Id. --]
      [@control.text disabled=true id="_tenantId" name="tenantId" tooltip=message.inline('{tooltip}readOnly')/]
    [#else]
      [@control.text name="tenantId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}tenantId')/]
    [/#if]
    [@control.text required=true name="tenant.name" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]
  </fieldset>

  <fieldset class="mt-4">
    <ul class="tabs">
      <li><a href="#general-configuration">[@message.print key="general"/]</a></li>
      <li><a href="#connector-configuration">[@message.print key="connectors"/]</a></li>
      <li><a href="#email-configuration">[@message.print key="email"/]</a></li>
      <li><a href="#family-configuration">[@message.print key="family"/]</a></li>
      <li><a href="#multi-factor-configuration">[@message.print key="multi-factor"/]</a></li>
      <li><a href="#webauthn-configuration">[@message.print key="webauthn"/]</a></li>
      <li><a href="#oauth-configuration">[@message.print key="oauth"/]</a></li>
      <li><a href="#jwt-configuration">[@message.print key="jwt"/]</a></li>
      <li><a href="#password-configuration">[@message.print key="password"/]</a></li>
      <li><a href="#webhook-configuration">[@message.print key="webhooks"/]</a></li>
      <li><a href="#scim-configuration">[@message.print key="scim"/]</a></li>
      <li><a href="#security">[@message.print key="security"/]</a></li>
      <li><a href="#advanced-configuration">[@message.print key="advanced"/]</a></li>
    </ul>

    <div id="general-configuration" class="hidden">
      [@generalConfiguration/]
    </div>
    <div id="connector-configuration" class="hidden">
      [@connectorConfiguration/]
    </div>
    <div id="email-configuration" class="hidden">
      [@emailConfiguration action/]
    </div>
    <div id="family-configuration" class="hidden">
      [@familyConfiguration/]
    </div>
    <div id="multi-factor-configuration" class="hidden">
      [@mfaConfiguration/]
    </div>
    <div id="webauthn-configuration" class="hidden">
      [@webauthnConfiguration/]
    </div>
    <div id="oauth-configuration" class="hidden">
      <fieldset>
        <legend>[@message.print key="oauth-settings"/]</legend>
        <p><em> [@message.print key="{description}oauth-settings"/]</em></p>
        [@control.text name="tenant.httpSessionMaxInactiveInterval" rightAddonText="${function.message('SECONDS')}" title="${helpers.approximateFromSeconds(tenant.httpSessionMaxInactiveInterval)}" autocapitalize="none" autocorrect="off" placeholder="e.g. 3600" tooltip=function.message('{tooltip}tenant.httpSessionMaxInactiveInterval')/]
        [@control.text name="tenant.logoutURL" autocapitalize="none" autocorrect="off" placeholder="e.g. http://www.example.com" tooltip=function.message('{tooltip}tenant.logoutURL')/]
        [@control.select items=clientCredentialsLambdas![] name="tenant.oauthConfiguration.clientCredentialsAccessTokenPopulateLambdaId" textExpr="name" valueExpr="id" headerL10n="none-selected-lambda-disabled" headerValue="" required=false tooltip=function.message('{tooltip}tenant.oauthConfiguration.clientCredentialsAccessTokenPopulateLambdaId')/]
      </fieldset>
    </div>
    <div id="jwt-configuration" class="hidden">
      [@jwtConfiguration/]
    </div>
    <div id="password-configuration" class="hidden">
      [@passwordConfiguration/]
    </div>
    <div id="webhook-configuration" class="hidden">
      [@webhookConfiguration/]
    </div>
    <div id="advanced-configuration" class="hidden">
      [@advancedConfiguration/]
    </div>
    <div id="scim-configuration" class="hidden">
        [@scimConfiguration/]
    </div>
    <div id="security" class="hidden">
      [@securityConfiguration/]
    </div>
  </fieldset>
[/#macro]

[#macro connectorConfiguration]
  <fieldset>
    <legend>[@message.print key="connector-settings"/]</legend>
    <p><em>[@message.print key="{description}connector-settings"/]</em></p>

    <div id="connector-settings-long-description" class="slide-open">
      <em>[@message.print key="{description}connector-settings-long"/]</em>
    </div>

    <a href="#" class="slide-open-toggle" style="margin-bottom: 1.5rem !important; margin-top: 1rem;" data-spoiler="connector-settings-long-description" data-spoiler-storage-key="io.fusionauth.tenant.connectorDescription">
      <span>[@message.print key="{tell-me-more}connector-settings"/] <i class="fa fa-angle-down"></i></span>
    </a>

    <table id="connector-policy-table" class="u-small-bottom-margin hover" data-template="connector-policy-row-template">
      <thead>
        <tr>
          <th class="tight"></th>
          <th> [@message.print "name"/] </th>
          <th> [@message.print "type"/] </th>
          <th>
            [@message.print "tenant.connectorPolicies.domains"/]
            <i class="fa fa-info-circle blue-text" data-additional-classes="wide" data-tooltip="${message.inline("{tooltip}tenant.connectorPolicies.domains")}"></i>
          </th>
          <th>
            [@message.print "tenant.connectorPolicies.migrate"/]
            <i class="fa fa-info-circle blue-text" data-additional-classes="wide" data-tooltip="${message.inline("{tooltip}tenant.connectorPolicies.migrate")}"></i>
          </th>
          <th data-sortable="false" class="action">[@message.print key="action"/]</th>
        </tr>
      </thead>
      <tbody>
        [#list tenant.connectorPolicies as connectorPolicy]
          [#local fusionAuthConnector = connectorPolicy.connectorId == fusionAuth.statics['io.fusionauth.domain.connector.BaseConnectorConfiguration'].FUSIONAUTH_CONNECTOR_ID /]
          [#list connectors as c ]
            [#if c.id == connectorPolicy.connectorId]
              [#local connector = c/]
            [/#if]
          [/#list]
          <tr class="connector-policy" data-connector-id="${connectorPolicy.connectorId}">
            [@control.hidden name="tenant.connectorPolicies[${connectorPolicy_index}].connectorId"/]
            [@control.hidden name="connectorDomains[${connectorPolicy_index}]" /]
            [@control.hidden name="tenant.connectorPolicies[${connectorPolicy_index}].migrate"/]
            <td>
              <div class="re-orderable">
                <a href="#" class="button up" data-tooltip="${message.inline("{tooltip}move-up")}"></a>
                <a href="#" class="button down" data-tooltip="${message.inline("{tooltip}move-down")}"></a>
              </div>
            </td>
            <td>${properties.display(connector, "name")}</td>
            <td>${properties.display(connector, "type")}</td>
            <td>${properties.display(connectorPolicy, "domains")}</td>
            <td>${properties.display(connectorPolicy, "migrate", "false", false)}</td>
            <td class="action">
              [#if !fusionAuthConnector]
                [@button.action href="/ajax/tenant/connector-policy/edit" icon="pencil" color="blue" key="edit" additionalClass="edit-button" /]
                [@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button" /]
              [/#if]
            </td>
          </tr>
        [/#list]
      </tbody>
    </table>
  </fieldset>
  <script type="x-handlebars" id="connector-policy-row-template">
    <tr class="connector-policy" data-connector-id="{{connectorId}}">
      <input type="hidden" name="tenant.connectorPolicies[{{index}}].connectorId" value="{{connectorId}}"/>
      <input type="hidden" name="connectorDomains[{{index}}]" value="{{connectorDomains}}"/>
      <input type="hidden" name="tenant.connectorPolicies[{{index}}].migrate" value="{{connectorMigrate}}"/>
      <td>
        <div class="re-orderable">
          <a href="#" class="button disabled up" data-tooltip="Move up"></a>
          <a href="#" class="button down" data-tooltip="Move down"></a>
        </div>
      </td>
      <td>{{connectorName}}</td>
      <td>{{connectorType}}</td>
      <td>{{connectorDomains}}</td>
      <td>{{#if connectorMigrate}}Yes{{else}}No{{/if}}</td>
      <td class="action">
       [@button.action href="/ajax/tenant/connector-policy/edit" icon="pencil" color="blue" key="edit" additionalClass="edit-button"/]
       [@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]
      </td>
    </tr>
  </script>
  [@button.iconLinkWithText href="/ajax/tenant/connector-policy/add" textKey="{button}add-connector-policy" id="add-connector-policy" icon="plus" /]
  <p id="add-connector-policy-disabled" class="hidden">
    <em>[@message.print key="{disabled}add-connector-policy"/]</em>
  </p>
[/#macro]

[#macro webhookConfiguration]
<fieldset>
  <legend>[@message.print key="webhook-settings"/]</legend>
  <p><em>[@message.print key="{description}webhook-settings"/]</em></p>
  [#if webhooks?? && webhooks?size > 0]
    <div class="form-row">
      <label for="webhook-enabled-settings">[@message.print key="webhooks"/]</label>[#t/]
      <div id="webhook-enabled-settings" class="checkbox-list">
        [#list webhooks as webhook]
          [#local checked = webhook.global || (webhook.tenantIds?? && webhook.tenantIds.contains(tenantId))/]
          <label class="checkbox">
            <input type="checkbox" name="webhookIds" value="${webhook.id}" [#if checked]checked="checked"[/#if] [#if webhook.global]disabled="true"[/#if]>
            <span class="box"></span><span class="label">${webhook.url}[#if webhook.global] [@message.print key="webhook-configured-for-all-tenants"/][/#if]</span>
          </label>
        [/#list]
      </div>
    </div>
  [#else]
    <p class="mt-0">
      <em>[@message.print key="no-webhooks"/]</em>
    </p>
  [/#if]
</fieldset>
<fieldset>
  <legend>[@message.print key="webhook-transactions"/]</legend>
  <p><em>[@message.print key="{description}webhook-transactions"/]</em></p>
  <table class="hover">
    <thead>
    <tr>
      <th>[@message.print key="event"/]</th>
      <th>[@message.print key="description"/]</th>
      <th><a data-toggle-column href="#">[@message.print key="enabled"/]</a></th>
      <th>[@message.print key="transaction"/]</th>
    </tr>
    </thead>
    <tbody>
    [#list eventTypes as type]
     [#if type.instanceEvent]
       [#continue /]
     [/#if]
      <tr>
        <td>${type.eventName()}</td>
        <td>[@message.print key="{description}${type}"/]</td>
        <td>[@control.checkbox name="tenant.eventConfiguration.events['${type}'].enabled" labelKey="empty" value="true" uncheckedValue="false" includeFormRow=false/]</td>
        <td>
        [#if type.eventName() == "user.action"]
          [@control.select items=[] name="tenant.eventConfiguration.events['${type}'].transactionType" labelKey="empty" includeFormRow=false disabled=true headerValue="" headerL10n="tx-managed-by-user.action"/]
        [#elseif type.transactionalEvent ]
          [@control.select items=transactionTypes name="tenant.eventConfiguration.events['${type}'].transactionType" labelKey="empty" includeFormRow=false/]
        [#else]
          [@control.select items=transactionTypes name="tenant.eventConfiguration.events['${type}'].transactionType" labelKey="empty" headerValue="" headerL10n="not-transactional" includeFormRow=false disabled=true/]
        [/#if]
        </td>
      </tr>
    [/#list]
    </tbody>
  </table>
</fieldset>
[/#macro]

[#macro advancedConfiguration]
  <fieldset>
    <legend>[@message.print key="external-identifiers-duration"/]</legend>
    <em>[@message.print key="{description}external-identifiers-1"/]</em>
    <p><em>[@message.print key="{description}external-identifiers-2"/]</em></p>
    [@control.text name="tenant.externalIdentifierConfiguration.authorizationGrantIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.authorizationGrantIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.authorizationGrantIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.deviceCodeTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.deviceCodeTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.deviceCodeTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.externalAuthenticationIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.externalAuthenticationIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.externalAuthenticationIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.oneTimePasswordTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.oneTimePasswordTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.oneTimePasswordTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.pendingAccountLinkTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.pendingAccountLinkTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.pendingAccountLinkTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.samlv2AuthNRequestIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.samlv2AuthNRequestIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.samlv2AuthNRequestIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.trustTokenTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.trustTokenTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.trustTokenTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.twoFactorIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.twoFactorIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.twoFactorIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.twoFactorOneTimeCodeIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.twoFactorOneTimeCodeIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.twoFactorOneTimeCodeIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.webAuthnAuthenticationChallengeTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.webAuthnAuthenticationChallengeTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.webAuthnAuthenticationChallengeTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.webAuthnRegistrationChallengeTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.webAuthnRegistrationChallengeTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.webAuthnRegistrationChallengeTimeToLiveInSeconds')/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="external-identifiers-generator"/]</legend>
    <p class="mb-1"><em>[@message.print key="{description}external-identifiers-generator"/]</em></p>

    <div id="long-description" class="slide-open">
      <em>[@message.print key="{description}external-identifiers-generator-long"/]</em>
    </div>

    <a href="#" class="slide-open-toggle" style="margin-bottom: 1.5rem !important; margin-top: 1rem;" data-spoiler="long-description" data-spoiler-storage-key="io.fusionauth.tenant.codeGeneratorDescription">
      <span>[@message.print key="{tell-me-more}external-identifiers-generator"/] <i class="fa fa-angle-down"></i></span>
    </a>

    [#assign flexStyle = "flex: 0 1 30%;"/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.changePasswordIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.changePasswordIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds" required=true  rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.emailVerificationIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.emailVerificationIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds" required=true  rightAddonRaw=rightAddonRaw style=flexStyle /]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.emailVerificationOneTimeCodeGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.emailVerificationOneTimeCodeGenerator.length" labelKey="tenant.externalIdentifierConfiguration.emailVerificationOneTimeCodeGenerator" required=true  rightAddonRaw=rightAddonRaw style=flexStyle /]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.passwordlessLoginGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.passwordlessLoginGenerator.length" labelKey="tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.registrationVerificationIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.registrationVerificationIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.registrationVerificationOneTimeCodeGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.registrationVerificationOneTimeCodeGenerator.length" labelKey="tenant.externalIdentifierConfiguration.registrationVerificationOneTimeCodeGenerator" required=true  rightAddonRaw=rightAddonRaw style=flexStyle /]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.setupPasswordIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.setupPasswordIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.deviceUserCodeIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.deviceUserCodeIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.deviceUserCode" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.twoFactorOneTimeCodeIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.twoFactorOneTimeCodeIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.twoFactorOneTimeCodeIdTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="smtp-settings"/]</legend>
    <p>[@message.print key="{description}smtp-settings-advanced"/]</p>
    [@control.textarea name="tenant.emailConfiguration.properties"/]
  </fieldset>

[/#macro]

[#macro generalConfiguration]
  <fieldset>
    [@control.text name="tenant.issuer" required=true placeholder=message.inline("{placeholder}tenant.issuer") tooltip=message.inline("{tooltip}tenant.issuer")/]
    [@control.select name="tenant.themeId" items=themes valueExpr="id" textExpr="name" tooltip=message.inline("{tooltip}tenant.themeId")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="form-settings"/]</legend>
    <p>[@message.print key="{description}form-settings"/]</p>
    [@control.select name="tenant.formConfiguration.adminUserFormId" items=forms valueExpr="id" textExpr="name" tooltip=function.message("{tooltip}tenant.formConfiguration.adminUserFormId")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="username-settings"/]</legend>
    <p>[@message.print key="{description}username-settings"/]</p>
    [@control.checkbox name="tenant.usernameConfiguration.unique.enabled" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.usernameConfiguration.unique.enabled") data_slide_open="username-unique-config"/]
    <div id="username-unique-config" class="slide-open [#if tenant.usernameConfiguration.unique.enabled] open[/#if]">
      [@control.select name="tenant.usernameConfiguration.unique.strategy" items=uniqueUsernameStrategies tooltip=message.inline("{tooltip}tenant.usernameConfiguration.unique.strategy")/]
      [@control.select name="tenant.usernameConfiguration.unique.numberOfDigits" items=[3,4,5,6,7,8,9,10] tooltip=message.inline("{tooltip}tenant.usernameConfiguration.unique.numberOfDigits")/]
      [@control.text name="tenant.usernameConfiguration.unique.separator" required=true  maxlength=1 placeholder=message.inline("{placeholder}tenant.usernameConfiguration.unique.separator") tooltip=message.inline("{tooltip}tenant.usernameConfiguration.unique.separator")/]
    </div>
  </fieldset>
[/#macro]

[#macro emailConfiguration action]
  <fieldset>
    <legend>[@message.print key="smtp-settings"/]</legend>
    <div style="display: flex;">
      <div class="top" style="flex-grow: 1">
        <p class="mt-0" style="margin-bottom: 20px;"><em>[@message.print key="{description}smtp-settings"/]</em></p>
      </div>
      <div style="flex-shrink: 1">
        [@button.iconLinkWithText href="/ajax/tenant/smtp/test?tenantId=${(tenant.id)!''}" id="send-test-email" color="blue" icon="send-o" textKey="send-test-email" class="push-left" ajaxForm=true /]
      </div>
    </div>
      [@control.text name="tenant.emailConfiguration.host" /]
      [@control.text name="tenant.emailConfiguration.port" /]
      [@control.text name="tenant.emailConfiguration.username" autocomplete="username"/]
      [#if action == "edit"]
        [@control.checkbox name="editPasswordOption" value="update" uncheckedValue="useExisting" data_slide_open="password-fields" tooltip=message.inline("{tooltip}editPasswordOption")/]
        <div id="password-fields" class="slide-open [#if editPasswordOption == "update"]open[/#if]">
          [@control.password name="tenant.emailConfiguration.password" value="" required=true autocomplete="new-password" /]
        </div>
      [#else]
        [#-- Add - just show the password field, it is optional --]
        [@control.password name="tenant.emailConfiguration.password" value="" required=false autocomplete="new-password" /]
      [/#if]

      [@control.select items=emailSecurityTypes name="tenant.emailConfiguration.security" tooltip=function.message("{tooltip}tenant.emailConfiguration.security")/]
      [@control.text name="tenant.emailConfiguration.defaultFromEmail" tooltip=message.inline("{tooltip}tenant.emailConfiguration.defaultFromEmail")/]
      [@control.text name="tenant.emailConfiguration.defaultFromName" tooltip=message.inline("{tooltip}tenant.emailConfiguration.defaultFromName")/]
      [@control.textarea name="additionalEmailHeaders" tooltip=function.message("{tooltip}additionalEmailHeaders")/]
      [@control.checkbox name="tenant.emailConfiguration.debug" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.emailConfiguration.debug")/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="email-verification-settings"/]</legend>
      [#if emailTemplates?? && emailTemplates?size gt 0]
        [@control.checkbox name="tenant.emailConfiguration.verifyEmail" value="true" uncheckedValue="false" data_slide_open="email-verification-settings" tooltip=function.message("{tooltip}tenant.emailConfiguration.verifyEmail")/]
        <div id="email-verification-settings"  class="slide-open [#if tenant.emailConfiguration.verifyEmail]open[/#if]">
          <fieldset>
            [@control.checkbox name="tenant.emailConfiguration.implicitEmailVerificationAllowed" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.emailConfiguration.implicitEmailVerificationAllowed")/]
            [@control.checkbox name="tenant.emailConfiguration.verifyEmailWhenChanged" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.emailConfiguration.verifyEmailWhenChanged")/]
            [@control.select items=emailTemplates name="tenant.emailConfiguration.verificationEmailTemplateId" valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" required=true/]
            [@control.select items=emailTemplates name="tenant.emailConfiguration.emailVerifiedEmailTemplateId" valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" /]
            [@control.select name="tenant.emailConfiguration.verificationStrategy" items=emailVerificationStrategies wideTooltip=function.message("{tooltip}tenant.emailConfiguration.verificationStrategy")/]
            [@control.select name="tenant.emailConfiguration.unverified.behavior" items=unverifiedEmailBehaviors data_slide_open="gated-settings" data_slide_open_value="Gated" tooltip=function.message("{tooltip}tenant.emailConfiguration.unverified.behavior")/]
            <div id="gated-settings" class="slide-open [#if tenant.emailConfiguration.unverified.behavior == "Gated"]open[/#if]">
              [@control.checkbox name="tenant.emailConfiguration.unverified.allowEmailChangeWhenGated" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.emailConfiguration.unverified.allowEmailChangeWhenGated")/]
            </div>
          </fieldset>
          <fieldset>
            [@control.checkbox name="tenant.userDeletePolicy.unverified.enabled" value="true" uncheckedValue="false" data_slide_open="delete-unverified-settings" tooltip=function.message("{tooltip}tenant.userDeletePolicy.unverified.enabled")/]
            <div id="delete-unverified-settings" class="slide-open [#if tenant.userDeletePolicy.unverified.enabled]open[/#if]">
              [@control.text name="tenant.userDeletePolicy.unverified.numberOfDaysToRetain" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.userDeletePolicy.unverified.numberOfDaysToRetain")/]
            </div>
          </fieldset>
        </div>
      [#else]
        [@control.hidden name="tenant.emailConfiguration.verifyEmail"/]
        [@control.hidden name="tenant.emailConfiguration.implicitEmailVerificationAllowed"/]
        [@control.hidden name="tenant.emailConfiguration.verifyEmailWhenChanged"/]
        [@control.hidden name="tenant.emailConfiguration.verificationStrategy"/]
        [@control.hidden name="tenant.emailConfiguration.unverified.behavior"/]
        [@control.hidden name="tenant.emailConfiguration.unverified.allowEmailChangeWhenGated"/]
        [@control.hidden name="tenant.userDeletePolicy.unverified.enabled"/]
        [@control.hidden name="tenant.userDeletePolicy.unverified.numberOfDaysToRetain"/]
        [@message.print key="no-email-templates"/]
      [/#if]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="template-settings"/]</legend>
    <p><em>[@message.print key="{description}template-settings"/]</em></p>
      [#assign templateNames = fusionAuth.statics['io.fusionauth.domain.EmailConfiguration'].EmailTemplateIdFieldNames/]
      [#assign disablesFeature = ["forgotPasswordEmailTemplateId", "setPasswordEmailTemplateId"]/]
      [#if emailTemplates?? && emailTemplates?size gt 0]
        [#list templateNames as templateName]
          [#-- The emailVerifiedEmailTemplateId & verificationEmailTemplateId are rendered in the previous section as part of email verification. --]
          [#if templateName != "emailVerifiedEmailTemplateId" && templateName != "verificationEmailTemplateId"]
            [#assign noneSelected = disablesFeature?seq_contains(templateName)?then("none-selected-email-template-disabled", "none-selected-email-template")/]
            [@control.select items=emailTemplates name="tenant.emailConfiguration.${templateName}" valueExpr="id" textExpr="name" headerValue="" headerL10n=noneSelected tooltip=function.message('{tooltip}tenant.emailConfiguration.${templateName}')/]
          [/#if]
        [/#list]
      [#else]
        [#list templateNames as templateName]
          [#-- The emailVerifiedEmailTemplateId & verificationEmailTemplateId are rendered in the previous section as part of email verification. --]
          [#if templateName != "emailVerifiedEmailTemplateId" && templateName != "verificationEmailTemplateId" ]
            [@control.hidden name="tenant.emailConfiguration.${templateName}"/]
          [/#if]
        [/#list]
        [@message.print key="no-email-templates"/]
      [/#if]
  </fieldset>
[/#macro]

[#macro familyConfiguration]
  <legend>[@message.print key="family-settings"/]</legend>
    <p><em>[@message.print key="{description}family-settings"/]</em></p>
  <fieldset>
    [@control.checkbox name="tenant.familyConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="family-configuration-options"/]
    <div id="family-configuration-options" class="slide-open [#if tenant.familyConfiguration.enabled]open[/#if]">
      [@control.text name="tenant.familyConfiguration.maximumChildAge" required=true tooltip=function.message('{tooltip}tenant.familyConfiguration.maximumChildAge')/]
      [@control.text name="tenant.familyConfiguration.minimumOwnerAge" required=true tooltip=function.message('{tooltip}tenant.familyConfiguration.minimumOwnerAge')/]
      [@control.checkbox name="tenant.familyConfiguration.allowChildRegistrations" value="true" uncheckedValue="false" required=true tooltip=function.message('{tooltip}tenant.familyConfiguration.allowChildRegistrations') data_slide_open="child-regsitration" data_slide_closed="no-child-registration"/]
      <div id="no-child-registration" class="slide-open [#if !tenant.familyConfiguration.allowChildRegistrations]open[/#if]">
        [@control.select name="tenant.familyConfiguration.familyRequestEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.familyConfiguration.familyRequestEmailTemplateId')/]
      </div>
      <div id="child-registration" class="slide-open [#if tenant.familyConfiguration.allowChildRegistrations]open[/#if]">
        [@control.select name="tenant.familyConfiguration.confirmChildEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.familyConfiguration.confirmChildEmailTemplateId')/]
        [@control.select name="tenant.familyConfiguration.parentRegistrationEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.familyConfiguration.parentRegistrationEmailTemplateId')/]
        [@control.checkbox name="tenant.familyConfiguration.parentEmailRequired" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.familyConfiguration.parentEmailRequired')/]
      </div>
      [@control.checkbox name="tenant.familyConfiguration.deleteOrphanedAccounts" value="true" uncheckedValue="false" data_slide_open="delete-orphaned-settings" tooltip=function.message("{tooltip}tenant.familyConfiguration.deleteOrphanedAccounts")/]
      <div id="delete-orphaned-settings" class="slide-open [#if tenant.familyConfiguration.deleteOrphanedAccounts]open[/#if]">
        [@control.text name="tenant.familyConfiguration.deleteOrphanedAccountsDays" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.familyConfiguration.deleteOrphanedAccountsDays")/]
      </div>
    </div>
  </fieldset>
[/#macro]

[#macro mfaConfiguration]
  <fieldset>
    <p><em>[@message.print key="{description}multi-factor-settings"/]</em></p>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="multi-factor-policies"/]</legend>
    <p><em>[@message.print key="{description}multi-factor-policies"/]</em></p>
    [@control.select name="tenant.multiFactorConfiguration.loginPolicy" items=multiFactorLoginPolicies![] tooltip=function.message("{tooltip}tenant.multiFactorConfiguration.loginPolicy")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="multi-factor-authenticator-settings"/]</legend>
    <p><em>[@message.print key="{description}multi-factor-authenticator-settings"/]</em></p>
    [@control.checkbox name="tenant.multiFactorConfiguration.authenticator.enabled" value="true" uncheckedValue="false" /]
  </fieldset>
  <fieldset>
     <legend>[@message.print key="multi-factor-email-settings"/]</legend>
     <p><em>[@message.print key="{description}multi-factor-email-settings"/]</em></p>
    [@control.checkbox name="tenant.multiFactorConfiguration.email.enabled" value="true" uncheckedValue="false" data_slide_open="multi-factor-email" /]
    <div id="multi-factor-email" class="slide-open [#if tenant.multiFactorConfiguration.email.enabled]open[/#if]">
      [@control.select name="tenant.multiFactorConfiguration.email.templateId" items=emailTemplates![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="selection-required" tooltip=function.message("{tooltip}tenant.multiFactorConfiguration.email.templateId")/]
    </div>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="multi-factor-sms-settings"/]</legend>
     <p><em>[@message.print key="{description}multi-factor-sms-settings"/]</em></p>
    [@control.checkbox name="tenant.multiFactorConfiguration.sms.enabled" value="true" uncheckedValue="false" data_slide_open="multi-factor-sms" /]
    <div id="multi-factor-sms" class="slide-open [#if tenant.multiFactorConfiguration.sms.enabled]open[/#if]">
      [@control.select name="tenant.multiFactorConfiguration.sms.messengerId" items=messengers![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="selection-required"/]
      [@control.select name="tenant.multiFactorConfiguration.sms.templateId" items=smsMessageTemplates![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="selection-required" tooltip=function.message("{tooltip}tenant.multiFactorConfiguration.sms.templateId")/]
    </div>
  </fieldset>
[/#macro]

[#macro webauthnConfiguration]
<p class="mt-0 mb-4">
  <em>[@message.print key="{description}webauthn-settings"/]</em>
</p>
<fieldset>
  [@control.checkbox name="tenant.webAuthnConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="additional-webauthn-options"/]
</fieldset>
<div id="additional-webauthn-options" class="slide-open [#if tenant.webAuthnConfiguration.enabled]open[/#if]">
  <fieldset>
    [@control.text name="tenant.webAuthnConfiguration.relyingPartyId" tooltip=message.inline("{tooltip}tenant.webAuthnConfiguration.relyingPartyId")/]
    [@control.text name="tenant.webAuthnConfiguration.relyingPartyName" placeholder="${tenant.issuer!''}" tooltip=message.inline("{tooltip}tenant.webAuthnConfiguration.relyingPartyName")/]
    [@control.checkbox name="tenant.webAuthnConfiguration.debug" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.webAuthnConfiguration.debug")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="webauthn-bootstrap-settings"/]</legend>
    <p><em>[@message.print key="{description}webauthn-bootstrap-settings"/]</em></p>
    [@control.checkbox name="tenant.webAuthnConfiguration.bootstrapWorkflow.enabled" value="true" uncheckedValue="false"/]
    [@control.select items=webauthnAuthenticatorAttachments name="tenant.webAuthnConfiguration.bootstrapWorkflow.authenticatorAttachmentPreference" wideTooltip=function.message("{tooltip}tenant.webAuthnConfiguration.bootstrapWorkflow.authenticatorAttachmentPreference") /]
    [@control.select items=webauthnUserVerificationRequirements name="tenant.webAuthnConfiguration.bootstrapWorkflow.userVerificationRequirement" wideTooltip=function.message("{tooltip}tenant.webAuthnConfiguration.userVerificationRequirement") /]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="webauthn-reauthentication-settings"/]</legend>
    <p><em>[@message.print key="{description}webauthn-reauthentication-settings"/]</em></p>
    [@control.checkbox name="tenant.webAuthnConfiguration.reauthenticationWorkflow.enabled" value="true" uncheckedValue="false"/]
    [@control.select items=webauthnAuthenticatorAttachments name="tenant.webAuthnConfiguration.reauthenticationWorkflow.authenticatorAttachmentPreference" wideTooltip=function.message("{tooltip}tenant.webAuthnConfiguration.reauthenticationWorkflow.authenticatorAttachmentPreference") /]
    [@control.select items=webauthnUserVerificationRequirements name="tenant.webAuthnConfiguration.reauthenticationWorkflow.userVerificationRequirement" wideTooltip=function.message("{tooltip}tenant.webAuthnConfiguration.userVerificationRequirement") /]
  </fieldset>
</div>
[/#macro]

[#macro passwordConfiguration]
  <fieldset>
    <legend>[@message.print key="failed-login-settings"/]</legend>
    <p><em>[@message.print key="{description}failed-login-settings"/]</em></p>
    [@control.select items=failedAuthenticationUserActions name="tenant.failedAuthenticationConfiguration.userActionId" selected=tenant.failedAuthenticationConfiguration.userActionId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-user-action" tooltip=function.message('{tooltip}tenant.failedAuthenticationConfiguration.userActionId')/]
    <div id="failed-authentication-options" class="slide-open [#if (tenant.failedAuthenticationConfiguration.userActionId??)!false]open[/#if]">
      [@control.text name="tenant.failedAuthenticationConfiguration.tooManyAttempts" tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.tooManyAttempts") autocapitalize="none" autocorrect="off" required=true/]
      [@control.text name="tenant.failedAuthenticationConfiguration.resetCountInSeconds" rightAddonText="${function.message('SECONDS')}" tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.resetCountInSeconds") autocapitalize="none" autocorrect="off" required=true/]
      [@control.text name="tenant.failedAuthenticationConfiguration.actionDuration" tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.actionDuration") autocapitalize="none" autocorrect="off" required=true/]
      [@control.select items=expiryUnits name="tenant.failedAuthenticationConfiguration.actionDurationUnit"/]
      [@control.checkbox name="tenant.failedAuthenticationConfiguration.actionCancelPolicy.onPasswordReset" value="true" uncheckedValue="false"  tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.actionCancelPolicy.onPasswordReset") /]
      [@control.checkbox name="tenant.failedAuthenticationConfiguration.emailUser" value="true" uncheckedValue="false"  tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.emailUser") /]
    </div>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="breached-password-detection-settings"/]</legend>
    <div style="display: flex;" class="mb-3">
      <div style="margin-right: 10px;">
        <img src="/images/icon-reactor-gray.svg" alt="FusionAuth Reactor Logo" width="42">
      </div>
      <div style="flex: 1;"><em>[@message.print key="{description}breached-password-detection-settings"/]</em></div>
     </div>
    [@control.checkbox name="tenant.passwordValidationRules.breachDetection.enabled" value="true" uncheckedValue="false"  data_slide_open="tenant_passwordBreach"/]
    <div id="tenant_passwordBreach" class="slide-open [#if tenant.passwordValidationRules.breachDetection.enabled]open[/#if]">
      [@control.select items=breachMatchModes name="tenant.passwordValidationRules.breachDetection.matchMode" wideTooltip=function.message("{tooltip}tenant.passwordValidationRules.breachDetection.matchMode") /]
      [@control.select items=breachActions name="tenant.passwordValidationRules.breachDetection.onLogin" data_slide_open="breach_action_notifyUser" data_slide_open_value="NotifyUser" tooltip=function.message("{tooltip}tenant.passwordValidationRules.breachDetection.onLogin")/]
      <div id="breach_action_notifyUser" class="slide-open [#if (tenant.passwordValidationRules.breachDetection.onLogin == "NotifyUser")!false]open[/#if]">
        [@control.select items=emailTemplates name="tenant.passwordValidationRules.breachDetection.notifyUserEmailTemplateId" valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" required=true tooltip=function.message("{tooltip}tenant.passwordValidationRules.breachDetection.notifyUserEmailTemplateId") /]
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="password-settings"/]</legend>
    <p><em>[@message.print key="{description}password-settings"/]</em></p>
    [@control.text name="tenant.passwordValidationRules.minLength" autocapitalize="none" autocorrect="off" required=true/]
    [@control.text name="tenant.passwordValidationRules.maxLength" autocapitalize="none" autocorrect="off" required=true/]
    [@control.checkbox name="tenant.passwordValidationRules.requireMixedCase" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.requireMixedCase')/]
    [@control.checkbox name="tenant.passwordValidationRules.requireNonAlpha" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.requireNonAlpha')/]
    [@control.checkbox name="tenant.passwordValidationRules.requireNumber" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.requireNumber')/]
    [@control.checkbox name="tenant.minimumPasswordAge.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.minimumPasswordAge.enabled') data_slide_open="tenant_minimumPasswordAge"/]
    <div id="tenant_minimumPasswordAge" class="slide-open [#if tenant.minimumPasswordAge.enabled]open[/#if]">
      [@control.text name="tenant.minimumPasswordAge.seconds" rightAddonText="${function.message('SECONDS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.minimumPasswordAge.seconds")/]
    </div>
    [@control.checkbox name="tenant.maximumPasswordAge.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.maximumPasswordAge.enabled') data_slide_open="tenant_maximumPasswordAge"/]
    <div id="tenant_maximumPasswordAge" class="slide-open [#if tenant.maximumPasswordAge.enabled]open[/#if]">
      [@control.text name="tenant.maximumPasswordAge.days" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message('{tooltip}tenant.maximumPasswordAge.days')/]
    </div>
    [@control.checkbox name="tenant.passwordValidationRules.rememberPreviousPasswords.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.rememberPreviousPasswords.enabled') data_slide_open="tenant_passwordValidationRules_previousPasswords"/]
    <div id="tenant_passwordValidationRules_previousPasswords" class="slide-open [#if tenant.passwordValidationRules.rememberPreviousPasswords.enabled]open[/#if]">
      [@control.text name="tenant.passwordValidationRules.rememberPreviousPasswords.count" autocapitalize="none" autocorrect="off" required=true/]
    </div>
    [@control.checkbox name="tenant.passwordValidationRules.validateOnLogin" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.passwordValidationRules.validateOnLogin")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="password-encryption-settings"/]</legend>
    <p><em>[@message.print key="{description}password-encryption-settings"/]</em></p>
    [@control.select items=passwordEncryptors name="tenant.passwordEncryptionConfiguration.encryptionScheme" tooltip=function.message("{tooltip}tenant.passwordEncryptionConfiguration.encryptionScheme")/]
    [@control.text name="tenant.passwordEncryptionConfiguration.encryptionSchemeFactor" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.passwordEncryptionConfiguration.encryptionSchemeFactor")/]
    [@control.checkbox name="tenant.passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin")/]
  </fieldset>
[/#macro]

[#macro jwtConfiguration]
  <fieldset>
    <legend>[@message.print key="jwt-settings"/]</legend>
    <p><em>[@message.print key="{description}jwt-settings"/]</em></p>
    [@control.text name="tenant.jwtConfiguration.timeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.jwtConfiguration.timeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}jwtConfiguration.timeToLiveInSeconds')/]
    [@control.select name="tenant.jwtConfiguration.accessTokenKeyId" items=accessTokenKeys![] required=false valueExpr="id" textExpr="displayName" tooltip=function.message('{tooltip}jwtConfiguration.accessTokenKeyId')/]
    [@control.select name="tenant.jwtConfiguration.idTokenKeyId" items=keys![] required=false valueExpr="id" textExpr="displayName" tooltip=function.message('{tooltip}jwtConfiguration.idTokenKeyId')/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="refresh-token-settings"/]</legend>
    <p><em>[@message.print key="{description}refresh-token-settings"/]</em></p>
    [@control.select name="tenant.jwtConfiguration.refreshTokenExpirationPolicy" items=refreshTokenExpirationPolicies wideTooltip=function.message('{tooltip}jwtConfiguration.refreshTokenExpirationPolicy') data_slide_open="sliding-window-max-ttl" data_slide_open_value="SlidingWindowWithMaximumLifetime"/]
    [@control.text name="tenant.jwtConfiguration.refreshTokenTimeToLiveInMinutes" title="${helpers.approximateFromMinutes(tenant.jwtConfiguration.refreshTokenTimeToLiveInMinutes)}" rightAddonText="${function.message('MINUTES')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenTimeToLiveInMinutes')/]
    <div id="sliding-window-max-ttl" class="slide-open ${(tenant.jwtConfiguration.refreshTokenExpirationPolicy == "SlidingWindowWithMaximumLifetime")?then('open', '')}">
      [@control.text name="tenant.jwtConfiguration.refreshTokenSlidingWindowConfiguration.maximumTimeToLiveInMinutes" required=true title="${helpers.approximateFromMinutes(tenant.jwtConfiguration.refreshTokenSlidingWindowConfiguration.maximumTimeToLiveInMinutes!0)}" rightAddonText="${function.message('MINUTES')}" required=false tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenSlidingWindowConfiguration.maximumTimeToLiveInMinutes')/]
    </div>
    [@control.select name="tenant.jwtConfiguration.refreshTokenUsagePolicy" items=refreshTokenUsagePolicies tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenUsagePolicy')/]
    [@helpers.booleanCheckboxList id="tenant_jwtConfiguration_refreshTokenRevocationPolicy" name="tenant.jwtConfiguration.refreshTokenRevocationPolicy" values=["onLoginPrevented", "onMultiFactorEnable", "onPasswordChanged"] tooltip=message.inline("{tooltip}jwtConfiguration.refreshTokenRevocationPolicy")/]
  </fieldset>
[/#macro]

[#macro securityConfiguration]
  <fieldset>
    <legend>[@message.print key="login-settings"/]</legend>
    <p><em>[@message.print key="{description}login-settings"/]</em></p>
    [@control.checkbox name="tenant.loginConfiguration.requireAuthentication" value="true" uncheckedValue="false" wideTooltip=function.message("{tooltip}tenant.loginConfiguration.requireAuthentication")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="access-control-lists-settings"/]</legend>
    <p><em>[@message.print key="{description}access-control-lists-settings"/]</em></p>
    [@control.select name="tenant.accessControlConfiguration.uiIPAccessControlListId" items=ipAccessControlLists tooltip=function.message('{tooltip}tenant.accessControlConfiguration.uiIPAccessControlListId') valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-access-control-list" /]
  </fieldset>
  <fieldset>
     <legend>[@message.print key="captcha-settings"/]</legend>
     <p><em>[@message.print key="{description}captcha-settings"/]</em></p>
    [@control.checkbox name="tenant.captchaConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="threat-detection-captcha" /]
    <div id="threat-detection-captcha" class="slide-open [#if tenant.captchaConfiguration.enabled]open[/#if]">
      [@control.select name="tenant.captchaConfiguration.captchaMethod" items=captchaMethods tooltip=function.message('{tooltip}tenant.captchaConfiguration.captchaMethod')/]
      [@control.text name="tenant.captchaConfiguration.siteKey" required=true tooltip=function.message('{tooltip}tenant.captchaConfiguration.siteKey')/]
      [@control.text name="tenant.captchaConfiguration.secretKey" required=true tooltip=function.message('{tooltip}tenant.captchaConfiguration.secretKey')/]
      [@control.text name="tenant.captchaConfiguration.threshold" tooltip=function.message('{tooltip}tenant.captchaConfiguration.threshold')/]
    </div>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="device-trust-settings"/]</legend>
    [@control.text name="tenant.ssoConfiguration.deviceTrustTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.ssoConfiguration.deviceTrustTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.ssoConfiguration.deviceTrustTimeToLiveInSeconds')/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="blocked-domains-settings"/]</legend>
    <p><em>[@message.print key="{description}blocked-domains-settings"/]</em></p>
    [@control.textarea name="blockedDomains" tooltip=message.inline("{tooltip}blockedDomains")/]
  </fieldset>
  <fieldset >
    <legend>[@message.print key="rate-limit-settings"/]</legend>
    <p><em>[@message.print key="{description}rate-limit-settings"/]</em></p>
    <table class="hover tight-right">
      <thead>
      <tr>
        <th>[@message.print key="rate-limiting-action"/]</th>
        <th>[@message.print key="enabled"/]</a></th>
        <th>[@message.print key="rate-limiting-limit"/]</th>
        <th>[@message.print key="rate-limiting-time"/]</th>
      </tr>
      </thead>
      <tbody>
        [#list ["failedLogin", "forgotPassword", "sendEmailVerification", "sendPasswordless", "sendRegistrationVerification", "sendTwoFactor"] as rateLimit]
         <tr>
          [#local ttl = ("((tenant.rateLimitConfiguration." + rateLimit + ".timePeriodInSeconds)!'')")?eval /]
          [#assign tooltipKey = "{tooltip}tenant.rateLimitConfiguration.${rateLimit}"/]
          <td>[@message.print key="tenant.rateLimitConfiguration.${rateLimit}"/] <label><i class="fa fa-info-circle" data-tooltip="${message.inline(tooltipKey)}"></i></label></td>
          <td>[@control.checkbox name="tenant.rateLimitConfiguration.${rateLimit}.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td>[@control.text name="tenant.rateLimitConfiguration.${rateLimit}.limit" labelKey="empty" includeFormRow=false/]</td>
          <td>[@control.text name="tenant.rateLimitConfiguration.${rateLimit}.timePeriodInSeconds" labelKey="empty" includeFormRow=false title="${helpers.approximateFromSeconds(ttl)}" rightAddonText="${function.message('SECONDS')}"/]</td>
         </tr>
        [/#list]
      </tbody>
    </table>
  </fieldset>
[/#macro]

[#macro scimConfiguration]
  <fieldset>
    <legend>[@message.print key="scim-server-settings"/]</legend>
    <p><em>[@message.print key="{description}scim-server-settings"/]</em></p>
    [@control.checkbox name="tenant.scimServerConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="scim-server-config"/]
    <div id="scim-server-config" class="slide-open [#if tenant.scimServerConfiguration.enabled] open[/#if]">
      <fieldset>
        [@control.select name="tenant.scimServerConfiguration.clientEntityTypeId" items=entityTypes![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-scim-client-entity-type-required" tooltip=function.message('{tooltip}tenant.scimServerConfiguration.clientEntityTypeId') /]
        [@control.select name="tenant.scimServerConfiguration.serverEntityTypeId" items=entityTypes![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-scim-server-entity-type-required" tooltip=function.message('{tooltip}tenant.scimServerConfiguration.serverEntityTypeId') /]
      </fieldset>
      <fieldset>
        [@control.select name="tenant.lambdaConfiguration.scimUserRequestConverterId" items=scimUserRequestLambdas![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-required" tooltip=function.message('{tooltip}tenant.lambdaConfiguration.scimUserRequestConverterId') /]
        [@control.select name="tenant.lambdaConfiguration.scimUserResponseConverterId" items=scimUserResponseLambdas![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-required" tooltip=function.message('{tooltip}tenant.lambdaConfiguration.scimUserResponseConverterId') /]
        [@control.select name="tenant.lambdaConfiguration.scimEnterpriseUserRequestConverterId" items=scimUserRequestLambdas![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-required" tooltip=function.message('{tooltip}tenant.lambdaConfiguration.scimEnterpriseUserRequestConverterId') /]
        [@control.select name="tenant.lambdaConfiguration.scimEnterpriseUserResponseConverterId" items=scimUserResponseLambdas![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-required"  tooltip=function.message('{tooltip}tenant.lambdaConfiguration.scimEnterpriseUserResponseConverterId') /]
        [@control.select name="tenant.lambdaConfiguration.scimGroupRequestConverterId" items=scimGroupRequestLambdas![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-required" tooltip=function.message('{tooltip}tenant.lambdaConfiguration.scimGroupRequestConverterId') /]
        [@control.select name="tenant.lambdaConfiguration.scimGroupResponseConverterId" items=scimGroupResponseLambdas![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-required" tooltip=function.message('{tooltip}tenant.lambdaConfiguration.scimGroupResponseConverterId') /]
      </fieldset>
      <fieldset>
        [@control.textarea name="scimSchemas" placeholder=function.message('{placeholder}tenant.scimServerConfiguration.schemas') tooltip=function.message('{tooltip}tenant.scimServerConfiguration.schemas') /]
      </fieldset>
    </div>
  </fieldset>
[/#macro]
