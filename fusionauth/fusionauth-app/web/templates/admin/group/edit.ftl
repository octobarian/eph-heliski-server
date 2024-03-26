[#ftl/]
[#-- @ftlvariable name="groupId" type="java.util.UUID" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as groupMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.GroupForm();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit" method="POST" id="group-form" cancelURI="/admin/group/" breadcrumbs={"/admin/group/": "groups", "/admin/group/edit/${groupId}?tenantId=${tenantId}": "edit"}]
      [@groupMacros.groupFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]