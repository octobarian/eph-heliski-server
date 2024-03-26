[#ftl/]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
<html lang="en">
  <body>
    <form id="implicit-callback" action="${request.contextPath}/oauth2/callback" method="POST">
    </form>
    <script type="text/javascript">
      var form = document.getElementById('implicit-callback');
      var fragment = window.location.hash;

      if (typeof(fragment) !== 'undefined') {
        [#-- Collect everything we can get from the URl and add it to the form --]
        var data = {};
        fragment.substring(1).split("&").forEach(function(part) {
          var item = part.split("=");
          if (item.length === 2) {
            var hidden = document.createElement('input');
            hidden.setAttribute('type', 'hidden');
            hidden.setAttribute('name', item[0]);
            hidden.setAttribute('value', item[1]);
            form.appendChild(hidden);
          }
        });
      }

      form.submit();
    </script>
  </body>
</html>
