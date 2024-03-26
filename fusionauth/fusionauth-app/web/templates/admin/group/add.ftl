[#ftl/]
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
    [@layout.pageForm action="add" method="POST" id="group-form" cancelURI="/admin/group/" breadcrumbs={"/admin/group/": "groups", "/admin/group/add": "add"}]
      [@groupMacros.groupFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]