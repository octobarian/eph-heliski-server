[#ftl/]
[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
[@layout.head/]
[@layout.body]
  [@layout.main]
    [@panel.full titleKey="unauthorized" rowClass="row center-xs" columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
      <p> [@message.print key="unauthorized-notice"/] </p>
      <a href="${request.contextPath}/admin">
        <i class="fa fa-arrow-left"></i> &nbsp; [@message.print key="unauthorized-back-to-admin"/]
      </a>
    [/@panel.full]
  [/@layout.main]
[/@layout.body]
[/@layout.html]
