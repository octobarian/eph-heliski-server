[#ftl/]
[#-- @ftlvariable name="messengerId" type="java.util.UUID" --]
[#-- @ftlvariable name="messenger" type="io.fusionauth.domain.messenger.BaseMessengerConfiguration" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/messenger/" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"": "settings", "/admin/messenger/": "messengers", "/admin/messenger/delete/${messengerId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=messenger propertyName="name"/]
          [@properties.rowEval nameKey="type" object=messenger propertyName="type"/]
          [@properties.rowEval nameKey="id" object=messenger propertyName="id"/]
         [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="messengerId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
