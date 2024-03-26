[#ftl/]
[#-- @ftlvariable name="expires" type="java.lang.Boolean" --]
[#-- @ftlvariable name="actionId" type="java.util.UUID" --]
[#-- @ftlvariable name="userAction" type="io.fusionauth.domain.UserAction" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "_macros.ftl" as actionMacros/]

[@dialog.form action="${request.contextPath}/ajax/user/modify-action/${actionId}" formClass="full" id="user-actioning-form"]
<fieldset>
  [@actionMacros.expirationControls/]
  [@control.textarea name="action.comment" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus"/]
  [#if userAction.userNotificationsEnabled]
    [@control.checkbox name="action.notifyUser"/]
  [/#if]
  [#if userAction.userEmailingEnabled]
    [@control.checkbox name="action.emailUser"/]
  [/#if]
</fieldset>
[/@dialog.form]
