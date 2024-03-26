[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="systemConfiguration" type="io.fusionauth.domain.SystemConfiguration" --]
[#-- @ftlvariable name="themes" type="java.util.List<io.fusionauth.domain.Theme>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as applicationMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.ApplicationForm();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="application-form" includeSave=true includeCancel=true cancelURI="/admin/application/"  breadcrumbs={"/admin/application/": "applications", "/admin/application/add": "add"}]
      <fieldset>
        [@control.text name="applicationId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
        [@control.text name="application.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
        [#if tenants?size == 1]
          [@control.hidden name="tenantId" value=tenants?keys?first/]
        [#else]
          [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=true headerL10n="selection-required" headerValue="" tooltip=function.message('{tooltip}tenant')/]
        [/#if]
        [@control.select items=themes name="application.themeId" textExpr="name" valueExpr="id" required=false headerL10n="none-selected-use-tenant-theme" headerValue="" tooltip=function.message('{tooltip}application.themeId')/]
      </fieldset>
      <fieldset class="mt-4">
        [@applicationMacros.configurations "add"/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]