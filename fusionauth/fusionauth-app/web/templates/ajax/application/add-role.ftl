[#ftl/]
[#-- @ftlvariable name="role" type="io.fusionauth.domain.ApplicationRole" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]

[@dialog.form action="add-role" formClass="labels-left full"]
<fieldset>
  [@control.hidden name="applicationId"/]
  [@control.text name="role.name" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true /]
  [@control.text name="role.description" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=message.inline('{tooltip}displayOnly')/]
  [@control.checkbox name="role.isDefault" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}role.isDefault')/]
  [@control.checkbox name="role.isSuperRole" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}role.isSuperRole')/]
</fieldset>
[/@dialog.form]
