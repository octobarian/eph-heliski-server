[#ftl/]

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
    [@layout.pageForm action="add" method="POST" id="form-form" panelTitleKey="" cancelURI="/admin/form/" breadcrumbs={"": "customizations", "/admin/form/": "forms", "/admin/form/add": "add"}]
      [@formMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]