[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as webhookMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.WebhookForm(Prime.Document.queryById('webhook-form'));
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="webhook-form" panelTitleKey="" cancelURI="/admin/webhook/" breadcrumbs={"": "settings", "/admin/webhook/": "webhooks", "/admin/webhook/add": "add"}]
      [@webhookMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]