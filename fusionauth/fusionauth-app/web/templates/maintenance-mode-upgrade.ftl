[#ftl/]
[#-- @ftlvariable name="maintenanceModeFuture" type="java.util.concurrent.Future" --]
[#-- @ftlvariable name="failure" type="boolean" --]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
    [#if maintenanceModeFuture?? && !failure]
      <meta http-equiv="refresh" content="10">
    [/#if]
  [/@layout.head]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-8"]
      [#assign title=""/]
      [#if maintenanceModeFuture??]
        [#assign title="upgrading"/]
      [#else]
        [#assign title="upgrade"/]
      [/#if]

      [@panel.full titleKey=title rowClass="row center-xs" columnClass="col-xs col-lg-8"]
        [#if maintenanceModeFuture?? && !failure]
          [@message.print key="upgrading-info"/]
          <div class="progress-bar">
            <div>
              &nbsp;
            </div>
          </div>
        [#elseif !failure]
          <p>
            [@message.print key="intro"/]
          </p>
          [@control.form action="${request.contextPath}/maintenance-mode-upgrade" method="POST"]
            [@button.formIcon autofocus=true/]
          [/@control.form]
        [/#if]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
