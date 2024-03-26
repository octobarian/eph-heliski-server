[#ftl/]
[#-- @ftlvariable name="ipAccessControlListId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as aclMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.ACLForm(Prime.Document.queryById('ip-acl-form'));
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${ipAccessControlListId}" method="POST" id="ip-acl-form" panelTitleKey="" cancelURI="/admin/ip-acl/" breadcrumbs={"": "settings", "/admin/ip-acl/": "ip-acls", "/admin/ip-acl/edit/${ipAccessControlListId}": "edit"}]
      [@aclMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
