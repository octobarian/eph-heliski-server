[#ftl/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as tenantMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.TenantForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="tenant-form" cancelURI="/admin/tenant/" breadcrumbs={"/admin/tenant/": "tenants", "/admin/tenant/add": "add"}]
      [@tenantMacros.tenantFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]