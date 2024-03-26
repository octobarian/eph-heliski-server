[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="systemConfiguration" type="io.fusionauth.domain.SystemConfiguration" --]
[#-- @ftlvariable name="themes" type="java.util.List<io.fusionauth.domain.Theme>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/helpers.ftl" as helpers/]
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
    [@control.form action="edit" method="POST" class="labels-left full" id="application-form"]
      [@layout.pageHeader includeSave=true includeCancel=true cancelURI="/admin/application/" breadcrumbs={"/admin/application/": "applications", "/admin/application/edit?applicationId=${applicationId}&tenantId=${tenantId}": "edit"}]
        [#if applicationId != fusionAuthId]
          [@button.iconLink href="manage-roles?applicationId=" + applicationId color="purple" icon="user" tooltipKey="manage-roles"/]
        [/#if]
      [/@layout.pageHeader]
      [@layout.main]
        [@panel.full]
          <fieldset>
            [@control.hidden name="tenantId"/]
            [@control.hidden name="applicationId"/]
            [#-- Hard code the Id so we don't get browser warnings because two elements will have the same Id. --]
            [@control.text name="applicationId" id="_applicationId" autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
            [#if tenants?size > 1]
              [@control.text name="tenantId" labelKey="tenant" value=helpers.tenantName(tenantId) autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
            [/#if]
            [@control.text name="application.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
            [@control.select items=themes name="application.themeId" textExpr="name" valueExpr="id" required=false headerL10n="none-selected-use-tenant-theme" headerValue="" tooltip=function.message('{tooltip}application.themeId')/]
          </fieldset>
          <fieldset class="mt-4">
            [@applicationMacros.configurations "edit"/]
          </fieldset>
        [/@panel.full]
      [/@layout.main]
    [/@control.form]
  [/@layout.body]
[/@layout.html]
