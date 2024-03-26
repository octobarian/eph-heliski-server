[#ftl/]
[#-- @ftlvariable name="postDataToExternalIDP" type="io.fusionauth.app.service.identityProvider.IdentityProviderFrontendService.PostDataToExternalIDP" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
<html lang="en">
  <body>
    <form action="${postDataToExternalIDP.uri}" method="POST" >
      [#list postDataToExternalIDP.formData as key,value]
        <input type="hidden" name="${key!""}" value="${value!""}"/>
      [/#list]
    </form>
    <script type="text/javascript">
      document.forms[0].submit();
    </script>
  </body>
</html>
