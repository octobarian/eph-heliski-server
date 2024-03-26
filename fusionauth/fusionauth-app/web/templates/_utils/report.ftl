[#ftl/]

[#import "message.ftl" as message/]

[#macro date_control]
<label>[@message.print key="range"/]</label>
<div class="report-controls">
  <a href="#"><i class="fa fa-angle-left"></i></a>
  <span>Date</span>
  <a href="#"><i class="fa fa-angle-right"></i></a>
</div>
[/#macro]

[#macro chart name]
<main id="${name}-report">
  <div class="push-bottom">
    [@control.form action="${request.contextPath}/ajax/report/${name}" class="row full"]
      <div class="col-xs-12 col-md-4">
        [@control.select items=applications name="applicationId" textExpr="name" valueExpr="id" headerL10n="all-applications" headerValue=""/]
      </div>

      <div class="col-xs-12 col-md-4">
        [@control.select items=intervals name="interval"/]
      </div>

      <div class="col-xs-12 col-md-4">
        [@typeToggle/]
        <div class="form-row">
          [@date_control/]
        </div>
      </div>

      [#if name == "login"]
        <div class="col-xs-12 col-md-8">
          [@control.text name="q" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" placeholder=message.inline("{placeholder}q")/]
          [@control.hidden name="userId"/]
        </div>
      [/#if]

    [/@control.form]
  </div>
  <canvas></canvas>
</main>
[/#macro]

[#macro typeToggle]
<label class="chart-toggle">
  <a data-chart="line" data-tooltip="${function.message("line-chart")}" href="#"><i class="fa fa-line-chart"></i></a>[#t/]
  <a data-chart="bar" data-tooltip="${function.message("bar-chart")}" href="#"><i class="fa fa-bar-chart"></i></a>[#t/]
</label>
[/#macro]