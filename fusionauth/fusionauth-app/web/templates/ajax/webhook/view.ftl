[#ftl/]
[#-- @ftlvariable name="signingKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="sslCertificateKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="webhook" type="io.fusionauth.domain.Webhook" --]
[#-- @ftlvariable name="webhookTenants" type="java.util.List<io.fusionauth.domain.Tenant>" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="url" object=webhook propertyName="url"/]
    [@properties.rowEval nameKey="id" object=webhook propertyName="id"/]
    [@properties.rowEval nameKey="description" object=webhook propertyName="description"/]
    [@properties.rowEval nameKey="insertInstant" object=webhook propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=webhook propertyName="lastUpdateInstant"/]
    [@properties.rowEval nameKey="global" object=webhook propertyName="global" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="connect-timeout" object=webhook propertyName="connectTimeout"/]
    [@properties.rowEval nameKey="read-timeout" object=webhook propertyName="readTimeout"/]
    [@properties.rowEval nameKey="http-authentication-username" object=webhook propertyName="httpAuthenticationUsername"/]
    [@properties.rowEval nameKey="http-authentication-password" object=webhook propertyName="httpAuthenticationPassword"/]
    [#if sslCertificateKey?has_content]
      [@properties.rowNestedValue nameKey="ssl-certificate-key-id"]
         ${properties.display(sslCertificateKey, "name")} <br> ${properties.display(sslCertificateKey, "id")}
      [/@properties.rowNestedValue]
    [/#if]
    [#if webhook.sslCertificate?has_content]
      [@properties.rowEval nameKey="ssl-certificate" object=webhook propertyName="sslCertificate"/]
    [/#if]
    [@properties.rowEval nameKey="signatureConfiguration.enabled" object=webhook propertyName="signatureConfiguration.enabled" booleanAsCheckmark=false/]
    [#if signingKey?has_content]
      [@properties.rowNestedValue nameKey="signatureConfiguration.signingKeyId"]
        ${properties.display(signingKey, "name")} <br> ${properties.display(signingKey, "id")}
      [/@properties.rowNestedValue]
    [#else]
      [@properties.row nameKey="signatureConfiguration.signingKeyId" value="\x2013"/]
    [/#if]
  [/@properties.table]

  [#-- Tenant --]
  <h3>[@message.print key="tenants"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print key="name"/]</th>
        <th>[@message.print key="id"/]</th>
      </tr>
    </thead>
    <tbody>
      [#if webhook.global]
        <tr>
          <td colspan="2">[@message.print key="all-tenants"/]</td>
        </tr>
      [#else]
        [#list webhookTenants as tenant]
          <tr>
            <td>${properties.display(tenant, "name")}</td>
            <td>$${properties.display(tenant, "id")}</td>
          </tr>
        [#else]
          <tr>
            <td colspan="2">[@message.print key="no-tenants"/]</td>
          </tr>
        [/#list]
      [/#if]
    </tbody>
  </table>

  [#-- HTTP Headers --]
  <h3>[@message.print key="http-headers"/]</h3>
  [@properties.table]
    [#list (webhook.headers?keys)![] as name]
      [@properties.rowRaw name=name value=properties.displayMapValue(webhook.headers, name)/]
    [#else]
      <tr>
        <td colspan="2" style="font-weight: inherit;">[@message.print key="no-headers"/]</td>
      </tr>
    [/#list]
  [/@properties.table]

  [#-- Events --]
  <h3>[@message.print key="events-enabled"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print key="events"/]</th>
        <th>[@message.print key="system"/]</th>
        <th>[@message.print key="enabled"/]</th>
      </tr>
    </thead>
    <tbody>
      [#list webhook.eventsEnabled as eventType, enabled]
        <tr>
          <td>${eventType.eventName()}</td>
          <td>${properties.displayBoolean(eventType, "instanceEvent")}</td>
          <td>[@properties.displayCheck enabled/]</td>
        </tr>
      [/#list]
    </tbody>
  </table>

  [#if (webhook.data)?? && webhook.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(webhook.data)}</pre>
  [/#if]
[/@dialog.view]
