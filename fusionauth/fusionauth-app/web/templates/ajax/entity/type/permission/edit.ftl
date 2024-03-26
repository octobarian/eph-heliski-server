[#ftl/]
[#-- @ftlvariable name="permission" type="io.fusionauth.domain.EntityTypePermission" --]

[#import "../../../../_utils/dialog.ftl" as dialog/]
[#import "../../../../_utils/message.ftl" as message/]

[@dialog.form action="edit" formClass="labels-left full"]
<fieldset>
  [@control.hidden name="entityTypeId"/]
  [@control.hidden name="permissionId"/]
  [@control.text name="permission.name" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" disabled=true tooltip=message.inline('{tooltip}readOnly') /]
  [@control.hidden name="permission.name"/] [#-- This keeps the name if the form fails validation since the text field is disabled --]
  [@control.text name="permission.description" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=message.inline('{tooltip}displayOnly')/]
  [@control.checkbox name="permission.isDefault" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}permission.isDefault')/]
</fieldset>
[/@dialog.form]
