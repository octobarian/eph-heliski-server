[#ftl/]

[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-6"]
      [@panel.full titleKey="page-title" rowClass="row center-xs" columnClass="col-xs col-lg-6"]
        [@control.form action="${request.contextPath}/support/login" method="POST" class="labels-above full"]
        <fieldset>
          [@control.password name="one" autocapitalize="none" autocomplete="off" autocorrect="off" required=true  labelKey="empty" leftAddon="exclamation" autofocus="autofocus"/]
          [@control.password name="two" autocapitalize="none" autocomplete="off" autocorrect="off" required=true labelKey="empty" leftAddon="exclamation"/]
          [@control.password name="three" autocapitalize="none" autocomplete="off" autocorrect="off" required=true labelKey="empty" leftAddon="exclamation"/]
        </fieldset>
        <div class="form-row">
          [@button.formIcon icon="key"/]
        </div>
        [/@control.form]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
