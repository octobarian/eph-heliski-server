[#ftl/]
[#-- @ftlvariable name="entityType" type="io.fusionauth.domain.EntityType" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/entity/type/"
                      saveColor="red" saveKey="delete" saveIcon="trash"
                      breadcrumbs={"": "entity-management", "/admin/entity/type/": "entity-types", "/admin/entity/type/delete/${entityType.id}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=entityType propertyName="name"/]
          [@properties.rowEval nameKey="id" object=entityType propertyName="id"/]
        [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="entityTypeId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" /]
        [@message.showFieldErrors fieldName="entityTypeId"/]
        [@message.showAPIErrorRespones storageKey="io.fusionauth.entity.type.delete.errors"/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]