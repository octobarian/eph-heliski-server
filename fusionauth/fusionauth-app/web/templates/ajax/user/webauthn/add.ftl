[#ftl/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]

[@dialog.form action="${request.contextPath}/ajax/user/webauthn/add" id="webauthn-register-form" formClass="full"]
  <div class="row">
    <div class="col-xs">
      <p class="mt-0 mb-4">
        <em>[@message.print key="{description}add-webauthn"/]</em>
      </p>
      [@control.hidden name="userId"/]
      [@control.hidden name="webAuthnRegisterRequest"/]
      <fieldset>
        [#assign defaultDisplayName = message.inline("unnamed")/]
        [@control.text name="displayName" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true defaultValue="${defaultDisplayName?markup_string}"/]
      </fieldset>
    </div>
  </div>
[/@dialog.form]