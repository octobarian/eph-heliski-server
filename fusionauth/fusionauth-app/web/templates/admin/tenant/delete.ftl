[#ftl/]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/tenant/" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"/admin/tenant/": "tenants", "/admin/tenant/delete?tenantId=${tenantId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=tenant propertyName="name"/]
          [@properties.rowEval nameKey="id" object=tenant propertyName="id"/]
        [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="tenantId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
