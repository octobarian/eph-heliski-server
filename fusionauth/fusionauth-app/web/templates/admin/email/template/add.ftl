[#ftl/]

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
    [@layout.pageForm action="add" method="POST" id="email-template-form" includeSave=true includeCancel=true cancelURI="/admin/email/template/"  breadcrumbs={"": "customizations", "/admin/email/template/": "email-templates", "/admin/email/template/add": "add"}]
      [@emailTemplateMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]