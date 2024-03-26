[#ftl/]
[#-- @ftlvariable name="role" type="io.fusionauth.domain.ApplicationRole" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]

[@dialog.form action="edit-role" formClass="labels-left full"]
<fieldset>
  [@control.hidden name="applicationId"/]
  [@control.hidden name="roleId"/]
  [@control.text name="roleId" labelKey="id" autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
  [@control.text name="role.name" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true disabled=true/]
  [@control.hidden name="role.name"/] [#-- This keeps the name if the form fails validation since the text field is disabled --]
  [@control.text name="role.description" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=message.inline('{tooltip}displayOnly')/]
  [@control.checkbox name="role.isDefault" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}role.isDefault')/]
  [@control.checkbox name="role.isSuperRole" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}role.isSuperRole')/]
</fieldset>
[/@dialog.form]
