[#ftl/]
[#-- @ftlvariable name="groupId" type="java.util.UUID" --]
[#-- @ftlvariable name="group" type="io.fusionauth.domain.Group" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/group/" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"/admin/group/": "groups", "/admin/group/delete?groupId=${groupId}&tenantId=${tenantId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
      [@properties.table]
        [@properties.rowEval nameKey="name" object=group propertyName="name"/]
        [@properties.rowEval nameKey="id" object=group propertyName="id"/]
        [@properties.row nameKey="tenant" value=helpers.tenantName(tenantId)/]
        [@properties.rowEval nameKey="tenantId" object=group propertyName="tenantId"/]
      [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="groupId"/]
        [@control.hidden name="tenantId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
