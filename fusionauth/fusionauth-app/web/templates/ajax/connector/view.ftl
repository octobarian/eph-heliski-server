[#ftl/]
[#-- @ftlvariable name="connector" type="io.fusionauth.domain.connector.BaseConnectorConfiguration" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Common fields --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=connector propertyName="name"/]
    [@properties.rowEval nameKey="id" object=connector propertyName="id"/]
    [@properties.row nameKey="type" value=connector.getType()/]
    [@properties.rowEval nameKey="debug" object=connector propertyName="debug" booleanAsCheckmark=false /]
    [@properties.rowEval nameKey="insertInstant" object=connector propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=connector propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#-- Security --]
  [#if connector.type == "Generic"]
    <h3>[@message.print key="security"/]</h3>
    [@properties.table]
      [@properties.rowEval nameKey="generic.sslCertificateKeyId" object=connector propertyName="sslCertificateKeyId"/]
      [@properties.rowEval nameKey="generic.httpAuthenticationPassword" object=connector propertyName="httpAuthenticationPassword"/]
      [@properties.rowEval nameKey="generic.httpAuthenticationUsername" object=connector propertyName="httpAuthenticationUsername"/]
    [/@properties.table]
  [/#if]

  [#-- LDAP connector --]
  [#if connector.type == "LDAP"]
    <h3>[@message.print key="ldap.integration-details"/]</h3>
    [@properties.table]
      [@properties.rowEval nameKey="ldap.authenticationURL" object=connector propertyName="authenticationURL"/]
      [@properties.rowEval nameKey="ldap.securityMethod" object=connector propertyName="securityMethod"/]
      [@properties.rowEval nameKey="connector.connectTimeout" object=connector propertyName="connectTimeout"/]
      [@properties.rowEval nameKey="connector.readTimeout" object=connector propertyName="readTimeout"/]
      [@properties.rowEval nameKey="ldap.systemAccountDN" object=connector propertyName="systemAccountDN"/]
      [@properties.rowEval nameKey="ldap.baseStructure" object=connector propertyName="baseStructure"/]
      [@properties.rowEval nameKey="ldap.loginIdAttribute" object=connector propertyName="loginIdAttribute"/]
      [@properties.rowEval nameKey="ldap.identifyingAttribute" object=connector propertyName="identifyingAttribute"/]
      [@properties.rowEval nameKey="ldap.lambdaConfiguration.reconcileId" object=connector propertyName="lambdaConfiguration.reconcileId"/]
      [@properties.rowEval nameKey="ldap.requestedAttributes" object=connector propertyName="requestedAttributes"/]
    [/@properties.table]
  [/#if]

  [#-- Generic connector --]
  [#if connector.type == "Generic"]
    <h3>[@message.print key="generic.integration-details"/]</h3>
    [@properties.table]
      [@properties.rowEval nameKey="generic.authenticationURL" object=connector propertyName="authenticationURL"/]
      [@properties.rowEval nameKey="connector.connectTimeout" object=connector propertyName="connectTimeout"/]
      [@properties.rowEval nameKey="connector.readTimeout" object=connector propertyName="readTimeout"/]
    [/@properties.table]
    <h3>[@message.print key="generic.http-headers"/]</h3>
    [@properties.table]
      [#list (connector.headers?keys)![] as name]
        [@properties.rowRaw name=name value=properties.displayMapValue(connector.headers, name)/]
      [#else]
        <tr>
          <td colspan="2" style="font-weight: inherit;">[@message.print key="generic.no-headers"/]</td>
        </tr>
      [/#list]
    [/@properties.table]
  [/#if]

  [#if (connector.data)?? && connector.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(connector.data)}</pre>
  [/#if]
[/@dialog.view]