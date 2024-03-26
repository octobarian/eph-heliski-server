[#ftl/]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "_macros.ftl" as messageTemplateMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.MessageTemplateForm(Prime.Document.queryById('message-template-form'));
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="message-template-form" includeSave=true includeCancel=true cancelURI="/admin/message/template/"  breadcrumbs={"": "customizations", "/admin/message/template/": "message-templates", "/admin/message/template/add": "add"}]
      [@messageTemplateMacros.template action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]