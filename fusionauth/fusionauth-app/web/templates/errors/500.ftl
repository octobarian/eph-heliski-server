[#ftl/]

[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/button.ftl" as button/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main]
      [@panel.full titleKey="500-title" rowClass="row center-xs" columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
        An internal error occurred. FusionAuth should have captured a stack trace in the log.
        Please review the troubleshooting guide found in the documentation for assistance and the available support channels.
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
