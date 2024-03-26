[#ftl/]
[#-- @ftlvariable name="search" type="com.inversoft.maintenance.action.MaintenanceModeSearchConfigurationAction.SearchConfiguration" --]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-8"]
      [@panel.full titleKey="page-title" rowClass="row center-xs" columnClass="col-xs col-lg-8"]
        [@control.form action="maintenance-mode-search-configuration" method="POST" class="labels-left full"]
          <fieldset>
            <p>[@message.print key="intro"/]</p>
            <legend>[@message.print key="elasticsearch"/]</legend>
            [@control.text name="search.servers" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" required=true tooltip=function.message("{tooltip}search.servers")/]
          </fieldset>
          [@button.formIcon/]
        [/@control.form]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
