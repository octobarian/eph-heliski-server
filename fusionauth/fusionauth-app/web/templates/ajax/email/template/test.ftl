[#ftl/]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.form action="test" formClass="full" submitIcon="send-o" includeFooter=false]
  <p class="mb-3">
    <em>[@message.print key="{description}send" /]</em>
  </p>
  <fieldset>
    [@control.hidden name="emailTemplateId" /]
      [#--  Default to the current user's email address  --]
      [#if fieldMessages['q']?has_content]
        [@control.text name="q" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true placeholder=message.inline("{placeholder}q")/]
      [#else]
        [@control.text name="q" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true value="${ftlCurrentUser.email!''}" placeholder=message.inline("{placeholder}q")/]
      [/#if]
      [@control.hidden name="userId" value="${ftlCurrentUser.id}"/]
      <div id="email-error-response" class="hidden">
        <label for="email-error-textarea" class="red-text">[@message.print key="error"/]</label>
        <textarea id="email-error-textarea" disabled></textarea>
      </div>
  </fieldset>
  <footer>
    [@button.formIcon icon=submitIcon color=submitColor textKey=submitTextKey disabled=disableSubmit/]
    [@button.iconLinkWithText href="#" icon="reply" color="gray" textKey="cancel" data_dialog_role="close-button"/]
    <span id="sent-ok" class="green-text ml-1 hidden">
      <i class="fa fa-check"></i> [@message.print key="email-sent" /]
    </span>
  </footer>
[/@dialog.form]