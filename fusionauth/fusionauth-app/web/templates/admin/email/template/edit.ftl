[#ftl/]
[#-- @ftlvariable name="emailTemplateId" type="java.util.UUID" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "_macros.ftl" as emailTemplateMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.EmailTemplateForm(Prime.Document.queryById('email-template-form'));
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit" method="POST" id="email-template-form" includeSave=true includeCancel=true cancelURI="/admin/email/template/"  breadcrumbs={"": "customizations", "/admin/email/template/": "email-templates", "/admin/email/template/edit/${emailTemplateId}": "edit"}]
      [@emailTemplateMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
