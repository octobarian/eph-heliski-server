[#ftl/]
[#-- @ftlvariable name="formPostResponse" type="io.fusionauth.app.action.oauth2.BaseOAuthAction.FormPostResponse" --]
[#-- @ftlvariable name="locale" type="java.util.Locale" --]
[#-- @ftlvariable name="redirect_uri" type="java.net.URI" --]
[#-- @ftlvariable name="scope" type="java.lang.String" --]
[#-- @ftlvariable name="state" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="userState" type="java.lang.String" --]
<html lang="en">
  <body>
    <form action="${redirect_uri}" method="POST" >

      [#if formPostResponse?has_content]
        [#if formPostResponse.accessToken?has_content]
          [#if formPostResponse.accessToken.token?has_content]
            <input type="hidden" name="access_token" value="${formPostResponse.accessToken.token}"/>
          [/#if]
          [#if formPostResponse.accessToken.expiresIn?has_content]
            <input type="hidden" name="expires_in" value="${formPostResponse.accessToken.expiresIn}"/>
          [/#if]
          [#if formPostResponse.accessToken.idToken?has_content]
            <input type="hidden" name="id_token" value="${formPostResponse.accessToken.idToken}"/>
          [/#if]
          [#if formPostResponse.accessToken.tokenType?has_content]
            <input type="hidden" name="token_type" value="${formPostResponse.accessToken.tokenType}"/>
          [/#if]
        [/#if]

        [#if formPostResponse.code?has_content]
          <input type="hidden" name="code" value="${formPostResponse.code}"/>
        [/#if]
        [#if formPostResponse.scope?has_content]
          <input type="hidden" name="scope" value="${formPostResponse.scope}"/>
        [/#if]
      [/#if]

      [#if locale?has_content]
        <input type="hidden" name="locale" value="${locale}"/>
      [/#if]
      [#if state?has_content]
        <input type="hidden" name="state" value="${state}"/>
      [/#if]
      [#if userState?has_content]
        <input type="hidden" name="userState" value="${userState}"/>
      [/#if]
    </form>
    <script type="text/javascript">
      document.forms[0].submit();
    </script>
  </body>
</html>
