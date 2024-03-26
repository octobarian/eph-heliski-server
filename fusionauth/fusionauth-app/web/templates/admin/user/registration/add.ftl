[#ftl/]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="registration" type="io.fusionauth.domain.UserRegistration" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "_macros.ftl" as registrationMacros/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" class="labels-left full" id="registration-form" cancelURI="/admin/user/manage/${userId}?tenantId=${tenantId}" breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${userId}?tenantId=${tenantId}": "manage", "/admin/user/registration/add/${userId}?tenantId=${tenantId}": "user-registration"}]
      [@registrationMacros.formFields action="add"/]
      [#-- Loading this JavaScript inside the form tag because we may load up default roles in a form prepare method.
           - When the user adding this registration cannot edit roles, the default roles will be populated to indicate which
             roles will be assigned as a result of this add action.
           - When the user can edit roles, the registration.roles will be empty like normal.
      --]
      <script>
        Prime.Document.onReady(function() {
          [#if registration??]
            new FusionAuth.Admin.UserRegistrationForm([[#list registration.roles as role]'${role}'[#if !role?is_last],[/#if][/#list]], []);
          [#else]
            new FusionAuth.Admin.UserRegistrationForm([], []);
          [/#if]
        });
      </script>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]