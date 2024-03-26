[#ftl/]
[#-- @ftlvariable name="consents" type="java.util.List<io.fusionauth.domain.Consent>" --]
[#-- @ftlvariable name="field" type="io.fusionauth.domain.form.FormField" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    [#if action == "add"]
      [@control.text name="fieldId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="fieldId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="field.name" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    [#if action == "add"]
      [@control.select name="field.key" items=userFields valueExpr="first" l10nExpr="second" tooltip=function.message('{tooltip}field.key')  headerValue="" headerL10n="select-key"/]
      [#-- The Id fields allow this field to be asserted on in tests --]
      [@control.text id="user-data-key" name="customKey"  labelKey="field.key.hide" autocapitalize="off" autocomplete="off" autocorrect="off" leftAddonText="user.data." required=true wideTooltip=function.message('{tooltip}user.data.') additionalFormRowClasses="slide-open${((field.key!'') == 'user.data.')?then(' open', '')}" /]
      [@control.text id="registration-data-key" name="customKey" labelKey="field.key.hide" autocapitalize="off" autocomplete="off" autocorrect="off"  leftAddonText="registration.data." required=true wideTooltip=function.message('{tooltip}registration.data.') additionalFormRowClasses="slide-open${((field.key!'') == 'registration.data.')?then(' open', '')}"/]
      [@control.select name="field.consentId" items=consents valueExpr="id" textExpr="name" required=true tooltip=function.message('{tooltip}consents.') headerValue=""  headerL10n="select-consent" /]
    [#else]
      [@control.hidden name="field.key"/]
      [@control.text name="field.key" tooltip=function.message('{tooltip}readOnly') disabled=true/]
      [@control.hidden name="field.consentId"/]
      [@control.select disabled=true name="field.consentId" items=consents valueExpr="id" textExpr="name" required=true tooltip=function.message('{tooltip}readOnly') headerValue=""  headerL10n="select-consent" /]
    [/#if]
  </fieldset>
  <fieldset>
    [#if action == "add"]
      [@control.select items=controls name="field.control" tooltip=function.message('{tooltip}field.control')/]
      [@control.select items=types name="field.type" tooltip=function.message('{tooltip}field.type')/]
      [@control.hidden name="field.type" disabled=true/]
    [#else]
      [@control.hidden name="field.control"/]
      [@control.select items=controls name="field.control" tooltip=function.message('{tooltip}readOnly') disabled=true/]

      [@control.hidden name="field.type"/]
      [@control.select items=types name="field.type" tooltip=function.message('{tooltip}readOnly') disabled=true/]
    [/#if]
    [@control.textarea id="field-options" name="options" labelKey="field.options" tooltip=message.inline('{tooltip}field.options')/]
  </fieldset>
  [@control.checkbox name="field.required" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}field.required') /]
  [@control.checkbox name="field.confirm" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}field.confirm') /]
  <fieldset id="field-validator-fieldset" >
    [@control.checkbox name="field.validator.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}field.validator.enabled') data_slide_open="field-validator-expression"/]
    <div id="field-validator-expression" class="slide-open [#if field.validator.enabled]open[/#if]">
      [@control.text name="field.validator.expression" autocapitalize="off" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}field.validator.expression')/]
    </div>
  </fieldset>
[/#macro]