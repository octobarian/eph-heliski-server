[#ftl/]
[#-- @ftlvariable name="userAction" type="io.fusionauth.domain.UserAction" --]
[#-- @ftlvariable name="userActionId" type="java.util.UUID" --]

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
    [@layout.pageForm action="edit/${userActionId}" method="POST" includeSave=true includeCancel=true cancelURI="/admin/user-action/" breadcrumbs={"": "settings", "/admin/user-action/": "user-actions", "/admin/user-action/edit/${userActionId}": "edit"}]
      [@userActionMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]