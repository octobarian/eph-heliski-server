[#ftl/]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/user/manage/${userId}?tenantId=${tenantId}" saveColor="red" saveIcon="trash" saveKey="delete" breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${userId}?tenantId=${tenantId}": "manage", "/admin/user/delete/${userId}?tenantId=${tenantId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
       [@properties.table]
          [@properties.rowEval nameKey="email" object=user propertyName="email"/]
          [@properties.rowEval nameKey="name" object=user propertyName="name"/]
          [@properties.rowEval nameKey="id" object=user propertyName="id"/]
          [@properties.row nameKey="tenant" value=helpers.tenantName(tenantId)/]
          [@properties.rowEval nameKey="tenantId" object=user propertyName="tenantId"/]
          [@properties.rowEval nameKey="created" object=user propertyName="insertInstant"/]
          [@properties.rowEval nameKey="last-login" object=user propertyName="lastLoginInstant"/]
       [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="userId"/]
        [@control.hidden name="tenantId"/]
        [@control.text name="confirm" autocapitalize="none" autofocus="autofocus" autocomplete="off" autocorrect="off" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
