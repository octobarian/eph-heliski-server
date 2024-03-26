[#ftl/]

[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as applicationMacros/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/application/${(application.state == 'Active')?then('', 'inactive/')}" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"/admin/application/": "applications", "/admin/application/delete/${applicationId}?tenantId=${tenantId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
         [@properties.table]
          [@properties.rowEval nameKey="name" object=application propertyName="name"/]
          [@properties.rowEval nameKey="id" object=application propertyName="id"/]
          [@properties.row nameKey="tenant" value=helpers.tenantName(tenantId)/]
          [@properties.rowEval nameKey="tenantId" object=application propertyName="tenantId"/]
         [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="applicationId"/]
        [@control.hidden name="tenantId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
