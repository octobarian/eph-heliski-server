[#ftl/]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as themeMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        var templateNames = [[#list fusionAuth.statics['io.fusionauth.domain.Theme$Templates'].Names as templateName]"${templateName}"[#if !templateName?is_last],[/#if][/#list][#t]];
        new FusionAuth.Admin.ThemeForm(templateNames);
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="theme-form" cancelURI="/admin/theme/"  breadcrumbs={"": "customizations", "/admin/theme/": "themes", "/admin/theme/add": "add"}]
      [@themeMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]