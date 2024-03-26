[#ftl/]
[#-- @ftlvariable name="type" type="java.lang.String" --]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as identityProviderMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.IdentityProviderForm("${type}");
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="identity-provider-form" pageTitleKey="add-${type}" includeSave=true includeCancel=true cancelURI="/admin/identity-provider/"  breadcrumbs={"": "settings", "/admin/identity-provider/": "identity-providers", "/admin/identity-provider/add/${type}": "add"}]
      [@identityProviderMacros.identityProviderFields identityProvider=identityProvider action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]