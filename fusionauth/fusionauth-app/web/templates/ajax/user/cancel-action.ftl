[#ftl/]
[#-- @ftlvariable name="actionId" type="java.util.UUID" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "_macros.ftl" as local/]

[@dialog.form action="${request.contextPath}/ajax/user/cancel-action/${actionId}" formClass="full"]
<fieldset>
  [@control.textarea name="action.comment" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus"/]
  [#if userAction.userNotificationsEnabled]
    [@control.checkbox name="action.notifyUser"/]
  [/#if]
  [#if userAction.userEmailingEnabled]
    [@control.checkbox name="action.emailUser"/]
  [/#if]
</fieldset>
[/@dialog.form]