[#ftl/]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]

[@dialog.form action="validate-localization" formClass="labels-left full"]
  <fieldset>
    <div class="form-row">
      <label>[@message.print key="locale"/] <i class="fa fa-info-circle" data-tooltip="${function.message('{tooltip}locale')}"></i></label>
      [@locale.select ""/]
    </div>
    [@control.text name="subject" autocapitalize="on" autocomplete="off" autocorrect="on" autofocus="autofocus" tooltip=function.message('{tooltip}subject')/]
    [@control.text name="fromName" autocapitalize="on" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}fromName')/]
  </fieldset>
  <fieldset>
    <ul class="tabs">
      <li><a href="#localization-html-template"[#if fieldMessages['htmlTemplate']??] class="error"[/#if]>[@message.print key="html-template"/]</a></li>
      <li><a href="#localization-text-template"[#if fieldMessages['textTemplate']??] class="error"[/#if]>[@message.print key="text-template"/]</a></li>
    </ul>
    <div id="localization-html-template">
      [@control.textarea name="htmlTemplate" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=function.message('{tooltip}htmlTemplate')/]
      <div class="text-right">
        [@button.iconLinkWithText href="/ajax/email/template/preview" color="blue" icon="search" textKey="preview" tooltipKey="email-preview"/]
      </div>
    </div>
    <div id="localization-text-template">
      [@control.textarea name="textTemplate" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=function.message('{tooltip}textTemplate')/]
      <div class="text-right">
        [@button.iconLinkWithText href="/ajax/email/template/preview" color="blue" icon="search" textKey="preview" tooltipKey="email-preview"/]
      </div>
    </div>
  </fieldset>
[/@dialog.form]