[#ftl/]
[#-- @ftlvariable name="connectors" type="java.util.List<io.fusionauth.domain.connector.BaseConnectorConfiguration>" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[#macro fields action]
<fieldset>
  [#list connectors as connector]
  <input type="hidden" data-name="${connector.name}" data-type="${connector.type}" data-id="${connector.id}"/>
  [/#list]
  [@control.select items=connectors name="connectorId" textExpr="name" valueExpr="id" headerValue="" headerL10n="selection-required"/]
  [@control.textarea name="connectorDomains" defaultValue="*" wideTooltip=message.inline("{tooltip}connectorDomains")/]
  [@control.checkbox name="connectorMigrate" wideTooltip=message.inline("{tooltip}connectorMigrate") value="true" uncheckedValue="false"/]
</fieldset>
[/#macro]

