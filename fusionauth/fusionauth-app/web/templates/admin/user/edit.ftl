[#ftl/]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "./_macros.ftl" as userMacros/]

[@layout.html]
  [@layout.head]
  <script src="${request.contextPath}/js/admin/User.js?version=${version}"></script>
  <script>
    // Provided the User's ordered preferred languages so that we can preserve this in the MultiSelect widget
    var preferredLanguages = [[#list user.preferredLanguages as l]'${l}'[#if !l?is_last],[/#if][/#list]];
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.User(preferredLanguages);
    });
  </script>
  [/@layout.head]
  [@layout.body]

    [#assign editTitle = ((ftlCurrentUser?? && ftlCurrentUser.id == userId)?then('edit-profile', 'page-title'))/]
    [@control.form action="edit" method="POST" class="labels-left full" id="user-form"]
      [@layout.pageHeader titleKey=editTitle includeSave=true includeCancel=true cancelURI="/admin/user/manage/${userId}?tenantId=${user.tenantId}" breadcrumbs={"/admin/user/": "users", "/admin/user/edit/${userId}?tenantId=${user.tenantId}": "edit"}/]
      [@layout.main]
        [@panel.full]
          [@userMacros.userFormFields "edit"/]
        [/@panel.full]
      [/@layout.main]
    [/@control.form]

  [/@layout.body]
[/@layout.html]