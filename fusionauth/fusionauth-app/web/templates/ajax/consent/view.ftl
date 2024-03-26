[#ftl/]
[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=consent propertyName="name"/]
    [@properties.rowEval nameKey="id" object=consent propertyName="id"/]
    [@properties.rowEval nameKey="ageOfSelfConsent" object=consent propertyName="defaultMinimumAgeForSelfConsent" /]
    [@properties.rowEval nameKey="emailTemplateId" object=consent propertyName="emailTemplateId"/]
    [@properties.rowEval nameKey="values" object=consent propertyName="values"/]
    [@properties.rowEval nameKey="multipleValueAssignment" object=consent propertyName="multipleValuesAllowed" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="insertInstant" object=consent propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=consent propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#-- Email plus --]
  <h3>[@message.print key="email-plus"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="enabled" object=consent propertyName="emailPlus.enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="emailTemplateId" object=consent propertyName="emailPlus.emailTemplateId"/]
    [#assign minHours = properties.display(consent, "emailPlus.minimumTimeToSendEmailInHours") + " " + message.inline("HOURS") /]
    [@properties.row nameKey="minimumTimeToSendEmailInHours" value=minHours /]
    [#assign maxHours = properties.display(consent, "emailPlus.maximumTimeToSendEmailInHours") + " " + message.inline("HOURS") /]
    [@properties.row nameKey="maximumTimeToSendEmailInHours" value=maxHours /]
  [/@properties.table]

  [#-- Localized consent --]
  <h3>[@message.print key="localized-consent"/]</h3>
  [@properties.table]
      [#list consent.countryMinimumAgeForSelfConsent as locale, age]
        [@properties.rowRaw locale.getDisplayName() age/]
      [#else]
        <tr>
          <td colspan="2">[@message.print key="no-localized-consent"/]</td>
        </tr>
      [/#list]
  [/@properties.table]

  [#if (consent.data)?? && consent.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(consent.data)}</pre>
  [/#if]
[/@dialog.view]
