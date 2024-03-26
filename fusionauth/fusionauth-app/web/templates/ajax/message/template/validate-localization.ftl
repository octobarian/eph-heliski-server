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
  </fieldset>
  <fieldset>
    <div id="localization-template">
      [@control.textarea name="template" autocapitalize="on" autocomplete="off" autocorrect="on" tooltip=function.message('{tooltip}template')/]
      <div class="text-right">
        [@button.iconLinkWithText href="/ajax/message/template/preview" color="blue" icon="search" textKey="preview" tooltipKey="message-preview"/]
      </div>
    </div>
  </fieldset>
[/@dialog.form]