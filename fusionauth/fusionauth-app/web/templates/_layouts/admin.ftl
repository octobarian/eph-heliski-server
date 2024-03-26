[#ftl/]
[#-- @ftlvariable name="instance" type="io.fusionauth.api.domain.Instance" --]
[#-- @ftlvariable name="locale" type="java.util.Locale" --]
[#-- @ftlvariable name="runtimeMode" type="io.fusionauth.api.domain.RuntimeMode" --]

[#import "../_utils/button.ftl" as button/]
[#import "../_utils/helpers.ftl" as helpers/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[#macro html]
<!--suppress HtmlUnknownTarget -->
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

  [#-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy --]
  <meta name="referrer" content="strict-origin">

  [#--  Browser Address bar color --]
  <meta name="theme-color" content="#ffffff">

  [#-- Begin Favicon Madness
       You can check if this is working using this site https://realfavicongenerator.net/
       Questions about icon names and sizes? https://realfavicongenerator.net/faq#.XrBnPJNKg3g --]

  [#-- Apple & iOS --]
  <link rel="apple-touch-icon" sizes="57x57" href="${request.contextPath}images/apple-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="60x60" href="${request.contextPath}images/apple-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="72x72" href="${request.contextPath}images/apple-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="76x76" href="${request.contextPath}images/apple-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="114x114" href="${request.contextPath}/images/apple-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="120x120" href="${request.contextPath}/images/apple-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="144x144" href="${request.contextPath}/images/apple-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="152x152" href="${request.contextPath}/images/apple-icon-152x152.png">
  <link rel="apple-touch-icon" sizes="180x180" href="${request.contextPath}/images/apple-icon-180x180.png">

  [#--  Android Icons --]
  <link rel="manifest" href="${request.contextPath}/images/manifest.json">

  [#-- IE 11+ configuration --]
  <meta name="msapplication-config" content="${request.contextPath}/images/browserconfig.xml" />

  [#-- Windows 8 Compatible --]
  <meta name="msapplication-TileColor" content="#ffffff">
  <meta name="msapplication-TileImage" content="${request.contextPath}/images/ms-icon-144x144.png">

  [#--  Standard Favicon Fare --]
  <link rel="icon" type="image/png" sizes="16x16" href="${request.contextPath}/images/favicon-16x16.png">
  <link rel="icon" type="image/png" sizes="32x32" href="${request.contextPath}/images/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="96x96" href="${request.contextPath}/images/favicon-96x96.png">
  <link rel="icon" type="image/png" sizes="128" href="${request.contextPath}/images/favicon-128.png">

  [#-- End Favicon Madness --]

  <link rel="stylesheet" href="${request.contextPath}/css/codemirror-5.17.0.css">
  <link rel="stylesheet" href="${request.contextPath}/css/codemirror-lint-5.17.0.css">
  <link rel="stylesheet" href="${request.contextPath}/css/font-awesome-4.7.0.min.css">
  [#--  Load this before fusionauth-style so we can override w/out !important --]
  [#if reactorStatus.threatDetection == "ACTIVE"]
  <link href="${request.contextPath}/css/openlayers-6.6.0.css" rel="stylesheet"/>
  [/#if]
  <link rel="stylesheet" href="${request.contextPath}/css/fusionauth-style.css?version=${version}"/>

  [#-- Code Mirror --]
  <script src="${request.contextPath}/js/jscolor-min-2.0.4.js"></script>
  <script src="${request.contextPath}/js/jshint-0.7.0.js"></script>
  <script src="${request.contextPath}/js/jsonlint-0.1.0.js"></script>
  <script src="${request.contextPath}/js/htmlhint-0.9.13.js"></script>
  <script src="${request.contextPath}/js/codemirror-min-5.17.0.js"></script>
  <script src="${request.contextPath}/js/codemirror-freemarker-5.17.0.js"></script>
  <script src="${request.contextPath}/js/codemirror-placeholder-5.65.2.js"></script>
  <script src="${request.contextPath}/js/codemirror-properties-5.17.0.js"></script>

  [#-- JS Chart --]
  <script src="${request.contextPath}/js/Chart-2.7.1-min.js"></script>

  [#-- Handlebars --]
  <script src="${request.contextPath}/js/handlebars.runtime.min-v4.7.6.js"></script>

  [#--  OpenLayers for IP Geo Mapping --]
  [#if reactorStatus.threatDetection == "ACTIVE"]
  <script src="${request.contextPath}/js/openlayers-6.6.0.js"></script>
  [/#if]

  [#-- Timezone --]
  <script src="${request.contextPath}/js/jstz-min-1.0.6.js"></script>

  [#--  Prime --]
  <script src="${request.contextPath}/js/prime-min-1.7.0.js?version=${version}"></script>

  <script src="${request.contextPath}/js/Util.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ACLForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/AddUserConsentForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/AJAXSearchForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/AJAXSearchWidget.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ApplicationForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/APIKeys.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/AuditLogSearch.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ClientSecret.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ConnectorForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ConsentForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/Dashboard.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/EmailTemplateForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/EmailTemplateListing.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/EmailTemplateTestDialog.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/EndpointTable.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/EntityTypeForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/FieldForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/FormForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/GroupForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/IdentityProviderForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/Keys.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/LambdaForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/LastLogins.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/LocalizationTable.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/LoginRecordSearch.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ManageEntity.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ManageRolesForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ManageUser.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/message/MessageTemplateForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/message/MessageTemplateListing.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/MessengerForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/OAuthConfiguration.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/PermissionsForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/Report.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/SearchForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/SMTPTestDialog.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/SystemConfigurationForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/SystemLogs.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/TenantForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/TenantPolicyManager.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/ThemeForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/TwoFactor.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/UserActionForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/UserActioningForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/UserActionReasonForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/UserRegistrationForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/UserSearchBar.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/WebhookForm.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/WebhookTest.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/AdvancedControls.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/AutoComplete.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/Chart.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/Colors.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/Errors.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/ExpandableTable.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/Listing.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/Main.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/Spoiler.js?version=${version}"></script>
  <script src="${request.contextPath}/js/ui/TextEditor.js?version=${version}"></script>

  <script>
    var FusionAuth = FusionAuth || {};
    FusionAuth.requestContextPath = '${request.contextPath}';
    FusionAuth.loginURI = FusionAuth.requestContextPath + '/login';
    FusionAuth.Version = "${version}";
    <!-- IETF BCP 47 Language Tag -->
    FusionAuth.LanguageTag = "${locale.toLanguageTag()}";
  </script>

  [#nested/]

  <style>
      [#if (systemConfiguration.uiConfiguration.headerColor)??]
      body .app-sidebar {
        background: #${systemConfiguration.uiConfiguration.headerColor};
      }
      body .app-sidebar nav ul li a:hover, .app-sidebar nav ul li a.active {
        background-color: #${systemConfiguration.uiConfiguration.headerColor};
        filter: brightness(60%);
      }
      body .app-sidebar nav ul li.folder.open a:not(.active) {
        background-color: #${systemConfiguration.uiConfiguration.headerColor};
        filter: brightness(80%);
      }
      [/#if]
      [#if (systemConfiguration.uiConfiguration.menuFontColor)??]
      body .app-sidebar header p, .app-sidebar header p a, .app-sidebar nav ul li a, .app-sidebar nav ul li a:hover, .app-sidebar nav ul li a.active, .app-sidebar nav ul li a i, .app-sidebar .footer-container footer {
        color: #${systemConfiguration.uiConfiguration.menuFontColor};
      }
      [/#if]
  </style>
</head>
[/#macro]

[#macro body bodyClass="" outputAlerts=true]
<body class="${bodyClass}">
  [#if ftlCurrentUser?? && zoneId??]
    <div class="app-sidebar">
      <header style="position: relative;">
        <a href="${request.contextPath}/" class="logo">
          <img src="${(systemConfiguration.uiConfiguration.logoURL)?has_content?then(systemConfiguration.uiConfiguration.logoURL, request.contextPath + '/images/logo-white-orange.svg')}" alt="FusionAuth logo"/>
        </a>
        [@helpers.avatar ftlCurrentUser/]
        [#local loginName = ftlCurrentUser.name!ftlCurrentUser.login /]
        <p style="display: flex; justify-content: center;">
          <span style="max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" [#if loginName.length() > 15]title="${loginName}"[/#if]> ${loginName} </span>
          <a href="${request.contextPath}/admin/user/manage/${ftlCurrentUser.id}?tenantId=${ftlCurrentUser.tenantId}" title="${function.message('manage-profile')}" data-tooltip="${function.message('manage-profile')}"><i class="fa fa-address-card"></i></a>
          [#assign currentLocation = "${((fusionAuth.currentLocation()!{}).displayString)!''} ${(currentIPAddress)!''}"/]
          <a title="${currentLocation}" data-tooltip="${currentLocation}"><i class="fa fa-location-arrow"></i></a>
        </p>
      </header>

      <nav>
        <ul class="treeview">

          <li class="show-on-mobile">
            <a href="${request.contextPath}/admin/logout"><i class="fa fa-sign-out fa-fw"></i>[@message.print key="logout"/]</a>
          </li>

          [#-- Dashboard --]
          [@navigationButton icon="columns" nameKey="dashboard" path="/admin/"/]

          [#-- Users --]
          [@navigationButton icon="users" nameKey="users" path="/admin/user/" children=["/admin/user/"] roles=["admin", "user_manager", "user_support_manager", "user_support_viewer"]/]

          [#-- Applications --]
          [@navigationButton icon="cube" nameKey="applications" path="/admin/application/" children=["/admin/application/"] roles=["admin", "application_manager"]/]

          [#-- Groups --]
          [@navigationButton path="/admin/group/" icon="object-group" nameKey="groups" children=["/admin/group/"] roles=["admin", "group_manager"]/]

          [#-- Tenants --]
          [@navigationButton path="/admin/tenant/" icon="building" nameKey="tenants" children=["/admin/tenant/"] roles=["admin", "tenant_manager"]/]

          [#-- Reactor --]
          [@navigationButtonCustomIcon path="/admin/reactor/"nameKey="reactor" children=["/admin/reactor/"] roles=["admin", "reactor_manager"]]
            <span style="margin-right: 11px; padding-left: 1px; vertical-align: middle;">
              <img class="reactor-nav-logo" src="/images/icon-reactor-white-orange.svg" alt="FusionAuth Reactor Logo" width="16">
            </span>
          [/@navigationButtonCustomIcon]

          [#-- Nav Break --]
          <li class="nav-break"></li>

          [#-- Customizations --]
          [@navigationNode icon="code" nameKey="customizations"
                           roles=["admin", "email_template_manager", "form_manager", "lambda_manager", "message_template_manager", "theme_manager"]
                           children=["/admin/email", "/admin/form/", "/admin/field", "/admin/lambda", "/admin/message", "/admin/theme/"]]
            [@navigationLeafNode path="/admin/email/template/" icon="envelope" nameKey="email-templates" roles=["admin", "email_template_manager"] children=["/admin/email/template/"]/]
            [@navigationLeafNode path="/admin/form/" icon="check-square-o" nameKey="forms" roles=["admin", "form_manager"] children=["/admin/form/"]/]
            [@navigationLeafNode path="/admin/field/" icon="i-cursor" nameKey="form-fields" roles=["admin", "form_manager"] children=["/admin/field/"]/]
            [@navigationLeafNode path="/admin/lambda/" icon="terminal" nameKey="lambdas" roles=["admin", "lambda_manager"] children=["/admin/lambda/"]/]
            [@navigationLeafNode path="/admin/message/template/" icon="comment" nameKey="message-templates" roles=["admin", "message_template_manager"] children=["/admin/message/template"]/]
            [@navigationLeafNode path="/admin/theme/" icon="paint-brush" nameKey="themes" roles=["admin", "theme_manager"] children=["/admin/theme/"]/]
          [/@navigationNode]

          [#-- Entity Management --]
          [@navigationNode icon="server" nameKey="entity-management"
                           roles=["admin", "entity_manager"]
                           children=["/admin/entity/"]]
            [@navigationLeafNode path="/admin/entity/" icon="clone" nameKey="entities" roles=["admin", "entity_manager"] children=["/admin/entity/"] excludes=["/admin/entity/type/", "/admin/entity/type/add", "/admin/entity/type/edit", "/admin/entity/type/delete"]/]
            [@navigationLeafNode path="/admin/entity/type/" icon="square-o" nameKey="entity-types" roles=["admin", "entity_manager"] children=["/admin/entity/type/"]/]
          [/@navigationNode]

          [#-- Settings --]
          [@navigationNode icon="sliders" nameKey="settings"
                           roles=["acl_manager", "admin", "api_key_manager", "connector_manager", "consent_manager", "key_manager", "messenger_manager", "system_manager", "user_action_manager", "webhook_manager" ]
                           children=["/admin/ip-acl/", "/admin/api", "/admin/connector/", "/admin/consent/", "/admin/identity-provider", "/admin/integration", "/admin/key/", "/admin/messenger", "/admin/system-configuration", "/admin/user-action", "/admin/webhook"]]
            [@navigationLeafNode path="/admin/api-key/" icon="key" nameKey="api-authentication-keys" roles=["admin", "api_key_manager"] children=["/admin/api-key/"]/]
            [@navigationLeafNode path="/admin/connector/" icon="chevron-right" nameKey="connectors" roles=["admin", "connector_manager"] children=["/admin/connector/"]/]
            [@navigationLeafNode path="/admin/consent/" icon="check" nameKey="consents" roles=["admin", "consent_manager"] children=["/admin/consent/"]/]
            [@navigationLeafNode path="/admin/identity-provider/" icon="id-badge" nameKey="identity-providers" roles=["admin", "system_manager"] children=["/admin/identity-provider/"]/]
            [@navigationLeafNode path="/admin/integration/" icon="exchange" nameKey="integrations" roles=["admin", "system_manager"] children=["/admin/integration/"]/]
            [@navigationLeafNode path="/admin/ip-acl/" icon="shield" nameKey="ip-acl" roles=["admin", "acl_manager"] children=["/admin/ip-acl/"]/]
            [@navigationLeafNode path="/admin/key/" icon="lock" nameKey="key-master" roles=["admin", "key_manager"] children=["/admin/key/"]/]
            [@navigationLeafNode path="/admin/messenger/" icon="comments" nameKey="messengers" roles=["admin", "messenger_manager"] children=["/admin/messenger/"]/]
            [@navigationLeafNode path="/admin/system-configuration/edit" icon="gear" nameKey="system" roles=["admin", "system_manager"]/]
            [@navigationLeafNode path="/admin/user-action/" icon="trophy" nameKey="user-actions" roles=["admin", "user_action_manager"] children=["/admin/user-action/"]/]
            [@navigationLeafNode path="/admin/webhook/" icon="feed" nameKey="webhooks" roles=["admin", "webhook_manager"] children=["/admin/webhook/"]/]
          [/@navigationNode]

          [#-- Reports --]
          [@navigationNode icon="pie-chart" nameKey="reports"
                           roles=["admin", "report_viewer"]
                           children=["/admin/report/"]]
            [@navigationLeafNode path="/admin/report/login" icon="sign-in" nameKey="login"/]
            [@navigationLeafNode path="/admin/report/registration" icon="area-chart" nameKey="registration"/]
            [@navigationLeafNode path="/admin/report/daily-active-user" icon="bar-chart" nameKey="daily-active-user"/]
            [@navigationLeafNode path="/admin/report/monthly-active-user" icon="line-chart" nameKey="monthly-active-user"/]
            [@navigationLeafNode path="/admin/report/totals" icon="tasks" nameKey="totals"/]
          [/@navigationNode]

          [#-- System --]
          [@navigationNode icon="desktop" nameKey="system"
                           [#-- About panel does not require any particular role, so always show the System menu --]
                           roles=[]
                           children=["/admin/system/"]]
            [@navigationLeafNode path="/admin/system/audit-log/" icon="eye" nameKey="audit-log" roles=["admin", "audit_log_viewer"]/]
            [@navigationLeafNode path="/admin/system/event-log/" icon="exclamation-triangle" nameKey="event-log" roles=["admin", "event_log_viewer"]/]
            [@navigationLeafNode path="/admin/system/login-record/" icon="sign-in" nameKey="login-records" roles=["admin", "system_manager"]/]
            [@navigationLeafNode path="/admin/system/log/" icon="file-o" nameKey="system-logs" roles=["admin", "system_manager"]/]
            [#if searchEngineType == "elasticsearch"]
              [@navigationLeafNode path="/admin/system/reindex" icon="wrench" nameKey="reindex" roles=["admin", "system_manager"]/]
            [/#if]
            [#if runtimeMode != "Production"]
              [@navigationLeafNode path="/admin/system/reset" icon="exclamation" nameKey="reset" roles=["admin"] additionalIconClass="orange-text"/]
            [/#if]
            [@navigationLeafNode path="/admin/system/about" icon="question-circle" nameKey="about" /]
          [/@navigationNode]

        </ul>
      </nav>

      <div class="footer-container">
        <footer>
          &copy; FusionAuth ${.now?string["yyyy"]} <br/>
          FusionAuth&trade; version [#if version.isPreRelease()]${version.toString()?substring(0, version.toString()?index_of("-"))}[#else]${version}[/#if]
        </footer>
      </div>
    </div>
  [/#if]

  [#-- Main body that includes the fixed header and the footer --]
  <main>

    [#-- Fixed app header --]
    <header class="app-header">
      [#if ftlCurrentUser?? && zoneId??]
        <a href="#" class="app-sidebar-toggle"><i class="fa fa-dedent"></i></a>
      [/#if]
      <div class="search">
        [#if ftlCurrentUser?? && zoneId??]
          <form action="${request.contextPath}/admin/user/" id="user-search-bar" method="GET">
            <main class="input-addon-group flat">
              <span class="icon"><i class="fa fa-search"></i></span>
              <input type="search" name="queryString" placeholder="${function.message('{placeholder}queryString')}" class="flat"/>
            </main>
          </form>
        [/#if]
      </div>
      <div class="right-menu">
        <nav>
          <ul>
           [#if version.isPreRelease()]
            <li style="background-color: #f58320;">
             <a style="color: #fff;" href="/admin/system/about">&nbsp;&nbsp Early Access ${version} </a>
            </li>
           [/#if]
           [#if runtimeMode != "Production"]
            <li class="runtime-mode-notice" style="background-color: #ec3636; display: none;">
             <a style="color: #fff;" href="/admin/system/about">&nbsp;&nbsp [@message.print key="RuntimeMode.${runtimeMode.name()}" /] Mode </a>
            </li>
            <li class="runtime-mode-notice" style="background-color: #ec3636; display: none;">
              <a id="pause-runtime-notice" style="color: #fff;" href="#" data-tooltip="Temporarily hide the runtime mode so you can take screenshots or something else pretty cool"><i class="fa fa-pause"></i></a>
            </li>
           [/#if]
            <li class="help"><a target="_blank" href="https://fusionauth.io/docs"><i class="fa fa-question-circle-o"></i> [@message.print key="help"/]</a></li>
            [#if ftlCurrentUser??]
            <li><a href="${request.contextPath}/admin/logout"><i class="fa fa-sign-out"></i> [@message.print key="logout"/]</a></li>
            [/#if]
          </ul>
        </nav>
      </div>
    </header>

    [#if outputAlerts]
      <header class="page-alerts container-fluid">
        [@message.printErrorAlerts/]
        [@message.printInfoAlerts/]
        [@message.printWarningAlerts/]
      </header>
    [/#if]

    [#nested/]
  </main>

[#-- Error Alert Template --]
<script id="error-alert-template" type="text/x-handlebars-template">
  <div class="row" id="{{id}}">
    <div class="col-xs">
      <div class="alert error">
        <i class="fa fa-exclamation-circle"></i>
        <p>{{message}}</p>
        <a href="#" class="dismiss-button"><i class="fa fa-times-circle"></i></a>
      </div>
      </div>
    </div>
</script>
</body>
[/#macro]

[#macro main containerType="container-fluid"]
  <main class="page-body ${containerType}">
    [#nested/]
  </main>
[/#macro]

[#macro pageForm action method enctype="" id="" class="labels-left full" pageTitleKey="page-title" panelTitleKey="" panelClass="panel" includeSave=true includeCancel=true includeDelete=false cancelURI="" deleteURI="delete" saveColor="blue" saveKey="save" saveIcon="save" breadcrumbs={}]
  [@control.form action=action method=method enctype=enctype class=class id=id]
    [@pageHeader titleKey=pageTitleKey includeSave=includeSave includeCancel=includeCancel includeDelete=includeDelete cancelURI=cancelURI deleteURI=deleteURI saveColor=saveColor saveKey=saveKey saveIcon=saveIcon breadcrumbs=breadcrumbs/]
    [@main]
      [@panel.full titleKey=panelTitleKey panelClass=panelClass]
        [#nested/]
      [/@panel.full]
    [/@main]
  [/@control.form]
[/#macro]

[#macro pageHeader titleKey="page-title" includeAdd=false includeBack=false includeCancel=false includeSave=false includeDelete=false addURI="add" backURI="" cancelURI="" deleteURI="" saveColor="blue" saveKey="save" saveIcon="save" breadcrumbs={}]
<header class="page-header container-fluid">
  <div class="row">
    <div class="col-xs-12 col-md-8">
      <h1>[@message.print key=titleKey/]</h1>
      <ul class="breadcrumbs">
        <li><a href="${request.contextPath}/admin/">[@message.print key="home"/]</a></li>
        [#list breadcrumbs?keys as uri]
          <li>[#if uri != ""]<a href="${request.contextPath}${uri}">[/#if][@message.print key=breadcrumbs[uri]/][#if uri != ""]</a>[/#if]</li>
        [/#list]
      </ul>
    </div>
    <div class="col-xs-12 col-md-4">
      <div class="buttons">
        [#if includeSave]
          [@button.iconButton color=saveColor tooltipKey=saveKey icon=saveIcon/]
        [/#if]
        [#if includeAdd]
          [@button.iconLink href=addURI color="green" icon="plus" tooltipKey="add"/]
        [/#if]
        [#nested/]
        [#if includeBack]
          [@button.iconLink href=backURI color="gray" icon="reply" tooltipKey="back"/]
        [/#if]
        [#if includeCancel]
          [@button.iconLink href=cancelURI color="gray" icon="reply" tooltipKey="cancel"/]
        [/#if]
        [#if includeDelete]
          [@button.iconLink href=deleteURI color="red" icon="trash" tooltipKey="delete"/]
        [/#if]
      </div>
    </div>
  </div>
</header>
[/#macro]

[#macro navigationButton icon="question-circle" nameKey="empty" path="/" roles=[] children=[]]
[@navigationButtonCustomIcon nameKey=nameKey path=path roles=roles children=children]
<i class="fa fa-${icon} fa-fw"></i>[#t]
[/@navigationButtonCustomIcon]
[/#macro]

[#macro navigationButtonCustomIcon nameKey="empty" path="/" roles=[] children=[]]
  [#if roles?size == 0 || fusionAuth.has_one_role(roles)]
  <li class="${leafNodeActive(path children)}">
    <a href="${request.contextPath}${path}" class="${leafNodeActive(path children)}" style="height: 48px;">[#rt]
      [#nested/][#t]
      [@message.print key=nameKey/][#t]
    </a>[#lt]
  </li>
  [/#if]
[/#macro]

[#macro navigationNode icon="question-circle" nameKey="empty" children=[] roles=[] excludes=[]]
  [#if roles?size == 0 || fusionAuth.has_one_role(roles)]
  <li class="folder ${parentMenuActive(children, excludes)}">
    <a class="folder-toggle ${parentMenuActive(children, excludes)}">[#rt]
      <i class="fa fa-${icon} fa-fw"></i>[#t]
      [@message.print key=nameKey/][#t]
    </a>[#lt]
    <ul>
      [#nested]
    </ul>
  </li>
  [/#if]
[/#macro]

[#macro navigationLeafNode path="/" icon="question-circle" nameKey="empty" children=[] roles=[] excludes=[] additionalIconClass=""]
  [#if roles?size == 0 || fusionAuth.has_one_role(roles)]
  <li>
    <a href="${request.contextPath}${path}" class="${leafNodeActive(path children excludes)}">
       <i class="fa fa-${icon} fa-fw ${additionalIconClass}"></i>[#t]
      [@message.print key=nameKey/][#t]
    </a>[#lt]
  </li>
  [/#if]
[/#macro]

[#function parentMenuActive prefixes excludes=[]]
  [#list prefixes as prefix]
    [#if request.path?starts_with(prefix) && !excludes?seq_contains(request.path?split('?')[0])]
      [#return 'active open'/]
    [/#if]
  [/#list]
  [#return ''/]
[/#function]

[#function leafNodeActive path uris excludes=[]]
  [#if request.path == path]
    [#return 'active open'/]
  [#else]
    [#list uris as uri]
      [#if request.path?starts_with(uri) && !excludes?seq_contains(request.path?split('?')[0])]
        [#return 'active open'/]
      [/#if]
    [/#list]
    [#return ''/]
  [/#if]
[/#function]