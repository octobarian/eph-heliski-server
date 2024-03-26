[#ftl/]
[#-- @ftlvariable name="permission" type="io.fusionauth.domain.EntityTypePermission" --]

[#import "../../../../_utils/dialog.ftl" as dialog/]
[#import "../../../../_utils/message.ftl" as message/]

[@dialog.form action="add" formClass="labels-left full"]
<fieldset>
  [@control.hidden name="entityTypeId"/]
  [@control.text name="permission.name" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true /]
  [@control.text name="permission.description" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=message.inline('{tooltip}displayOnly')/]
  [@control.checkbox name="permission.isDefault" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}permission.isDefault')/]
</fieldset>
[/@dialog.form]
