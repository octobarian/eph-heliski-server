[#ftl/]
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

    [@layout.pageForm action="add" method="POST" id="entity-type-form" includeSave=true includeCancel=true cancelURI="/admin/entity/type/"
                      breadcrumbs={"": "entity-management", "/admin/entity/type/": "entity-types", "/admin/entity/type/add": "add"}]
      [@entityTypeMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]