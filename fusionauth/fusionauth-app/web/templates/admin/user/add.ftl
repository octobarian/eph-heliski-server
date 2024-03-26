[#ftl/]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "./_macros.ftl" as userMacros/]
[#import "../../_utils/helpers.ftl" as helpers/]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/User.js?version=${version}"></script>
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.User([]);
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="user-form" includeSave=true includeCancel=true cancelURI="/admin/" breadcrumbs={"/admin/user/": "users", "/admin/user/add": "add"}]
      [#if tenantId??]
        [@control.hidden name="tenantId"/]
        [#if tenants?size > 1]
          [#-- Use an empty name so we don't end up with duplicate Ids in the DOM --]
          [@control.text name="" labelKey="tenant" value=helpers.tenantName(tenantId) autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
        [/#if]
        [@userMacros.userFormFields "add"/]
      [#else]
        [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=true headerL10n="selection-required" headerValue="" tooltip=function.message('{tooltip}tenant')/]
      [/#if]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]