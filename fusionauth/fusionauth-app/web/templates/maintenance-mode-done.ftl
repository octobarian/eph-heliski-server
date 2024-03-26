[#ftl/]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
    <meta http-equiv="refresh" content="10">
  [/@layout.head]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-8"]
      [@panel.full titleKey="starting" rowClass="row center-xs" columnClass="col-xs col-lg-8"]
        <p>
          [@message.print key="starting-info"/]
        </p>
        <div class="progress-bar">
          <div>
            &nbsp;
          </div>
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
