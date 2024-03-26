[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.Map<java.utils.UUID, io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="defaultIdentityProviderTenantConfiguration" type="io.fusionauth.domain.provider.IdentityProviderTenantConfiguration" --]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]
[#-- @ftlvariable name="fusionAuthHost" type="java.lang.String" --]
[#-- @ftlvariable name="key" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="lambda" type="io.fusionauth.domain.Lambda" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro integrationDetails type]
  <h3>[@message.print key="${type}.integration-details"/]</h3>
  <p><em>[@message.print key="{description}${type}.integration-details"/]</em></p>
  [@properties.table]
    [@properties.row nameKey="callback-url" value=(fusionAuthHost + (type == "steam")?then("/oauth2/callback/implicit", "/oauth2/callback")) /]
  [/@properties.table]
[/#macro]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowNestedValue nameKey="name" ]
      [#-- This is sort of a hack, but .id will call id() which returns a random UUID if we have not set one for the "branded" IdP
           So if the id returned is equal to the actual, then this is "branded" so lookup the name from the resource bundle --]
      [#if identityProvider.getType().id == identityProvider.id]
        ${message.inlineOptional(identityProvider.getType(), identityProvider.getType())}
      [#else]
        ${properties.display(identityProvider, "name")}
      [/#if]
    [/@properties.rowNestedValue]
    [@properties.rowEval nameKey="type" object=identityProvider propertyName="type"/]
    [@properties.rowEval nameKey="enabled" object=identityProvider propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="id" object=identityProvider propertyName="id"/]
    [#if identityProvider.getType() == "Facebook"]
      [@properties.rowEval nameKey="appId" object=identityProvider propertyName="appId"/]
      [@properties.rowEval nameKey="appSecret" object=identityProvider propertyName="client_secret"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="fields" object=identityProvider propertyName="fields"/]
      [@properties.rowEval nameKey="permissions" object=identityProvider propertyName="permissions"/]
    [/#if]
    [#if identityProvider.getType() == "Apple"]
      [@properties.rowEval nameKey="bundleId" object=identityProvider propertyName="bundleId"/]
      [@properties.rowEval nameKey="servicesId" object=identityProvider propertyName="servicesId"/]
      [@properties.rowEval nameKey="teamId" object=identityProvider propertyName="teamId"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="scope" object=identityProvider propertyName="scope"/]
      [#if identityProvider.keyId??]
        [@properties.rowEval nameKey="keyId" object=key propertyName="name"/]
      [/#if]
      [#if identityProvider.lambdaConfiguration.reconcileId??]
      [@properties.row nameKey="linkingStrategy" value=message.inlineOptional("IdentityProviderLinkingStrategy." + identityProvider.linkingStrategy, identityProvider.linkingStrategy) /]
        [@properties.rowEval nameKey="reconcileLambda" object=lambda propertyName="name"/]
      [#else]
        [@properties.rowEval nameKey="reconcileLambda" object=identityProvider propertyName="lambdaConfiguration.reconcileId"/]
      [/#if]
      [@properties.rowEval nameKey="debug" object=identityProvider propertyName="debug" booleanAsCheckmark=false /]
    [/#if]
    [#if identityProvider.getType() == "EpicGames" || identityProvider.getType() == "Google"  || identityProvider.getType() == "Nintendo" ||
         identityProvider.getType() == "SonyPSN" || identityProvider.getType() == "Twitch" || identityProvider.getType() == "Xbox"]
      [@properties.rowEval nameKey="clientId" object=identityProvider propertyName="client_id"/]
      [@properties.rowEval nameKey="clientSecret" object=identityProvider propertyName="client_secret"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="scope" object=identityProvider propertyName="scope"/]
    [/#if]
    [#if identityProvider.getType() == "Steam"]
      [@properties.rowEval nameKey="clientId" object=identityProvider propertyName="client_id"/]
      [@properties.rowEval nameKey="apiMode" object=identityProvider propertyName="apiMode"/]
      [@properties.rowEval nameKey="webAPIKey" object=identityProvider propertyName="webAPIKey"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="scope" object=identityProvider propertyName="scope"/]
    [/#if]
    [#if identityProvider.getType() == "HYPR"]
      [@properties.rowEval nameKey="relyingPartyApplicationId" object=identityProvider propertyName="relyingPartyApplicationId"/]
      [@properties.rowEval nameKey="relyingPartyURL" object=identityProvider propertyName="relyingPartyURL"/]
    [/#if]
    [#if identityProvider.getType() == "OpenIDConnect"]
      [@properties.rowEval nameKey="clientId" object=identityProvider propertyName="oauth2.client_id"/]
      [@properties.rowEval nameKey="clientSecret" object=identityProvider propertyName="oauth2.client_secret"/]
      [#if identityProvider.oauth2.issuer??]
        [@properties.rowEval nameKey="issuer" object=identityProvider propertyName="oauth2.issuer"/]
      [#else]
        [@properties.rowEval nameKey="authorizeEndpoint" object=identityProvider propertyName="oauth2.authorization_endpoint"/]
        [@properties.rowEval nameKey="tokenEndpoint" object=identityProvider propertyName="oauth2.token_endpoint"/]
        [@properties.rowEval nameKey="userinfoEndpoint" object=identityProvider propertyName="oauth2.userinfo_endpoint"/]
      [/#if]
      [#if identityProvider.lambdaConfiguration.reconcileId??]
        [@properties.rowEval nameKey="reconcileLambda" object=lambda propertyName="name"/]
      [#else]
        [@properties.rowEval nameKey="reconcileLambda" object=identityProvider propertyName="lambdaConfiguration.reconcileId"/]
      [/#if]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="buttonImage" object=identityProvider propertyName="buttonImage"/]
      [@properties.rowEval nameKey="scope" object=identityProvider propertyName="oauth2.scope"/]
      [@properties.rowEval nameKey="managedDomains" object=identityProvider propertyName="domains"/]
      [@properties.rowEval nameKey="oauth2.postRequest" object=identityProvider propertyName="postRequest"/]
      [@properties.rowEval nameKey="oauth2.uniqueIdClaim" object=identityProvider propertyName="oauth2.uniqueIdClaim"/]
      [@properties.rowEval nameKey="oauth2.emailClaim" object=identityProvider propertyName="oauth2.emailClaim"/]
      [@properties.rowEval nameKey="oauth2.emailVerifiedClaim" object=identityProvider propertyName="oauth2.emailVerifiedClaim"/]
      [@properties.rowEval nameKey="oauth2.usernameClaim" object=identityProvider propertyName="oauth2.usernameClaim"/]
    [/#if]
    [#if identityProvider.getType() == "SAMLv2"]
      [@properties.rowEval nameKey="samlv2.idpEndpoint" object=identityProvider propertyName="idpEndpoint"/]
      [@properties.rowEval nameKey="samlv2.nameIdFormat" object=identityProvider propertyName="nameIdFormat" /]
      [@properties.rowEval nameKey="samlv2.uniqueIdClaim" object=identityProvider propertyName="uniqueIdClaim"/]
      [@properties.rowEval nameKey="samlv2.useNameIdForEmail" object=identityProvider propertyName="useNameIdForEmail" booleanAsCheckmark=false/]
      [#if !identityProvider.useNameIdForEmail]
        [@properties.rowEval nameKey="samlv2.emailClaim" object=identityProvider propertyName="emailClaim"/]
      [/#if]
      [@properties.rowEval nameKey="samlv2.usernameClaim" object=identityProvider propertyName="usernameClaim"/]
      [#if identityProvider.keyId??]
        [@properties.rowEval nameKey="samlv2.keyId" object=key propertyName="name"/]
      [/#if]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="buttonImage" object=identityProvider propertyName="buttonImage"/]
      [#if identityProvider.lambdaConfiguration.reconcileId??]
        [@properties.rowEval nameKey="reconcileLambda" object=lambda propertyName="name"/]
      [#else]
        [@properties.rowEval nameKey="reconcileLambda" object=identityProvider propertyName="lambdaConfiguration.reconcileId"/]
      [/#if]
      [@properties.rowEval nameKey="loginHintConfiguration.enabled" object=identityProvider propertyName="loginHintConfiguration.enabled"/]
      [@properties.rowEval nameKey="loginHintConfiguration.parameterName" object=identityProvider propertyName="loginHintConfiguration.parameterName"/]
      [@properties.rowEval nameKey="managedDomains" object=identityProvider propertyName="domains"/]
      [@properties.row nameKey="assertionConfiguration.destinationAssertionPolicy" value=message.inline("SAMLv2DestinationAssertionPolicy." + identityProvider.assertionConfiguration.destination.policy)/]
      [@properties.rowEval nameKey="assertionConfiguration.destinationAlternates" object=identityProvider propertyName="assertionConfiguration.destination.alternates"/]
      [@properties.rowEval nameKey="idpInitiatedConfiguration.enabled" object=identityProvider propertyName="idpInitiatedConfiguration.enabled"/]
      [@properties.rowEval nameKey="idpInitiatedConfiguration.issuer" object=identityProvider propertyName="idpInitiatedConfiguration.issuer"/]
    [/#if]
    [#if identityProvider.getType() == "SAMLv2IdPInitiated"]
      [@properties.rowEval nameKey="samlv2.issuer" object=identityProvider propertyName="issuer"/]
      [@properties.rowEval nameKey="samlv2.useNameIdForEmail" object=identityProvider propertyName="useNameIdForEmail" booleanAsCheckmark=false/]
      [#if !identityProvider.useNameIdForEmail]
        [@properties.rowEval nameKey="samlv2.emailClaim" object=identityProvider propertyName="emailClaim"/]
      [/#if]
      [#if identityProvider.keyId??]
        [@properties.rowEval nameKey="samlv2.keyId" object=key propertyName="name"/]
      [/#if]
      [#if identityProvider.lambdaConfiguration.reconcileId??]
        [@properties.rowEval nameKey="reconcileLambda" object=lambda propertyName="name"/]
      [#else]
        [@properties.rowEval nameKey="reconcileLambda" object=identityProvider propertyName="lambdaConfiguration.reconcileId"/]
      [/#if]
    [/#if]
    [#if identityProvider.getType() == "Twitter"]
      [@properties.rowEval nameKey="consumerKey" object=identityProvider propertyName="consumerKey"/]
      [@properties.rowEval nameKey="consumerSecret" object=identityProvider propertyName="consumerSecret"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
    [/#if]
    [@properties.row nameKey="linkingStrategy" value=message.inlineOptional("IdentityProviderLinkingStrategy." + identityProvider.linkingStrategy, identityProvider.linkingStrategy) /]
    [@properties.rowEval nameKey="debug" object=identityProvider propertyName="debug" booleanAsCheckmark=false /]
    [@properties.rowEval nameKey="insertInstant" object=identityProvider propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=identityProvider propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#if identityProvider.getType() == "SAMLv2" || identityProvider.getType() == "SAMLv2IdPInitiated"]
    <h3>[@message.print key="samlv2.integration-details"/]</h3>
    <p><em>[@message.print key="{description}samlv2.integration-details"/]</em></p>
    [@properties.table]
      [#-- If IdP initiated show application specific ACS values --]
      [#if (identityProvider.getType() == "SAMLv2" && identityProvider.idpInitiatedConfiguration.enabled) || identityProvider.getType() == "SAMLv2IdPInitiated"  ]
        <tr>
          <td class="top" style="padding-left: 0">
            [@message.print key="samlv2.idp-init-callback-url"/]
          </td>
          <td style="padding-left: 0">
            <table class="nested">
              <thead>
              <tr>
                <th>[@message.print key="application"/]</th>
                <th>[@message.print key="url"/]</th>
              </tr>
              </thead>
              <tbody>
              [#list identityProvider.applicationConfiguration as applicationId, appConfig]
                [#if appConfig.enabled]
                  <tr>
                    <td style="white-space: normal;">${applications(applicationId).name}</td>
                    <td>${fusionAuthHost + "/samlv2/acs/" + identityProvider.id + "/" + applications(applicationId).oauthConfiguration.clientId}</td>
                  </tr>
                [/#if]
              [/#list]
              </tbody>
            </table>
          </td>
        </tr>
      [/#if]
      [#if identityProvider.getType() == "SAMLv2"]
        [@properties.row nameKey="samlv2.callback-url" value=(fusionAuthHost + "/samlv2/acs") /]
      [/#if]
      [@properties.row nameKey="samlv2.issuer" value=(fusionAuthHost + "/samlv2/sp/" + identityProvider.id) /]
      [@properties.row nameKey="samlv2.metadata" value=(fusionAuthHost + "/samlv2/sp/metadata/" + identityProvider.id) /]
    [/@properties.table]
  [/#if]

  [#switch identityProvider.getType()!""]
    [#case "EpicGames"]
      [@integrationDetails type="epicgames"/]
      [#break]
    [#case "OpenIDConnect"]
      [@integrationDetails type="oidc"/]
      [#break]
    [#case "SonyPSN"]
      [@integrationDetails type="sonypsn"/]
      [#break]
    [#case "Steam"]
      [@integrationDetails type="steam"/]
      [#break]
    [#case "Twitch"]
      [@integrationDetails type="twitch"/]
      [#break]
    [#case "Twitter"]
      [@integrationDetails type="twitter"/]
      [#break]
    [#case "Xbox"]
      [@integrationDetails type="xbox"/]
      [#break]
  [/#switch]

  [#-- Application configuration --]
  <h3>[@message.print key="applications"/]</h3>
  <table class="hover">
    <thead style="display: table; table-layout: fixed; width: 100%;">
    <tr>
      <th>[@message.print key="name"/]</th>
      <th>[@message.print key="enabled"/]</th>
      <th>[@message.print key="create-registration"/]</th>
    </tr>
    </thead>
    <tbody class="scrollable vertical" style="display: block; max-height: 800px;">
    [#list applications?values![] as application]
     [#-- We are not yet displaying any overrides if they exist, I don't know of a good way to display that here. --]
      <tr style="display: table; table-layout: fixed; width: 100%;">
        <td>${properties.display(application, "name")}</td>
        <td class="icon">
        [#if identityProvider.applicationConfiguration(application.id)??]${properties.display(identityProvider.applicationConfiguration(application.id), "enabled")}[#else]&ndash;[/#if]
        </td>
        <td class="icon">
        [#if identityProvider.applicationConfiguration(application.id)??]${properties.display(identityProvider.applicationConfiguration(application.id), "createRegistration")}[#else]&ndash;[/#if]
        </td>
      </tr>
    [/#list]
    </tbody>
  </table>

  [#-- Tenant configuration --]
  <h3>[@message.print key="tenants"/]</h3>
  <table class="hover">
    <thead style="display: table; table-layout: fixed; width: 100%;">
    <tr>
      <th>[@message.print key="name"/]</th>
      <th>[@message.print key="id"/]</th>
      <th>[@message.print key="limit-user-links"/]</th>
      <th>[@message.print key="max-link-count"/]</th>
    </tr>
    </thead>
    <tbody class="scrollable vertical" style="display: block; max-height: 800px;">
    [#list tenants?values![] as tenant]
      <tr style="display: table; table-layout: fixed; width: 100%;">
        <td>${properties.display(tenant, "name")}</td>
        <td>${properties.display(tenant, "id")}</td>
        <td class="icon">
          [#if identityProvider.tenantConfiguration(tenant.id)??]${properties.display(identityProvider.tenantConfiguration(tenant.id), "limitUserLinkCount.enabled")}[#else]&ndash;[/#if]
        </td>
        <td>
          [#if identityProvider.tenantConfiguration(tenant.id)??]${properties.display(identityProvider.tenantConfiguration(tenant.id), "limitUserLinkCount.maximumLinks")}[#else]${defaultIdentityProviderTenantConfiguration.limitUserLinkCount.maximumLinks}[/#if]
        </td>
      </tr>
    [/#list]
    </tbody>
  </table>
[/@dialog.view]
