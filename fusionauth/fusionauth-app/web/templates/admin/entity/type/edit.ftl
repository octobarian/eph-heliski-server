[#ftl/]
[#-- @ftlvariable name="entityTypeId" type="java.util.UUID" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as entityTypeMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.EntityTypeForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${entityTypeId}" method="POST" id="entity-type-form" includeSave=true includeCancel=true cancelURI="/admin/entity/type/"
                      breadcrumbs={"": "entity-management", "/admin/entity/type/": "entity-types", "/admin/entity/type/edit/${entityTypeId}": "edit"}]
      [@entityTypeMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]