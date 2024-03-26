[#-- @ftlvariable name="email" type="java.lang.String" --]
[#-- @ftlvariable name="mobilePhone" type="java.lang.String" --]
[#-- @ftlvariable name="secretBase32Encoded" type="java.lang.String" --]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]


[#macro twoFactorFields action]
<div>
  <div class="form-row">
  <label></label>
  <div class="d-inline-block">
    <div class="d-flex">
      <div style="flex-grow: 1;">
        <fieldset id="authenticator-instructions">
          [#if action == "enable"]
            <legend>[@message.print key="instructions"/]</legend>
            <p>[@message.print key="{description}two-factor.authenticator.step1" values=[secretBase32Encoded] /]</p>
            <p>[@message.print key="{description}two-factor.authenticator.step2" /]</p>
          [#else]
            <p>[@message.print key="{description}two-factor.authenticator.step1" /]</p>
          [/#if]
        </fieldset>
        <fieldset id="email-instructions">
          <div class="d-flex">
            <div style="flex-grow: 1;">
              [#if action == "enable"]
                <legend>[@message.print key="instructions"/]</legend>
                <p class="mt-0">${message.inline("{description}two-factor.email.step1")} </p>
                [@control.text name="email" autocapitalize="none" autocomplete="off" autocorrect="off" required=true value="${email?has_content?then(email, ftlCurrentUser.email!'')}"/]
              [#else]
                <p class="mt-0">${message.inline("{description}two-factor.email.step1")} </p>
              [/#if]
              [@button.iconLinkWithText id="send-email-code" textKey="send" href="#" icon="arrow-circle-right" color="gray" /]
             </div>
          </div>
          <p class="mb-0">[@message.print key="{description}two-factor.email.step2" /]</p>
        </fieldset>
        <fieldset id="sms-instructions">

          <div class="d-flex">
            <div style="flex-grow: 1;">
            [#if action == "enable"]
              <legend>[@message.print key="instructions"/]</legend>
              <p class="mt-0">${message.inline("{description}two-factor.sms.step1")} </p>
              [@control.text name="mobilePhone" autocapitalize="none" autocomplete="off" autocorrect="off" required=true value="${mobilePhone?has_content?then(mobilePhone, ftlCurrentUser.mobilePhone!'')}"/]
             [#else]
               <p class="mt-0">${message.inline("{description}two-factor.sms.step1")} </p>
             [/#if]
             [@button.iconLinkWithText id="send-sms-code" textKey="send" href="#" icon="arrow-circle-right" color="gray" /]
             </div>
          </div>
          <p class="mb-0">[@message.print key="{description}two-factor.sms.step2" /]</p>
        </fieldset>
      </div>
      [#if action == "enable"]
        <div class="hidden pl-3" id="qrcode" data-account="${ftlCurrentUser.getLogin()}" data-issuer="${ftlCurrentTenant.issuer}" data-base32-secret="${secretBase32Encoded}"></div>
      [/#if]
    </div>
  </div>
  [#if action == "disable"]
  <fieldset>
   <p>[@message.print key="{description}two-factor.recovery-option"/]</p>
  </fieldset>
  [/#if]
  </div>

</div>

[@control.text name="code" autofocus="autofocus" autocapitalize="none" autocomplete="one-time-code" autocorrect="off" required=true/]
[/#macro]