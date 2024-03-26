[#ftl/]
[#-- @ftlvariable name="fieldId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as fieldMacros/]


[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.FieldForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${fieldId}" method="POST" id="field-form" panelTitleKey="" cancelURI="/admin/field/" breadcrumbs={"": "customizations",  "/admin/field/": "fields", "/admin/field/edit/${fieldId}": "edit"}]
      [@fieldMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
