[#ftl/]
[#-- @ftlvariable name="result" type="com.inversoft.maintenance.search.MaintenanceModeSearchService.SearchStatusResult" --]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
      [@layout.main columnClass="col-xs col-lg-8"]
        [#assign title=(result?? && result.status == "MISSING_INDEX")?then("new", "upgrade")/]
        [@panel.full titleKey=title rowClass="row center-xs" columnClass="col-xs col-lg-8"]
          <p>
            [#if result?? && result.status  == "MISSING_INDEX"]
              [@message.print key="intro-new"/]
            [#else]
              [@message.print key="intro-upgrade"/]
            [/#if]
          </p>
          [@control.form action="${request.contextPath}/maintenance-mode-search-upgrade" method="POST"]
            [@button.formIcon autofocus=true/]
          [/@control.form]
        [/@panel.full]
      [/@layout.main]
  [/@layout.body]
[/@layout.html]