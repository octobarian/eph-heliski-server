[#ftl/]
<html lang="en">
  <body>
    <form action="${request.contextPath}/password/change" method="POST">
      <input type="hidden" name="postBack" value="true"/>
      [@control.hidden name="rememberDevice"/]
      [#list request.parameters as key,value]
        [#list value as v]
        <input type="hidden" name="${key!""}" value="${v!""}"/>
        [/#list]
      [/#list]
    </form>
    <script type="text/javascript">
      document.forms[0].submit();
    </script>
  </body>
</html>