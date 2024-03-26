[#ftl/]
[#-- @ftlvariable name="report" type="io.fusionauth.app.action.admin.ProxyConfigTestAction.ProxyConfigReport" --]
[#import "../_utils/panel.ftl" as panel/]

<html lang="en">
<body>
[#if report??]
  [#-- Is the Proxy Config Screwed up? --]
  [#if report.failed]
    <div id="result">
      [@panel.full titleKey="proxy-configuration-warning" rowClass="row push-more-bottom" panelClass="panel orange" mainClass="ro2w"]
        <p>
          It appears that FusionAuth is running behind a proxy server and your configuration is not correct.
        </p>
        <p>
          Your browser reported a request origin that is not equal to the actual HTTP request. Because these are not equal we will fail CSRF (Cross Site Request Forgery) validation when you submit a form that is using the POST method. If you attempt to create an Application, API key, User, etc you will receive an <strong class="red-text">Unauthorized</strong> message.
        </p>

        <p>Reported request origin:</p>
        <pre class="code">${report.expectedOrigin}</pre>

        <p>Actual request origin:</p>
        <pre class="code">${report.actualOrigin}</pre>

        [#if report.actualHeaders?has_content]
          <p>The following X-Forwarded- HTTP request headers were detected on the request:</p>
          <pre class="code">[#list report.actualHeaders as key, value]${key}: ${value!''}<br>[/#list]</pre>
        [/#if]

        [#if report.requiredHeaders?has_content]
          <p>To correct the origin, add the following request headers through your proxy configuration:</p>
          <pre class="code">[#list report.requiredHeaders as key, value]${key}: ${value!''}<br>[/#list]</pre>
        [/#if]

      [/@panel.full]
    </div>
    <script type="text/javascript">
      if (window.parent) {
        var html = document.getElementById('result').innerHTML;
        var nonce = "${context.getAttribute("ProxyTestNonce")}";
        window.parent.postMessage({html: html, nonce: nonce}, '*');
      }
    </script>
  [/#if]
[#else]
  <form method="POST" action="${request.contextPath}/admin/proxy-config-test">
  </form>
  <script type="application/javascript">
    document.forms[0].submit();
  </script>
[/#if]
</body>
</html>
