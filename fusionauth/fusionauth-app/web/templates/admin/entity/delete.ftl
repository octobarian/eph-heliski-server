[#ftl/]
[#-- @ftlvariable name="entity" type="io.fusionauth.domain.Entity" --]
[#-- @ftlvariable name="entityId" type="java.util.UUID" --]

[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/entity/"
                      saveColor="red" saveKey="delete" saveIcon="trash"
                      breadcrumbs={"": "entity-management", "/admin/entity/": "entities", "/admin/entity/delete/${entityId}?tenantId=${tenantId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=entity propertyName="name"/]
          [@properties.rowEval nameKey="id" object=entity propertyName="id"/]
          [@properties.row nameKey="tenant" value=helpers.tenantName(tenantId)/]
          [@properties.rowEval nameKey="tenantId" object=entity propertyName="tenantId"/]
        [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="entityId"/]
        [@control.hidden name="tenantId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" /]
        [@message.showFieldErrors "entityId"/]
        [@message.showAPIErrorRespones storageKey="io.fusionauth.entity.delete.errors"/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]