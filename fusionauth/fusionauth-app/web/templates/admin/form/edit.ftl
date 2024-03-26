[#ftl/]
[#-- @ftlvariable name="formId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as formMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.FormForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${formId}" method="POST" id="form-form" panelTitleKey="" cancelURI="/admin/form/" breadcrumbs={"": "customizations", "/admin/form/": "forms", "/admin/form/edit/${formId}": "edit"}]
      [@formMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
