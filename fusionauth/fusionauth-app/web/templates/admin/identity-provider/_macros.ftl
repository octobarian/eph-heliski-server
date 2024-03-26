[#ftl/]
[#-- @ftlvariable name="applications" type="io.fusionauth.domain.Application[]" --]
[#-- @ftlvariable name="c14nMethods" type="io.fusionauth.domain.CanonicalizationMethod[]" --]
[#-- @ftlvariable name="clientAuthenticationMethods" type="java.util.List<io.fusionauth.domain.provider.IdentityProviderOauth2Configuration.ClientAuthenticationMethod>" --]
[#-- @ftlvariable name="defaultIdentityProviderTenantConfiguration" type="io.fusionauth.domain.provider.IdentityProviderTenantConfiguration" --]
[#-- @ftlvariable name="domains" type="java.lang.String" --]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]
[#-- @ftlvariable name="identityProviders" type="java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider>" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider>" --]
[#-- @ftlvariable name="lambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="loginMethods" type="io.fusionauth.domain.provider.IdentityProviderLoginMethod[]" --]
[#-- @ftlvariable name="linkingStrategies" type="io.fusionauth.domain.provider.IdentityProviderLinkingStrategy[]" --]
[#-- @ftlvariable name="redirectURL" type="java.lang.String" --]
[#-- @ftlvariable name="steamAPIModes" type="io.fusionauth.domain.provider.SteamAPIMode[]" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.provider.IdentityProviderType" --]
[#-- @ftlvariable name="useOppenIdDiscovery" type="boolean" --]
[#-- @ftlvariable name="destinationAssertionPolicies" type="io.fusionauth.domain.SAMLv2DestinationAssertionPolicy[]"--]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro externalJWTFields identityProvider domains action]
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="externaljwt-enabled-settings"/]
  <div id="externaljwt-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
    [#if action=="edit"]
      [@control.hidden name="identityProviderId"/]
      [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
    [#else]
      [@control.text name="identityProviderId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}id')/]
    [/#if]
    [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" required=true tooltip=message.inline('{tooltip}displayOnly')/]
    [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
    [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
    [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print "applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
        <li><a href="#jwt">[@message.print key="jwt"/]</a></li>
        <li><a href="#domains">[@message.print key="managed-domains"/]</a></li>
        <li><a href="#claims">[@message.print "claim-mapping"/]</a></li>
        <li><a href="#oauth2">[@message.print "oauth2"/]</a></li>
      </ul>
    </div>

    <div id="jwt" class="hidden">
      <fieldset>
        [@control.text name="identityProvider.oauth2.uniqueIdClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.uniqueIdClaim')/]
        [@control.text name="identityProvider.oauth2.emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.emailClaim')/]
        [@control.text name="identityProvider.oauth2.emailVerifiedClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.emailVerifiedClaim')/]
        [@control.text name="identityProvider.oauth2.usernameClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.usernameClaim')/]
      </fieldset>

      <fieldset>
        [@control.text name="identityProvider.headerKeyParameter" autocapitalize="none" autocomplete="on" autocorrect="off" placeholder=message.inline('{placeholder}identityProvider.headerKeyParameter') tooltip=message.inline('{tooltip}identityProvider.headerKeyParameter')/]
        [@control.select name="identityProvider.defaultKeyId" items=keys![] valueExpr="id" textExpr="name" headerL10n="no-default-selected" headerValue="" tooltip=message.inline('{tooltip}identityProvider.defaultKeyId') /]
      </fieldset>

      <fieldset>
        <legend>[@message.print key="deprecated"/]</legend>
        <p><em>[@message.print key="{description}uniqueIdClaim-deprecated"/]</em></p>
        [@control.text name="identityProvider.uniqueIdentityClaim" autocapitalize="none" autocomplete="on" autocorrect="off" tooltip=message.inline('{tooltip}identityProvider.uniqueIdentityClaim')/]
      </fieldset>
    </div>

    <div id="domains" class="hidden">
      <p class="mt-0"><em>[@message.print key="{description}external-jwt-domains"/]</em></p>
      <fieldset>
      [@control.textarea name="domains" labelKey="empty"/]
      </fieldset>
    </div>

    <div id="oauth2" class="hidden">
      <p><em>[@message.print key="{description}oauth2"/]</em></p>
      <field>
      [@control.text name="identityProvider.oauth2.authorization_endpoint" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}identityProvider.oauth2.authorization_endpoint')/]
      [@control.text name="identityProvider.oauth2.token_endpoint" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}identityProvider.oauth2.token_endpoint')/]
      </field>
    </div>

    <div id="applications" class="hidden">
      <table class="hover">
        <thead>
        <tr>
          <th>[@message.print key="name"/]</th>
          [#if tenants?size > 1]
            <th class="hide-on-mobile">[@message.print key="tenant"/]</th>
          [/#if]
          <th>[@message.print key="enabled"/]</th>
          <th>[@message.print key="create-registration"/]</th>
        </tr>
        </thead>
        <tbody>
        [#list applications as application]
        [#local id = application.id/]
         [#if application.state == "Active"]
         <tr>
           <td>${properties.display(application, "name")}</td>
           [#if tenants?size > 1]
             <td class="hide-on-mobile"> ${helpers.tenantName(application.tenantId)}</td>
           [/#if]
           <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].enabled" labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false /]</td>
           [#-- Do not allow createRegistration for the FusionAuth Application --]
           <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].createRegistration" labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false disabled=(id == fusionAuthId)/]</td>
         </tr>
         [#else]
           [@control.hidden name="identityProvider.applicationConfiguration[${id}].enabled" /]
           [@control.hidden name="identityProvider.applicationConfiguration[${id}].createRegistration" /]
         [/#if]
        [/#list]
        </tbody>
      </table>
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

    <div id="claims" class="hidden">
      <fieldset>
          <p><em>[@message.print key="{description}claim-mapping"/]</em></p>
          <table id="claims-map-table" data-template="claim-map-template">
            <thead>
            <tr>
                <th>[@message.print key="claim-key"/]</th>
                <th>[@message.print key="claim-value"/]</th>
                <th data-sortable="false" class="action">[@message.print key="action"/]</th>
              </tr>
            </thead>
            <tbody>
              <tr class="empty-row">
                <td colspan="3">[@message.print key="no-claims"/]</td>
              </tr>
              [#list identityProvider.claimMap as incomingClaim, fusionAuthClaim]
              <tr data-incoming-claim="${(incomingClaim)!}" data-fusionauth-claim="${fusionAuthClaim}">
                <td>
                  ${incomingClaim}
                  <input id="identityProviders.claimMap_${incomingClaim}" type="hidden" name="identityProvider.claimMap['${incomingClaim}']" value="${fusionAuthClaim}"/>
                </td>
                <td>
                  ${fusionAuthClaim}
                </td>
                <td class="action">
                  [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
                </td>
              </tr>
              [/#list]
              </tbody>
            </table>
      </fieldset>
      <fieldset>
        [@button.iconLinkWithText href="/ajax/identity-provider/claim/add" textKey="{button}add-claim" id="add-claim" icon="plus" identityProviderId="${(identityProvider.id)!''}"/]
      </fieldset>
      <script id="claim-map-template" type="text/x-handlebars-template">
          <tr>
            <td>
              {{incomingClaim}}
              <input id="identityProviders.claimMap_{{incomingClaim}}" type="hidden" name="identityProvider.claimMap['{{incomingClaim}}']" value="{{fusionAuthClaim}}"/>
            </td>
            <td>
              {{fusionAuthClaim}}
            </td>
            <td class="action">
            [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
            </td>
          </tr>
        </script>
    </div>
  </div>

  <div id="key-view" class="prime-dialog hidden wide">
    [@dialog.view titleKey="view-key"]
      <div class="mt-2">
        [@properties.table]
          <tr>
            <td class="top no-wrap">
              [@message.print key="label.keyId"/]
              [@message.print key="propertySeparator"/]
            </td>
            <td class="top" id="view-key-id"></td>
          </tr>
          <tr>
            <td class="top no-wrap">
              [@message.print key="label.encodedKey"/]
              [@message.print key="propertySeparator"/]
            </td>
            <td><pre class="code not-pushed" id="view-encoded-key"></pre></td>
          </tr>
        [/@properties.table]
      </div>
    [/@dialog.view]
  </div>

[/#macro]

[#macro socialAppConfig identityProvider showOverride=true showLegend=true]
  <fieldset>
    [#if showLegend]
      <legend>[@message.print key="applications"/]</legend>
    [/#if]
    <table class="hover">
      <thead>
      <tr>
        <th>[@message.print key="name"/]</th>
        [#if tenants?size > 1]
          <th class="hide-on-mobile">[@message.print key="tenant"/]</th>
        [/#if]
        <th>[@message.print key="enabled"/]</th>
        <th>[@message.print key="create-registration"/]</th>
        <th></th>
      </tr>
      </thead>
      <tbody>
        [#list applications as application]
          [#local id = application.id/]
          [#if application.state == "Active"]
            <tr>
              <td>${properties.display(application, "name")}</td>
              [#if tenants?size > 1]
                <td class="hide-on-mobile"> ${helpers.tenantName(application.tenantId)}</td>
              [/#if]
              <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].enabled" labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false /]</td>
              [#-- Default enabled for new configurations, except for FusionAuth, default to disabled. The end user has to opt-in and enable this capability. --]
              [#local createRegistrationChecked = id != fusionAuthId ]
              [#if identityProvider.applicationConfiguration(id)??]
                [#local createRegistrationChecked = identityProvider.applicationConfiguration(id).createRegistration/]
              [/#if]
              <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].createRegistration" checked=createRegistrationChecked labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false /]</td>
              <td class="text-right">
              [#if showOverride]
                <a href="#" class="slide-open-toggle" data-expand-open="${id}-advanced">
                  <div><i class="fa fa-angle-right"></i>&nbsp;[@message.print key="overrides"/]</div>
                </a>
              [/#if]
              </td>
            </tr>

            <tr class="advanced">
             [#if showOverride]
              <td colspan="4">
                <div id="${id}-advanced" class="slide-open">
                  [#nested id application.state == "Active"/]
                </div>
              </td>
             [/#if]
            </tr>
          [#else]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].enabled" /]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].createRegistration" /]
            [#nested id application.state == "Active"/]
          [/#if]
        [/#list]
      </tbody>
    </table>
  </fieldset>
[/#macro]

[#macro socialTenantConfig identityProvider]
<fieldset>
  <table class="hover" id="idp-tenant-config-table" data-template="idp-tenant-config-row-template" data-add-button="idp-tenant-config-add-button" data-default-max-count="${defaultIdentityProviderTenantConfiguration.limitUserLinkCount.maximumLinks}" data-no-results="${message.inline('no-search-results')}">
    <thead>
      <tr>
        <th>[@message.print key="name"/]</th>
        <th>[@message.print key="id"/]</th>
        <th>[@message.print key="limit-user-links"/]</th>
        <th>[@message.print key="max-link-count"/]</th>
        <th class="action">[@message.print key="action"/]</th>
      </tr>
    </thead>
    <tbody>
    <tr class="empty-row">
      <td colspan="3">[@message.print key="no-ip-tenant-configuration"/]</td>
    </tr>
    [#list identityProvider.tenantConfiguration as tenantId, tenantConfiguragion]
        <tr data-tenant-id="${tenantId}">
          <td style="width: 25%;">${properties.display(tenants(tenantId), "name")}</td>
          <td>${tenantId}</td>
          <td class="icon">[@control.checkbox name="identityProvider.tenantConfiguration[${tenantId}].limitUserLinkCount.enabled" value="true" uncheckedValue="false" labelKey="empty" tooltip=message.inline('{tooltip}identityProvider.tenantConfiguration.limitUserLinkCount.enabled') includeFormRow=false/]</td>
          <td>[@control.text name="identityProvider.tenantConfiguration[${tenantId}].limitUserLinkCount.maximumLinks" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="empty" tooltip=message.inline('{tooltip}identityProvider.tenantConfiguration.limitUserLinkCount.maximumLinks') includeFormRow=false/]</td>
          <td class="action">
            [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
          </td>
        </tr>
    [/#list]
    </tbody>
  </table>
  <script type="x-handlebars" id="idp-tenant-config-row-template">
    <tr>
      <td style="width: 25%;">
        <input type="text" placeholder="Search" class="tenant-search" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" />
        <input type="hidden" class="tenant-search-hidden"/>
        </td>
      <td>&ndash;</td>
      <td class="icon">
        <input type="hidden" name="__cb_identityProvider.tenantConfiguration[].limitUserLinkCount.enabled" value="false">
        <label class="toggle">
          <input type="checkbox" id="identityProvider_tenantConfiguration[]_limitUserLinkCount_enabled" name="identityProvider.tenantConfiguration[].limitUserLinkCount.enabled" value="true" tooltip="${message.inline('{tooltip}identityProvider.tenantConfiguration.limitUserLinkCount.enabled')}">
          <span class="rail"></span>
          <span class="pin"></span>
        </label>
      </td>
      <td><input type="text" name="identityProvider.tenantConfiguration[].limitUserLinkCount.maximumLinks" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" /></td>
      <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
    </tr>
  </script>
  [@button.iconLinkWithText href="#" color="blue" id="idp-tenant-config-add-button" icon="plus" textKey="{button}add-tenant-configuration"/]
</fieldset>
[/#macro]

[#macro appleFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}apple-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="apple-enabled-settings"/]
  <div id="apple-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.bundleId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.bundleId')/]
      [@control.text name="identityProvider.servicesId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.servicesId')/]
      [@control.text name="identityProvider.teamId" autocapitalize="on" autocomplete="on" autocorrect="on" required=true tooltip=message.inline('{tooltip}identityProvider.teamId')/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}appleButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.scope')/]
      [@control.select name="identityProvider.keyId" items=keys![] valueExpr="id" textExpr="name" headerValue="" headerL10n="select-apple-private-key" labelKey="identityProvider.signingKeyId" required=true tooltip=message.inline('{tooltip}identityProvider.signingKeyId')/]
     </fieldset>
     <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
       <li><a href="#applications">[@message.print key="applications"/]</a></li>
       <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].bundleId" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.bundleId" tooltip=message.inline('{tooltip}identityProvider.bundleId')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].servicesId" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.servicesId" tooltip=message.inline('{tooltip}identityProvider.servicesId')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].teamId" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.teamId" tooltip=message.inline('{tooltip}identityProvider.teamId')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.buttonText" tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.scope" tooltip=message.inline('{tooltip}identityProvider.scope')/]
          [@control.select name="identityProvider.applicationConfiguration[${id}].keyId" items=keys![] valueExpr="id" textExpr="name" headerValue="" headerL10n="not-specified-use-default" labelKey="identityProvider.signingKeyId" tooltip=message.inline('{tooltip}identityProvider.signingKeyId')/]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].bundleId" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].servicesId" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].teamId" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].scope" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].keyId" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

  </div>
[/#macro]

[#macro hyprFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="hypr-link"/] <a href="https://www.hypr.com/fusionauth-passwordless-mfa/" target="_blank">https://www.hypr.com/fusionauth-passwordless-mfa/</a>.</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="hypr-enabled-settings"/]
  <div id="hypr-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.relyingPartyApplicationId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.relyingPartyApplicationId')/]
      [@control.text name="identityProvider.relyingPartyURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.relyingPartyURL')/]
    </fieldset>

    <fieldset>
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
        [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
          [#if active]
            [@control.text name="identityProvider.applicationConfiguration[${id}].relyingPartyApplicationId" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.relyingPartyApplicationId" tooltip=message.inline('{tooltip}identityProvider.relyingPartyApplicationId')/]
            [@control.text name="identityProvider.applicationConfiguration[${id}].relyingPartyURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.relyingPartyURL" tooltip=message.inline('{tooltip}identityProvider.relyingPartyURL')/]
          [#else]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].relyingPartyApplicationId" /]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].relyingPartyURL" /]
          [/#if]
        [/@socialAppConfig]
    </div>

  </div>
[/#macro]

[#macro googleFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}google-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="google-enabled-settings"/]
  <div id="google-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_id')/]
      [@control.text name="identityProvider.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.loginMethod" items=loginMethods![] tooltip=function.message('{tooltip}identityProvider.loginMethod') data_slide_open="google-redirect-settings" data_slide_open_value="UseRedirect"/]
       <div id="google-redirect-settings" class="slide-open [#if identityProvider.loginMethod == "UseRedirect"]open[/#if]">
         [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}googleButtonText') tooltip=message.inline('{tooltip}identityProvider.googleButtonText')/]
         [@control.text name="identityProvider.scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.googleScope')/]
       </div>
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

    <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
        <li><a href="#options">[@message.print key="options"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_id" tooltip=message.inline('{tooltip}identityProvider.client_id')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_secret" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
          [@control.select name="identityProvider.applicationConfiguration[${id}].loginMethod" items=loginMethods![] labelKey="identityProvider.loginMethod" tooltip=function.message('{tooltip}identityProvider.loginMethod') headerL10n="not-specified-use-default" headerValue=""  data_slide_open="google-redirect-settings-${id}" data_slide_open_value="UseRedirect"/]
          <div id="google-redirect-settings-${id}" class="slide-open [#if (identityProvider.applicationConfiguration[id].loginMethod)!'' == "UseRedirect"]open[/#if]">
            [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" labelKey="identityProvider.loginMethod" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey="identityProvider.buttonText" tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
            [@control.text name="identityProvider.applicationConfiguration[${id}].scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" labelKey="identityProvider.scope" tooltip=message.inline('{tooltip}identityProvider.scope')/]
          </div>
          [#-- Not currently showing a TextEditor / CodeMirror here because we could have 1000's of applications. If we want to use that widget here,--]
          [#-- we will want to lazily initialize this widget when the user expands the override. We should convert the app config to the way we built out the tenant config.--]
          [@control.textarea name="identityProvider.applicationConfiguration[${id}].properties.api" labelKey="identityProvider.properties.api" class="textarea resize vertical" wideTooltip=message.inline('{tooltip}identityProvider.properties.api') /]
          [@control.textarea name="identityProvider.applicationConfiguration[${id}].properties.button" labelKey="identityProvider.properties.button" class="textarea resize vertical" wideTooltip=message.inline('{tooltip}identityProvider.properties.button')/]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_id" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].scope" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].loginMethod" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].properties.api" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].properties.button" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
        [@socialTenantConfig identityProvider=identityProvider/]
    </div>

    <div id="options" class="hidden">
     <fieldset>
       <div class="form-row mb-0" style="margin-bottom: 0;">
         [@control.textarea name="identityProvider.properties.api" wideTooltip=message.inline('{tooltip}identityProvider.properties.api') includeFormRow=false/]
       </div>
       <div class="form-row" style="margin-bottom: 15px;">
         <label></label>
         <div class="d-inline-block"><p class="mt-1"><em>[@message.print key="{description}google.properties.api"/]</em></p></div>
       </div>
       <div class="form-row mb-0" style="margin-bottom: 0;">
         [@control.textarea name="identityProvider.properties.button" wideTooltip=message.inline('{tooltip}identityProvider.properties.button') includeFormRow=false/]
       </div>
       <div class="form-row" style="margin-bottom: 15px;">
         <label></label>
         <div class="d-inline-block"><p class="mt-1"><em>[@message.print key="{description}google.properties.button"/]</em></p></div>
       </div>
     </fieldset>
   </div>
  </div>
[/#macro]

[#macro linkedInFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}linkedin-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="linkedin-enabled-settings"/]
  <div id="linkedin-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
        [@control.hidden name="identityProvider.name"/]
      [/#if]
      [@control.text name="identityProvider.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_id')/]
      [@control.text name="identityProvider.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.client_secret') required=true/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}linkedInButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.scope')/]
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

    <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.client_id' tooltip=message.inline('{tooltip}identityProvider.client_id')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.client_secret' tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.scope' tooltip=message.inline('{tooltip}identityProvider.scope')/]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_id" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret"/]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].scope" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

  </div>
[/#macro]

[#macro twitterFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}twitter-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="twitter-enabled-settings"/]
  <div id="twitter-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
    [#if action=="edit"]
      [@control.hidden name="identityProviderId"/]
      [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [@control.hidden name="identityProvider.name"/]
    [/#if]
      [@control.text name="identityProvider.consumerKey" autofocus="autofocus" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.consumerKey')/]
      [@control.text name="identityProvider.consumerSecret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.consumerSecret')/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}twitterButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].consumerKey" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.consumerKey' tooltip=message.inline('{tooltip}identityProvider.consumerKey')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].consumerSecret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.consumerSecret' tooltip=message.inline('{tooltip}identityProvider.consumerSecret')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}twitterButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].consumerKey" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].consumerSecret" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
        [@socialTenantConfig identityProvider=identityProvider/]
    </div>

  </div>
[/#macro]

[#macro facebookFields identityProvider action]
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="facebook-enabled-settings"/]
  <div id="facebook-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
    [#if action=="edit"]
      [@control.hidden name="identityProviderId"/]
      [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="identityProvider.appId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.appId')/]
    [@control.text name="identityProvider.client_secret" labelKey="identityProvider.appSecret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
    </fieldset>
    <fieldset>
    [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}facebookButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
    [@control.text name="identityProvider.fields" autocapitalize="off" autocomplete="off" autocorrect="off"  spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.fields')/]
    [@control.select name="identityProvider.loginMethod" items=loginMethods![] tooltip=function.message('{tooltip}identityProvider.loginMethod')/]
    [@control.text name="identityProvider.permissions" autocapitalize="off" autocomplete="off" autocorrect="off"  spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.permissions')/]
    </fieldset>
    <fieldset>
    [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
    [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
    [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

    <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
         <fieldset>
         [@control.text name="identityProvider.applicationConfiguration[${id}].appId" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.appId' tooltip=message.inline('{tooltip}identityProvider.appId')/]
         [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.client_secret' tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
         [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}facebookButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
         [@control.text name="identityProvider.applicationConfiguration[${id}].fields" autocapitalize="off" autocomplete="off" autocorrect="off"  spellcheck="false" labelKey='identityProvider.fields' tooltip=message.inline('{tooltip}identityProvider.fields')/]
         [@control.text name="identityProvider.applicationConfiguration[${id}].permissions" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.permissions' tooltip=message.inline('{tooltip}identityProvider.permissions')/]
         [@control.select name="identityProvider.applicationConfiguration[${id}].loginMethod" items=loginMethods![] labelKey="identityProvider.loginMethod" tooltip=function.message('{tooltip}identityProvider.loginMethod') headerL10n="not-specified-use-default" headerValue=""/]
        </fieldset>
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].appId" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].fields" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].permissions" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].loginMethod" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>
  </div>
[/#macro]

[#macro nintendoFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}nintendo-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="nintendo-enabled-settings"/]
  <div id="nintendo-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_id')/]
      [@control.text name="identityProvider.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}nintendoButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.scope')/]
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
        <li><a href="#options">[@message.print key="options"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_id" tooltip=message.inline('{tooltip}identityProvider.client_id')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_secret" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey="identityProvider.buttonText" tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" labelKey="identityProvider.scope" tooltip=message.inline('{tooltip}identityProvider.scope')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].uniqueIdClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.uniqueIdClaim" tooltip=message.inline('{tooltip}identityProvider.uniqueIdClaim')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.emailClaim" tooltip=message.inline('{tooltip}identityProvider.emailClaim')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].usernameClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.usernameClaim" tooltip=message.inline('{tooltip}identityProvider.usernameClaim')/]
       [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_id" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].scope" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].uniqueIdClaim" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].emailClaim" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].usernameClaim" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

    <div id="options" class="hidden">
      <fieldset>
        [@control.text name="identityProvider.uniqueIdClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.uniqueIdClaim')/]
        [@control.text name="identityProvider.emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.emailClaim')/]
        [@control.text name="identityProvider.usernameClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.usernameClaim')/]
      </fieldset>
    </div>

  </div>
[/#macro]

[#macro openIdFields identityProvider domains action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}oidc-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="openid-enabled-settings"/]
  <div id="openid-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [#else]
        [@control.text name="identityProviderId" tooltip=message.inline('{tooltip}id')/]
      [/#if]
      [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}displayOnly')/]
      [@control.text name="identityProvider.oauth2.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.oauth2.client_id')/]
      [@control.select items=clientAuthenticationMethods name="identityProvider.oauth2.clientAuthenticationMethod"  wideTooltip=function.message('{tooltip}identityProvider.oauth2.clientAuthenticationMethod')/]
      <div id="openid-client-secret" class="slide-open [#if identityProvider.oauth2.clientAuthenticationMethod != 'none']open[/#if]">
        [@control.text name="identityProvider.oauth2.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.client_secret') required=true/]
      </div>
      [#assign useOpenIdDiscovery = identityProvider.oauth2.issuer?has_content/]
      [@control.checkbox name="useOpenIdDiscovery" value="true" uncheckedValue="false" checked=useOpenIdDiscovery labelKey="discover-endpoints" data_slide_open="issuer-configuration" data_slide_closed="issuer-endpoint-configuration" tooltip=message.inline('{tooltip}useOpenIdDiscovery')/]
      <div id="issuer-configuration" class="slide-open [#if useOpenIdDiscovery]open[/#if]">
        [@control.text name="identityProvider.oauth2.issuer" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.issuer')/]
      </div>
      <div id="issuer-endpoint-configuration" class="slide-open [#if !useOpenIdDiscovery]open[/#if]">
        [@control.text name="identityProvider.oauth2.authorization_endpoint" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.authorization_endpoint')/]
        [@control.text name="identityProvider.oauth2.token_endpoint" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.token_endpoint')/]
        [@control.text name="identityProvider.oauth2.userinfo_endpoint" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.userinfo_endpoint')/]
      </div>
    </fieldset>

    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.buttonImageURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
      [@control.text name="identityProvider.oauth2.scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.scope')/]
    </fieldset>

    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
        <li><a href="#domains">[@message.print key="managed-domains"/]</a></li>
        <li><a href="#options">[@message.print key="options"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].oauth2.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.oauth2.client_id' tooltip=message.inline('{tooltip}identityProvider.oauth2.client_id')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].oauth2.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.oauth2.client_secret' tooltip=message.inline('{tooltip}identityProvider.oauth2.client_secret')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonImageURL" autocapitalize="on" autocomplete="on" autocorrect="on" spellcheck="false" labelKey='identityProvider.buttonImageURL' tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].oauth2.scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.oauth2.scope' tooltip=message.inline('{tooltip}identityProvider.oauth2.scope')/]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].oauth2.client_id" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].oauth2.client_secret"/]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonImageURL" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].oauth2.scope" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

    <div id="domains" class="hidden">
      <p class="mt-0"><em>[@message.print key="{description}domains"/]</em></p>
      <fieldset>
        [@control.textarea name="domains" labelKey="empty"/]
      </fieldset>
    </div>

    <div id="options" class="hidden">
      <fieldset>
        [#-- POST handling --]
        [@control.checkbox name="identityProvider.postRequest" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.postRequest')/]
      </fieldset>
      <fieldset>
        [@control.text name="identityProvider.oauth2.uniqueIdClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.uniqueIdClaim')/]
        [@control.text name="identityProvider.oauth2.emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.emailClaim')/]
        [@control.text name="identityProvider.oauth2.emailVerifiedClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.emailVerifiedClaim')/]
        [@control.text name="identityProvider.oauth2.usernameClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.usernameClaim')/]
      </fieldset>
    </div>

  </div>
[/#macro]

[#macro samlv2Fields identityProvider domains action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}samlv2-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-enabled-settings"/]
  <div id="samlv2-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [#else]
        [@control.text name="identityProviderId" tooltip=message.inline('{tooltip}id')/]
      [/#if]
      [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}displayOnly')/]

    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.idpEndpoint" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.idpEndpoint')/]
      [@control.select name="identityProvider.nameIdFormat" labelKey="identityProvider.nameIdFormat" items={'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent':'Persistent [urn:oasis:names:tc:SAML:2.0:nameid-format:persistent]', 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress':'Email [urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress]','':message.inline('other')}  tooltip=message.inline('{tooltip}identityProvider.nameIdFormat') data_slide_open="saml-nameid-format" data_slide_open_value=""/]
      [#local otherValue = identityProvider.nameIdFormat != 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent' && identityProvider.nameIdFormat != 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress' /]
      <div id="saml-nameid-format" class="slide-open[#if otherValue] open[/#if]">
        [@control.text name="otherNameIdFormat" labelKey="value" /]
      </div>
      [@control.select items=keys![] name="identityProvider.keyId" valueExpr="id" textExpr="name" headerValue="" headerL10n="select-samlv2-key" required=true tooltip=message.inline('{tooltip}identityProvider.keyId')/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.buttonImageURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
    </fieldset>

    <fieldset>
      [@control.checkbox name="identityProvider.idpInitiatedConfiguration.enabled" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.idpInitiatedConfiguration.enabled') data_slide_open="saml-idp-initiated-support"/]
      <div id="saml-idp-initiated-support" class="slide-open [#if identityProvider.idpInitiatedConfiguration.enabled]open[/#if]" >
        <div class="form-row">
          <label></label>
          <span>
            <p class="mt-0">
              <em>[@message.print key="{description}samlv2-idp-initiated"/]</em>
            </p>

            <div id="samlv2-idp-initiated-long-description" class="slide-open">
              <em>[@message.print key="{description}samlv2-idp-initiated-long"/]</em>
            </div>

            <a href="#" class="slide-open-toggle" style="margin-bottom: 1.5rem !important; margin-top: 1rem;" data-spoiler="samlv2-idp-initiated-long-description" data-spoiler-storage-key="io.fusionauth.idp.samlv2IdPInitiatedWarning">
              <span>[@message.print key="{tell-me-more}samlv2-idp-initiated"/] <i class="fa fa-angle-down"></i></span>
            </a>
          </span>
        </div>
        [@control.text name="identityProvider.idpInitiatedConfiguration.issuer" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.issuer')/]
      </div>
    </fieldset>

    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
        <li><a href="#options">[@message.print key="options"/]</a></li>
        <li><a href="#domains">[@message.print key="managed-domains"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}samlv2ButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonImageURL" autocapitalize="on" autocomplete="on" autocorrect="on" spellcheck="false" labelKey='identityProvider.buttonImageURL' tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonImageURL" /]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
        [@socialTenantConfig identityProvider=identityProvider/]
    </div>

    <div id="options" class="hidden">
      <fieldset>
       [@control.text name="identityProvider.uniqueIdClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.uniqueIdClaim')/]
       [@control.checkbox name="identityProvider.useNameIdForEmail" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.useNameIdForEmail') data_slide_open="saml-email-claim" /]
       <div id="saml-email-claim" class="slide-open [#if !identityProvider.useNameIdForEmail]open[/#if]">
         [@control.text name="identityProvider.emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.emailClaim')/]
       </div>
       [@control.text name="identityProvider.usernameClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.usernameClaim')/]

        [#-- POST handling --]
        [@control.checkbox name="identityProvider.postRequest" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.postRequest') data_slide_open="saml-request-signing-canonicalization" data_slide_closed="saml-http-redirect-bindings"/]

        [#-- Signed requests --]
        [@control.checkbox name="identityProvider.signRequest" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.signRequest') data_slide_open="saml-request-signing-key"/]
        <div id="saml-request-signing-key" class="slide-open [#if identityProvider.signRequest]open[/#if]">
          [@control.select items=requestSigningKeys name="identityProvider.requestSigningKeyId" textExpr="name" valueExpr="id" headerValue="" headerL10n="select-samlv2-request-signing-key" required=true tooltip=message.inline('{tooltip}identityProvider.requestSigningKeyId')/]

          [#-- This will slide open if the signing div is open. Otherwise, it should remain hidden --]
          <div id="saml-request-signing-canonicalization" class="slide-open [#if identityProvider.postRequest]open[/#if]">
            [@control.select items=c14nMethods name="identityProvider.xmlSignatureC14nMethod" tooltip=message.inline('{tooltip}identityProvider.xmlSignatureC14nMethod')/]
          </div>
        </div>

        [#-- Hint configuration. These only apply to HTTP redirect bindings --]
        <div id="saml-http-redirect-bindings" class="slide-open [#if !identityProvider.postRequest]open[/#if]">
          [@control.checkbox name="identityProvider.loginHintConfiguration.enabled" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.loginHintConfiguration.enabled') data_slide_open="saml-login-hint-config"/]
          <div id="saml-login-hint-config" class="slide-open [#if identityProvider.loginHintConfiguration.enabled]open[/#if]">
            [@control.text name="identityProvider.loginHintConfiguration.parameterName" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.loginHintConfiguration.parameterName')/]
          </div>
        </div>
        [@control.select id="destinationAssertionPolicies" data_slide_open="saml-alternate-destination-assertion-config" data_slide_open_value="AllowAlternates" class="select no-wrap" name="identityProvider.assertionConfiguration.destination.policy" items=destinationAssertionPolicies wideTooltip=message.inline('{tooltip}identityProvider.assertionConfiguration.destination.policy') /]
        <div id="saml-alternate-destination-assertion-config" class="slide-open ${(identityProvider.assertionConfiguration.destination.policy == "AllowAlternates")?then('open', '')}">
          [@control.select id="alternateDestinations" items=identityProvider.assertionConfiguration.destination.alternates multiple=true name="identityProvider.assertionConfiguration.destination.alternates" class="select no-wrap" labelKey="identityProvider.assertionConfiguration.destination.alternates"  tooltip=function.message('{tooltip}identityProvider.assertionConfiguration.destination.alternates') data_alternate_destination_add_label=function.message('{widget-add-label}identityProvider.assertionConfiguration.destination.alternates')/]
        </div>
      </fieldset>
    </div>

    <div id="domains" class="hidden">
      <p class="mt-0"><em>[@message.print key="{description}domains"/]</em></p>
      <fieldset>
        [@control.textarea name="domains" labelKey="empty"/]
      </fieldset>
    </div>

  </div>
[/#macro]

[#macro samlv2IdPInitiatedFields identityProvider domains action]
  <p class="mt-0">
    <em>[@message.print key="{description}samlv2-idp-initiated"/]</em>
  </p>

  <div id="samlv2-idp-initiated-long-description" class="slide-open">
    <em>[@message.print key="{description}samlv2-idp-initiated-long"/]</em>
  </div>

  <a href="#" class="slide-open-toggle" style="margin-bottom: 1.5rem !important; margin-top: 1rem;" data-spoiler="samlv2-idp-initiated-long-description" data-spoiler-storage-key="io.fusionauth.idp.samlv2IdPInitiatedWarning">
    <span>[@message.print key="{tell-me-more}samlv2-idp-initiated"/] <i class="fa fa-angle-down"></i></span>
  </a>

  <p class="mb-4">
    <em>[@message.print key="{description}samlv2-settings"/]</em>
  </p>

  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-enabled-settings"/]
  <div id="samlv2-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [#else]
        [@control.text name="identityProviderId" tooltip=message.inline('{tooltip}id')/]
      [/#if]
      [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}displayOnly')/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.issuer" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.issuer')/]
      [@control.select items=keys![] name="identityProvider.keyId" valueExpr="id" textExpr="name" headerValue="" headerL10n="select-samlv2-key" required=true tooltip=message.inline('{tooltip}identityProvider.keyId')/]
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
        <li><a href="#options">[@message.print key="options"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showOverride=false showLegend=false; id, active/]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

    <div id="options" class="hidden">
      <fieldset>
        [@control.text name="identityProvider.uniqueIdClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.uniqueIdClaim')/]
        [@control.checkbox name="identityProvider.useNameIdForEmail" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.useNameIdForEmail') data_slide_open="saml-email-claim"/]
        [@control.text name="identityProvider.emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.emailClaim')/]
        [@control.text name="identityProvider.usernameClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.usernameClaim')/]
      </fieldset>
    </div>
  </div>
[/#macro]

[#macro baseOauthFields identityProvider action oauthName]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}${oauthName}-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="${oauthName}-enabled-settings"/]
  <div id="${oauthName}-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_id')/]
      [#if oauthName == "steam"]
        [@control.select name="identityProvider.apiMode" items=steamAPIModes![] tooltip=message.inline('{tooltip}identityProvider.apiMode')/]
        [@control.text name="identityProvider.webAPIKey" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.webAPIKey')/]
      [#else]
        [@control.text name="identityProvider.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
      [/#if]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" placeholder=message.inline('{placeholder}${oauthName}ButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [#if oauthName != "steam"]
      [@control.text name="identityProvider.scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.scope')/]
      [/#if]
    </fieldset>
    <fieldset>
      [@control.select name="identityProvider.linkingStrategy" items=linkingStrategies wideTooltip=function.message('{tooltip}identityProvider.linkingStrategy')/]
      [@control.select items=lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

     <div class="mt-4">
      <ul class="tabs">
        <li><a href="#applications">[@message.print key="applications"/]</a></li>
        <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
      </ul>
    </div>

    <div id="applications" class="hidden">
      [@socialAppConfig identityProvider=identityProvider showLegend=false; id, active]
        [#if active]
          [@control.text name="identityProvider.applicationConfiguration[${id}].client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_id" tooltip=message.inline('{tooltip}identityProvider.client_id')/]
          [#if oauthName=="steam"]
            [@control.select name="identityProvider.applicationConfiguration[${id}].apiMode" headerValue="" headerL10n="not-specified-use-default"  labelKey="identityProvider.apiMode" items=steamAPIModes![] tooltip=message.inline('{tooltip}identityProvider.apiMode')/]
            [@control.text name="identityProvider.applicationConfiguration[${id}].webAPIKey" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.webAPIKey" tooltip=message.inline('{tooltip}identityProvider.webAPIKey')/]
          [#else]
            [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_secret" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
          [/#if]
          [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey="identityProvider.buttonText" tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
          [#if oauthName != "steam"]
          [@control.text name="identityProvider.applicationConfiguration[${id}].scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" labelKey="identityProvider.scope" tooltip=message.inline('{tooltip}identityProvider.scope')/]
          [/#if]
        [#else]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_id" /]
          [#if oauthName=="steam"]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].webAPIKey" /]
          [#else]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret" /]
          [/#if]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
          [#if oauthName != "steam"]
          [@control.hidden name="identityProvider.applicationConfiguration[${id}].scope" /]
          [/#if]
          [#if identityProvider.loginMethod??]
            [@control.hidden name="identityProvider.applicationConfiguration[${id}].loginMethod" /]
          [/#if]
        [/#if]
      [/@socialAppConfig]
    </div>

    <div id="tenants" class="hidden">
      [@socialTenantConfig identityProvider=identityProvider/]
    </div>

  </div>
[/#macro]

[#macro identityProviderFields identityProvider action domains=""]
  [@control.hidden name="type"/]

  [#switch type!""]
    [#case "Apple"]
      [@appleFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "EpicGames"]
      [@baseOauthFields identityProvider=identityProvider action=action oauthName="epicgames"/]
      [#break]
    [#case "Facebook"]
      [@facebookFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "Google"]
      [@googleFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "HYPR"]
      [@hyprFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "LinkedIn"]
      [@linkedInFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "Nintendo"]
      [@nintendoFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "OpenIDConnect"]
      [@openIdFields identityProvider=identityProvider domains=domains action=action/]
      [#break]
    [#case "SAMLv2"]
      [@samlv2Fields identityProvider=identityProvider domains=domains action=action/]
      [#break]
    [#case "SAMLv2IdPInitiated"]
      [@samlv2IdPInitiatedFields identityProvider=identityProvider domains=domains action=action/]
      [#break]
    [#case "SonyPSN"]
      [@baseOauthFields identityProvider=identityProvider action=action oauthName="sonypsn"/]
      [#break]
    [#case "Steam"]
      [@baseOauthFields identityProvider=identityProvider action=action oauthName="steam"/]
      [#break]
    [#case "Twitch"]
      [@baseOauthFields identityProvider=identityProvider action=action oauthName="twitch"/]
      [#break]
    [#case "Twitter"]
      [@twitterFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "Xbox"]
      [@baseOauthFields identityProvider=identityProvider action=action oauthName="xbox"/]
      [#break]
    [#default]
      [@externalJWTFields identityProvider=identityProvider domains=domains action=action/]
  [/#switch]
[/#macro]

[#macro identityProvidersTable]
<table id="identity-providers-table" class="hover listing" data-sortable="false">
  <thead>
    [@helpers.tableHeader "name"/]
    [@helpers.tableHeader "id" "hide-on-mobile"/]
    [@helpers.tableHeader "enabled"/]
    <th data-sortable="false" class="action">[@message.print "action"/]</th>
  </thead>
  <tbody>
    [#list results![] as provider]
      <tr>
        <td style="padding: 2px 8px;">
          <img style="width: 30px; height: 30px; margin-right: 10px; position: relative; vertical-align: middle;" src="${request.contextPath}/images/identityProviders/${provider.type?lower_case}.svg" alt="${message.inline(provider.type)}">
          [#-- This is sort of a hack, but .id will call id() which returns a random UUID if we have not set one for the "branded" IdP
               So if the id returned is equal to the actual, then this is "branded" so lookup the name from the resource bundle --]
          [#if provider.getType().id == provider.id]
            ${message.inlineOptional(provider.getType(), provider.getType())}
          [#else]
            ${properties.display(provider, "name")}
          [/#if]
        </td>
        <td class="hide-on-mobile">${properties.display(provider, "id")}</td>
        <td>${properties.display(provider, "enabled")}</td>
        <td class="action">
          [@button.action href="/admin/identity-provider/edit/${provider.type}/${provider.id}" icon="edit" key="edit" color="blue"/]
          [@button.action href="/ajax/identity-provider/view/${provider.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
          [@button.action href="/admin/identity-provider/delete/${provider.id}" icon="trash" key="delete" color="red"/]
        </td>
      </tr>
    [#else]
      <tr>
        <td colspan="4">[@message.print "no-results"/]</td>
      </tr>
    [/#list]
  </tbody>
</table>
[/#macro]

