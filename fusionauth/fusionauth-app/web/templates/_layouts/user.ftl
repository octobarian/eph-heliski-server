[#ftl/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/button.ftl" as button/]
[#import "../_utils/panel.ftl" as panel/]

[#macro html]
<!DOCTYPE html>
<html lang="en">
  [#nested/]
</html>
[/#macro]

[#macro head]
<head>
  <title>[@message.print key="page-title"/] | FusionAuth</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="application-name" content="FusionAuth">
  <meta name="author" content="FusionAuth">
  <meta name="description" content="User Management Redefined. A Single Sign-On solution for your entire enterprise.">
  <meta name="keywords" content="fusionauth, sso, user management, login, registration, identity management">
  <meta name="robots" content="index, follow">

  [#-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy --]
  <meta name="referrer" content="strict-origin">

  [#-- Favicon Madness --]
  <link rel="apple-touch-icon-precomposed" sizes="57x57" href="${request.contextPath!''}/images/apple-touch-icon-57x57.png" />
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="${request.contextPath!''}/images/apple-touch-icon-114x114.png" />
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="${request.contextPath!''}/images/apple-touch-icon-72x72.png" />
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="${request.contextPath!''}/images/apple-touch-icon-144x144.png" />
  <link rel="apple-touch-icon-precomposed" sizes="60x60" href="${request.contextPath!''}/images/apple-touch-icon-60x60.png" />
  <link rel="apple-touch-icon-precomposed" sizes="120x120" href="${request.contextPath!''}/images/apple-touch-icon-120x120.png" />
  <link rel="apple-touch-icon-precomposed" sizes="128x128" href="${request.contextPath!''}/images/apple-touch-icon-120x120.png" />
  <link rel="apple-touch-icon-precomposed" sizes="76x76" href="${request.contextPath!''}/images/apple-touch-icon-76x76.png" />
  <link rel="apple-touch-icon-precomposed" sizes="152x152" href="${request.contextPath!''}/images/apple-touch-icon-152x152.png" />

  <link rel="icon" type="image/png" href="${request.contextPath!''}/images/favicon-196x196.png" sizes="196x196" />
  <link rel="icon" type="image/png" href="${request.contextPath!''}/images/favicon-128.png" sizes="128x128" />
  <link rel="icon" type="image/png" href="${request.contextPath!''}/images/favicon-96x96.png" sizes="96x96" />
  <link rel="icon" type="image/png" href="${request.contextPath!''}/images/favicon-32x32.png" sizes="32x32" />
  <link rel="icon" type="image/png" href="${request.contextPath!''}/images/favicon-16x16.png" sizes="16x16" />

  <meta name="msapplication-TileColor" content="#FFFFFF" />
  <meta name="msapplication-TileImage" content="${request.contextPath!''}/images/mstile-144x144.png" />
  <meta name="msapplication-square70x70logo" content="${request.contextPath!''}/images/mstile-70x70.png" />
  <meta name="msapplication-square150x150logo" content="${request.contextPath!''}/images/mstile-150x150.png" />
  <meta name="msapplication-wide310x150logo" content="${request.contextPath!''}/images/mstile-310x150.png" />
  <meta name="msapplication-square310x310logo" content="${request.contextPath!''}/images/mstile-310x310.png" />

  <link rel="stylesheet" href="${request.contextPath!''}/css/font-awesome-4.7.0.min.css"/>
  <link rel="stylesheet" href="${request.contextPath!''}/css/fusionauth-style.css?version=${version}"/>

  <script src="${request.contextPath!''}/js/prime-min-1.7.0.js?version=${version}"></script>
  <script>
    "use strict";
    Prime.Document.onReady(function() {
      Prime.Document.query('.alert').each(function(e) {
        var dismissButton = e.queryFirst('a.dismiss-button');
        if (dismissButton !== null) {
          new Prime.Widgets.Dismissable(e, dismissButton).initialize();
        }
      });
      Prime.Document.query('[data-tooltip]').each(function(e) {
        new Prime.Widgets.Tooltip(e).withClassName('tooltip').initialize();
      });
    });
  </script>
  [#nested/]
</head>
[/#macro]

[#macro body]
<body class="app-sidebar-closed">
  [#-- Main body that includes the fixed header and the footer --]
  <main>
    [#-- Fixed app header --]
    <header class="app-header">
      <div class="right-menu">
        <nav>
          <ul>
            <li class="help"><a target="_blank" href="https://fusionauth.io/docs"><i class="fa fa-question-circle-o"></i> [@message.print key="help"/]</a></li>
          </ul>
        </nav>
      </div>
    </header>

    [#nested/]
  </main>
</body>
[/#macro]

[#macro main columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
<main class="page-body container">
  [@message.printErrorAlerts columnClass/]
  [@message.printInfoAlerts columnClass/]
  [#nested/]
</main>
[/#macro]

[#macro pageMessage messageKey="information"]
  [@main]
    [#if messageKey!="empty"]
      [@panel.full titleKey=messageKey/]
    [/#if]
  [/@main]
[/#macro]

