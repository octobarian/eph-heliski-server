[#ftl/]

[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/button.ftl" as button/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main]
      [@panel.full titleKey="404-title" rowClass="row center-xs" columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
        Let's get you back where you belong before someone misses you, <a href="/admin">back to FusionAuth</a>.
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
