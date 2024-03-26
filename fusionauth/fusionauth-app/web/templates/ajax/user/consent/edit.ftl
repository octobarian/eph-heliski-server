[#ftl/]
[#-- @ftlvariable name="userConsent" type="io.fusionauth.domain.UserConsent" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.form action="edit" formClass="full"]
<fieldset>
  [@control.hidden name="userConsentId" /]
  [@control.text name="consent.name"  disabled=true /]
  [#if userConsent.consent.multipleValuesAllowed]
    [@control.checkbox_list name="userConsent.values" labelKey="values" items=userConsent.consent.values /]
  [#else]
    [@control.select name="userConsent.values" labelKey="value" headerL10n="no-value-selected" headerValue="" items=userConsent.consent.values /]
  [/#if]
</fieldset>
[/@dialog.form]
