[#ftl/]
[#-- @ftlvariable name="registration" type="io.fusionauth.domain.UserRegistration" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as registrationMacros/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="edit" method="POST" class="labels-left full" id="registration-form" cancelURI="/admin/user/manage/${userId}?tenantId=${tenantId}" breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${userId}?tenantId=${tenantId}": "manage", "/admin/user/registration/edit/${userId}/${registration.applicationId}?tenantId=${tenantId}": "user-registration"}]
      [@registrationMacros.formFields action="edit"/]
      [#-- Loading this JavaScript inside the form tag because we are loading the current user's registration in a form prepare method. --]
      <script>
        // Provided the User's ordered preferred languages so that we can preserve this in the MultiSelect widget
        var preferredLanguages = [[#list registration.preferredLanguages as l]'${l}'[#if !l?is_last],[/#if][/#list]];
        var currentRoles = [[#list registration.roles as role]'${role}'[#if !role?is_last],[/#if][/#list]];

        Prime.Document.onReady(function() {
          new FusionAuth.Admin.UserRegistrationForm(currentRoles, preferredLanguages);
        });
      </script>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]