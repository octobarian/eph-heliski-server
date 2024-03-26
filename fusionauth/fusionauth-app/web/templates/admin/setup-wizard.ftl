[#ftl/]

[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
[@layout.head]
  [@layout.head]
  <script src="${request.contextPath}/js/jstz-min-1.0.6.js"></script>
  <script>
    Prime.Document.onReady(function() {
      var timezone = Prime.Document.queryById('timezone');
      var guess = jstz.determine();
      if (Prime.Utils.isDefined(guess.name())) {
        timezone.setValue(guess.name());
      }
    });
  </script>
  [/@layout.head]
[/@layout.head]
[@layout.body]
  [@layout.main columnClass="col-xs col-lg-8"]

    [@panel.full titleKey="page-title" rowClass="row center-xs" columnClass="col-xs col-lg-8"]
      <p class="no-top-margin push-bottom">[@control.message key="intro"/]</p>
      [@control.form action="${request.contextPath}/admin/setup-wizard" method="POST" class="labels-left full"]
        <fieldset>
          <legend>[@message.print key="heading.administrator"/]</legend>
          <p class="no-top-margin">
            <em>[@control.message key="intro.administrator"/]</em>
          </p>
          [@control.text name="user.firstName" autocapitalize="none" autocomplete="on" autocorrect="off" required=true autofocus="autofocus"/]
          [@control.text name="user.lastName" autocapitalize="none" autocomplete="on" autocorrect="off" required=true/]
          [@control.text name="user.email" autocapitalize="none" autocomplete="on" autocorrect="off" required=true/]
          [@control.password name="user.password" required=true/]
          [@control.password name="passwordConfirm" required=true/]
        </fieldset>
        <fieldset>
          <legend>[@message.print key="heading.license"/]</legend>
          <p class="no-top-margin">
            <em>[@control.message key="intro.license"/]</em>
          </p>
          [@control.checkbox name="acceptLicense" required=true uncheckedValue="false" value="true"/]
        </fieldset>
        <fieldset>
          <legend>[@message.print key="heading.updates"/]</legend>
          <p class="no-top-margin">
            <em>[@control.message key="intro.addToNewsletter"/]</em>
          </p>
          [@control.checkbox name="addToNewsletter" uncheckedValue="false" value="true"/]
        </fieldset>
        [@control.hidden name="timezone"/]

        <div class="form-row">
          [@button.formIcon/]
        </div>
      [/@control.form]
    [/@panel.full]
  [/@layout.main]
[/@layout.body]
[/@layout.html]
