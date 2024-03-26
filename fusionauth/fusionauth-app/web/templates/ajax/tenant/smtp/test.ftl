[#ftl/]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.form action="test" formClass="labels-left full" submitIcon="send-o" includeFooter=false]
  <p class="mb-3">
    <em>[@message.print key="{description}test" /]</em>
  </p>
  <fieldset>
    [@control.hidden name="tenantId" /]
    [#--  Default to the current user's email address  --]
    [@control.text name="email" autofocus="autofocus" required=true value="${ftlCurrentUser.email!''}" /]
    <div id="smtp-error-response" class="hidden">
      <label for="smtp-error-textarea" class="red-text">[@message.print key="error"/]</label>
      <textarea id="smtp-error-textarea"></textarea>
    </div>
  </fieldset>

  <footer>
    [@button.formIcon icon=submitIcon color=submitColor textKey=submitTextKey disabled=disableSubmit/]
    [@button.iconLinkWithText href="#" icon="reply" color="gray" textKey="close" data_dialog_role="close-button"/]
    <span id="smtp-sent-ok" class="green-text ml-1 hidden">
      <i class="fa fa-check"></i> [@message.print key="email-sent" /]
    </span>
  </footer>

[/@dialog.form]