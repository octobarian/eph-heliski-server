[#ftl/]
[#-- @ftlvariable name="webhookId" type="java.util.UUID" --]

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
    [@layout.pageForm action="edit/${webhookId}" method="POST" id="webhook-form" panelTitleKey="" cancelURI="/admin/webhook/" breadcrumbs={"": "settings", "/admin/webhook/": "webhooks", "/admin/webhook/edit/${webhookId}": "edit"}]
      [@webhookMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
