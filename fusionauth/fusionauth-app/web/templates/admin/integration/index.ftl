[#ftl/]
[#-- @ftlvariable name="anyAvailable" type="boolean" --]
[#-- @ftlvariable name="anyConfigured" type="boolean" --]
[#-- @ftlvariable name="integrations" type="java.util.Map<java.lang.String, io.fusionauth.domain.Enableable>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[#macro cards integrations]
  <div class="row">
  [#list integrations?keys as integration]
      [#local enabled = integrations[integration].enabled/]
      <a class="grid-trading-card col-xs-6 col-sm-4 col-md-4 col-lg-3 col-xl-2 ${enabled?then('', 'disabled')}" href="/admin/integration/${integration?lower_case}">
        <header>${integration}</header>
        <div class="main">
          <img style="width: 100%; height: 100%;" src="/images/integration/${integration?lower_case}.png">
        </div>
        <footer>
          [#if enabled]
            <span>[@message.print key="configure"/]&nbsp;<i class="fa fa-gear"></i></span>
          [#else]
            <span class="green-text">[@message.print key="enable"/]</span>
          [/#if]
        </footer>
      </a>
  [/#list]
  </div>
[/#macro]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=false breadcrumbs={"": "settings", "/admin/integration/": "integrations"}/]
    [@layout.main]
      [@panel.full]
        [@cards integrations/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]