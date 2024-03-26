[#ftl/]
[#-- @ftlvariable name="email" type="io.fusionauth.domain.email.Email" --]
[#-- @ftlvariable name="emailTemplate" type="io.fusionauth.domain.email.EmailTemplate" --]
[#-- @ftlvariable name="errors" type="com.inversoft.error.Errors" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]

[#macro displayErrors key field]
  [#if errors.fieldErrors[field]??]
    <li><strong>[@message.print key=key/]</strong>
      <ul>
        <li>${errors.fieldErrors[field][0].message}</li>
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
        [@displayErrors key="subject" field="emailTemplate.defaultSubject"/]
        [@displayErrors key="fromName" field="emailTemplate.defaultFromName"/]
        [@displayErrors key="htmlTemplate" field="emailTemplate.defaultHtmlTemplate"/]
        [@displayErrors key="textTemplate" field="emailTemplate.defaultTextTemplate"/]
      </ul>
    </div>
  [/#if]

  <div>
    <dl>
      <dt>
        [@message.print key="subject"/]
      </dt>
      <dd>
      ${(email.subject)!''}
      </dd>
      <dt>
        [@message.print key="fromName"/]
      </dt>
      <dd>
      ${(email.from.display)!''} &lt;${(email.from.address)!''}&gt;
      </dd>
    </dl>
  </div>
  <div class="email-preview">
    <ul class="tabs">
      <li><a href="#html-localization">[@message.print key="htmlTemplate"/]</a></li>
      <li><a href="#text-localization">[@message.print key="textTemplate"/]</a></li>
    </ul>
    [#-- Normally these are 300px, on this page since it is a dialog and in tabs increase the height a bit --]
    <div id="text-localization" class="mt-2">
      <pre class="preview" style="height:500px;">${((email.text)!'')}</pre>
    </div>
    <div id="html-localization" class="mt-2">
      <iframe class="preview" style="height:500px;">
      </iframe>
      <div id="html-source" class="hidden">
        ${((email.html)!'')}
      </div>
    </div>
  </div>
[/@dialog.view]
