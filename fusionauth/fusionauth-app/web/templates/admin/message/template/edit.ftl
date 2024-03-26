[#ftl/]
[#-- @ftlvariable name="messageTemplateId" type="java.util.UUID" --]

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
    [@layout.pageForm action="edit" method="POST" id="message-template-form" includeSave=true includeCancel=true cancelURI="/admin/message/template/"  breadcrumbs={"": "customizations", "/admin/message/template/": "message-templates", "/admin/message/template/edit/${messageTemplateId}": "edit"}]
      [@messageTemplateMacros.template action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
