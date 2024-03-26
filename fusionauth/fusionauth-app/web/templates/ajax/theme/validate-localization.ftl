[#ftl/]
[#-- @ftlvariable name="isDefault" type="boolean" --]
[#-- @ftlvariable name="missingValues" type="java.util.Map<java.lang.String, java.lang.String>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/locale.ftl" as locale/]
[#import "../../_utils/message.ftl" as message/]

[@dialog.form action="validate-localization" formClass="labels-left full"]
  <fieldset>
    [#if !isDefault]
      <div class="form-row">
        <label>[@message.print key="locale"/] <i class="fa fa-info-circle" data-tooltip="${function.message('{tooltip}locale')}"></i></label>
        [@locale.select ""/]
      </div>
    [#else]
      <input type="hidden" name="locale" value=""/>
    [/#if]
    <input type="hidden" name="isDefault" value="${isDefault?string}"/>
    [@control.textarea name="messages" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" tooltip=function.message('{tooltip}messages')/]

    [#if missingValues?has_content]
      <div class="form-row mt-4">
        <label for="missingProperties" class="error"></label>
        <textarea id="missingProperties">
[#list missingValues?keys as missingKey]
${missingKey}=${missingValues[missingKey]}
[/#list]
        </textarea>
      </div>
    [/#if]
  </fieldset>

[/@dialog.form]