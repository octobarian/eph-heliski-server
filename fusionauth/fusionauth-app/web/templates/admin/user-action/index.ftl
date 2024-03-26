[#ftl/]
[#-- @ftlvariable name="userActions" type="java.util.List<io.fusionauth.domain.UserAction>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as userActionMacros/]

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
    [@layout.pageHeader includeAdd=true titleKey="page-title" breadcrumbs={"": "settings", "/admin/user-action/": "page-title"}]
      [@button.iconLink href="inactive/" color="gray" tooltipKey="view-deactivated" icon="trophy"/]
      [@button.iconLink href="reason/" color="purple" tooltipKey="user-action-reasons" icon="balance-scale"/]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full displayTotal=(userActions![])?size]
        [@userActionMacros.userActionsTable false/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]