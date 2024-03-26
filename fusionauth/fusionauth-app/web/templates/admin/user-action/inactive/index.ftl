[#ftl/]
[#-- @ftlvariable name="userActions" type="java.util.List<io.fusionauth.domain.UserAction>" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../_macros.ftl" as userActionApplication/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeBack=true backURI="/admin/user-action/" breadcrumbs={"": "settings", "/admin/user-action": "user-actions", "/admin/user-action/inactive/": "inactive"}/]
    [@layout.main]
      [@panel.full]
        [@userActionApplication.userActionsTable true/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]