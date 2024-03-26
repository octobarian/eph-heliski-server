[#ftl/]
[#-- @ftlvariable name="permission" type="io.fusionauth.domain.EntityTypePermission" --]

[#import "../../../../_utils/dialog.ftl" as dialog/]
[#import "../../../../_utils/properties.ftl" as properties/]

[@dialog.confirm action="delete" key="warn" idField="entityTypeId" idField2="permissionId"]
  <fieldset>
    [@properties.table]
      [@properties.rowEval nameKey="name" object=permission propertyName="name"/]
      [@properties.rowEval nameKey="id" object=permission propertyName="id"/]
    [/@properties.table]
  </fieldset>
[/@dialog.confirm]
