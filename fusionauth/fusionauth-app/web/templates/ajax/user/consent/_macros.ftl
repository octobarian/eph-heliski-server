[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]
[#-- @ftlvariable name="consents" type="java.util.List<io.fusionauth.domain.Consent>" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]
[#import "../../../_utils/message.ftl" as message/]

[#macro consentFields]
  <div id="consent-controls">
    <fieldset>
      [@control.hidden name="userId"/]
      [@control.select name="consentId" items=consents!{} textExpr="name" required=true valueExpr="id" headerL10n="selection-required" headerValue=""/]
      [#-- Using a literal map so we can account for a null name and fall back to loginId --]
      [@control.select name="userConsent.userId" items={user.id: user.name!user.login}  disabled=true tooltip=message.inline("{tooltip}userConsent.userId")/]
    </fieldset>
    [#if consent?has_content]
      <fieldset>
        [#-- Using a literal map so we can account for a null name and fall back to loginId --]
        [#local userMap = {}/]
        [#list users as u]
          [#local userMap = userMap + {u.id: u.name!u.login} /]
        [/#list]
        [@control.select name="userConsent.giverUserId" items=userMap tooltip=message.inline("{tooltip}userConsent.giverUserId")/]
        [#if consent.values?has_content]
          [#if consent.multipleValuesAllowed]
            [@control.checkbox_list name="userConsent.values" labelKey="values" items=consent.values tooltip=message.inline("{tooltip}userConsent.values")/]
          [#else]
            [@control.select name="userConsent.values" labelKey="value" items=consent.values headerL10n="no-value-selected" headerValue="" tooltip=message.inline("{tooltip}userConsent.values")/]
          [/#if]
        [/#if]
      </fieldset>
    [/#if]
  </div>
[/#macro]