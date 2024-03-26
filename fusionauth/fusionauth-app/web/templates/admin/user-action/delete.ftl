[#ftl/]
[#-- @ftlvariable name="userAction" type="io.fusionauth.domain.UserAction" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/user-action/${userAction.active?then('', 'inactive/')}" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"": "settings", "/admin/user-action/": "user-actions", "/admin/user-action/delete/${userAction.id}": "page-title"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=userAction propertyName="name"/]
          [@properties.rowEval nameKey="id" object=userAction propertyName="id"/]
        [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="userActionId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" /]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]