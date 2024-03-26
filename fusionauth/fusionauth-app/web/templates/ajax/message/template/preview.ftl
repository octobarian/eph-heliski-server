[#ftl/]
[#-- @ftlvariable name="renderedMessage" type="io.fusionauth.domain.message.sms.SMSMessage" --]
[#-- @ftlvariable name="messageTemplate" type="io.fusionauth.domain.message.MessageTemplate" --]
[#-- @ftlvariable name="errors" type="com.inversoft.error.Errors" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as props/]

[#macro displayErrors key field]
  [#if errors.fieldErrors[field]??]
    <li><strong>[@message.print key=key/]</strong>
      <ul>
        <li>${errors.fieldErrors[field]}</li>
      </ul>
    </li>
  [/#if]
[/#macro]

[@dialog.view]
  [#if errors.fieldErrors?size > 0]
    <div class="warning alert">
      <i class="fa fa-exclamation-triangle"></i>
      <p>[@message.print key="error-warning"/]</p>
    </div>
    <div class="warning alert">
      <i class="fa fa-exclamation-triangle"></i>
      <ul>
        [@displayErrors key="template" field="messageTemplate.defaultTemplate"/]
      </ul>
    </div>
  [/#if]

  <div class="message-preview">
    <ul class="tabs">
      <li><a href="#localization">[@message.print key="template"/]</a></li>
    </ul>
  <div id="localization" class="mt-2">
    <pre class="preview" style="height:500px;">${((renderedMessage.textMessage)!'')}</pre>
  </div>
[/@dialog.view]
