[#-- @ftlvariable name="logoutURI" type="java.lang.String" --]
[#-- @ftlvariable name="RelayState" type="java.lang.String" --]
[#-- @ftlvariable name="SAMLResponse" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
<html lang="en">
<body>
<form action="${logoutURI}" method="POST">
  <input type="hidden" name="RelayState" value="${RelayState!''}">
  <input type="hidden" name="SAMLResponse" value="${SAMLResponse}">
</form>
<script type="text/javascript">
  document.forms[0].submit();
</script>
</body>
</html>