[#ftl/]
[#-- @ftlvariable name="messageTemplate" type="io.fusionauth.domain.message.MessageTemplate" --]
[#-- @ftlvariable name="renderedMessage" type="io.fusionauth.domain.message.sms.SMSMessage" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=messageTemplate propertyName="name"/]
    [@properties.rowEval nameKey="id" object=messageTemplate propertyName="id"/]
    [@properties.rowEval nameKey="insertInstant" object=messageTemplate propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=messageTemplate propertyName="lastUpdateInstant"/]
    <tr>
      <td class="top">[@message.print key="template"/]</td>
      <td>
        <pre class="preview">${properties.display(renderedMessage, "textMessage")}</pre>
      </td>
    </tr>
    <tr>
      <td>[@message.print key="localized-versions"/]</td>
      <td>
        <ul>
          [#list (messageTemplate.localizedTemplates?keys)![] as locale]
            <li>${properties.display(locale, "displayName")}</li>
          [#else]
            <li>[@message.print key="no-localized-versions"/]</li>
          [/#list]
        </ul>
      </td>
    </tr>
  [/@properties.table]
[/@dialog.view]
