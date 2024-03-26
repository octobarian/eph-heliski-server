[#ftl/]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as userActionReasonMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.UserActionReasonForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="user-action-reason-form" panelTitleKey="" cancelURI="/admin/user-action/reason/" breadcrumbs={"": "settings", "/admin/user-action/": "user-actions", "/admin/user-action/reason/": "user-action-reasons", "/admin/user-action/reason/add": "add"}]
      [@userActionReasonMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
