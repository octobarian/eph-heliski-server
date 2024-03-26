[#ftl/]
[#-- @ftlvariable name="entity" type="io.fusionauth.domain.Entity" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=entity propertyName="id"/]
    [@properties.rowEval nameKey="name" object=entity propertyName="name"/]
    [@properties.rowEval nameKey="clientId" object=entity propertyName="clientId"/]
    [@properties.rowEval nameKey="clientSecret" object=entity propertyName="clientSecret"/]
    [@properties.rowEval nameKey="tenantId" object=entity propertyName="tenantId"/]
    [@properties.rowEval nameKey="insertInstant" object=entity propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=entity propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="entityTypeDetails"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="typeId" object=entity propertyName="type.id"/]
    [@properties.rowEval nameKey="typeName" object=entity propertyName="type.name"/]
    [@properties.rowEval nameKey="permissionCount" object=entity propertyName="type.permissions.size()"/]
    [@properties.rowEval nameKey="insertInstant" object=entity propertyName="type.insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=entity propertyName="type.lastUpdateInstant"/]
  [/@properties.table]

  [#if (entity.data)?? && entity.data?has_content]
    <h3>[@message.print key="data"/]</h3>
    <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(entity.data)}</pre>
  [/#if]
[/@dialog.view]
