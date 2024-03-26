[#ftl/]

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
    [@layout.pageForm action="add" method="POST" id="ip-acl-form" panelTitleKey="" cancelURI="/admin/ip-acl/" breadcrumbs={"": "settings", "/admin/ip-acl/": "ip-acls", "/admin/ip-acl/add": "add"}]
      [@aclMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]