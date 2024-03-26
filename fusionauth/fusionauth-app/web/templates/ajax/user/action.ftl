[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="userActions" type="java.util.List<io.fusionauth.domain.UserAction>" --]
[#-- @ftlvariable name="userActionReasons" type="java.util.List<io.fusionauth.domain.UserActionReason>" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "_macros.ftl" as actionMacros/]

[#if !userActions?? || userActions?size == 0]
  [@dialog.view titleKey="title"]
    [@message.print key="user-actions-disabled"/]
  [/@dialog.view]
[#elseif user.active]
  [@dialog.form action="${request.contextPath}/ajax/user/action/${userId}" formClass="labels-left full" id="user-actioning-form"]
    [#--
      These selects are a bit complicated. The first select lists all of the actions. It usees a feature I added to
      Prime MVC that allows arbitrary properties of each object in the items collection to be output as data- attributes
      on the <option> elements. This will allow the JavaScript to determine if an action allows emailing.

      The other select boxes are each for the options of the action. These can be shown and hidden based on the id of
      the selected action. However, the ones that are hidden also need to have their names removed so that they are not
      sent when the form is submitted.
    --]
    <fieldset>
      [@control.select items=userActions textExpr="name" valueExpr="id" headerValue="" headerL10n="select-an-action" name="action.userActionId" required=true dataProperties=["userEmailingEnabled", "temporal", "preventLogin", "userNotificationsEnabled"]/]
      <div id="user-action-inputs">
        <fieldset>
          [#list userActions as userAction]
            [#if userAction.options?size > 0]
              <div id="${userAction.id}_options" class="action-options">
                [@control.select items=userAction.options textExpr="name" valueExpr="name" name="action.option"/]
              </div>
            [/#if]
          [/#list]
        </fieldset>
        <div data-dependant-controls>
          [@actionMacros.expirationControls/]
          [#if userActionReasons?? && userActionReasons?size > 0]
            [@control.select items=userActionReasons textExpr="text" valueExpr="id" name="action.reasonId" headerValue="" headerL10n="select-a-reason"/]
          [/#if]
          [@control.checkbox_list items=applications textExpr="name" valueExpr="id" name="action.applicationIds" headerValue="" headerL10n="all-applications"/]
          <div class="form-row">
            <label></label>
            <div class="inline-block">
              <span id="preventLogin-description">[@message.print key="preventLogin-description"/]</span>
            </div>
          </div>
          [@control.textarea name="action.comment" autocapitalize="on" autocomplete="on" autocorrect="on" class="textarea resize vertical"/]
          <div id="notify-user-checkbox">
            [@control.checkbox name="action.notifyUser"/]
          </div>

          <div id="email-user-checkbox">
            [@control.checkbox name="action.emailUser"/]
          </div>
        </div>
      </div>

    </fieldset>
  [/@dialog.form]
[#else]
  [#--Don't allow actions when the user is locked (inactive)--]
  [@dialog.view titleKey="title"]
    [@message.print key="user-locked-actions-disabled"/]
  [/@dialog.view]
[/#if]
