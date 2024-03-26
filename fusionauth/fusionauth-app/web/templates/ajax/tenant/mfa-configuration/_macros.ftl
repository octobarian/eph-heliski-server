[#ftl/]
[#-- @ftlvariable name="templates" type="java.util.List<io.fusionauth.domain.message.MessageTemplate>" --]
[#-- @ftlvariable name="types" type="java.util.List<io.fusionauth.domain.message.MessageType>" --]
[#-- @ftlvariable name="messengers" type="java.util.List<io.fusionauth.domain.messenger.BaseMessengerConfiguration>" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[#macro fields action]
<fieldset>
  [#list templates as template]
  <input type="hidden" data-type="${template.type}" data-id="${template.id}"/>
  [/#list]
  [@control.select items=types name="type" wideTooltip=message.inline("{tooltip}messageType")/]
  [@control.select items=templates name="template" textExpr="name" valueExpr="id" wideTooltip=message.inline("{tooltip}template")/]
  [@control.select items=messengers name="messenger" textExpr="name" valueExpr="id" wideTooltip=message.inline("{tooltip}messenger")/]
</fieldset>
[/#macro]

