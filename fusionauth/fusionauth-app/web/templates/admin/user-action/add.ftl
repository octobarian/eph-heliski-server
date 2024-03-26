[#ftl/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as userActionMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.UserActionForm();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" includeSave=true includeCancel=true cancelURI="/admin/user-action/" breadcrumbs={"": "settings", "/admin/user-action/": "user-actions", "/admin/user-action/add": "add"}]
      [@userActionMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]