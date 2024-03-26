[#ftl/]
[#-- @ftlvariable name="userActionReason" type="io.fusionauth.domain.UserActionReason" --]
[#-- @ftlvariable name="userActionReasonId" type="java.util.UUID" --]

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
    [@layout.pageForm action="edit" method="POST" id="user-action-reason-form" panelTitleKey="" cancelURI="/admin/user-action/reason/" breadcrumbs={"": "settings", "/admin/user-action/": "user-actions", "/admin/user-action/reason/": "user-action-reasons", "/admin/user-action/reason/edit/${userActionReasonId}": "edit"}]
      [@userActionReasonMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
