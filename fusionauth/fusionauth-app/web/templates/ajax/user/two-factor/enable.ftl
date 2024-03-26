[#ftl/]
[#-- @ftlvariable name="availableMethods" type="java.util.List<java.lang.String>" --]
[#-- @ftlvariable name="secretBase32Encoded" type="java.lang.String" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as twoFactorMacros/]

[@dialog.form action="${request.contextPath}/ajax/user/two-factor/enable" id="two-factor-form" formClass="full"]
  <div class="row">
    <div class="col-xs">
      <p class="mt-0 mb-4">
        <em>[@message.print key="{description}enable-two-factor"/]</em>
      </p>
      <fieldset data-email="${ftlCurrentUser.email!''}" data-sms="${ftlCurrentUser.mobilePhone!''}">
        [@control.hidden name="secret"/]
        [@control.hidden name="secretBase32Encoded"/]
        [#assign availableMethodObject = {}/]
        [#list availableMethods![] as method ]
          [#assign availableMethodObject = availableMethodObject + { method: message.inline(method)} /]
        [/#list]
        [#if availableMethodObject?size == 1]
          [@control.select name="method" items=availableMethodObject required=true autofocus="autofocus" /]
        [#else]
          [@control.select name="method" items=availableMethodObject required=true autofocus="autofocus" headerValue="" headerL10n="select-method" /]
        [/#if]

        [@twoFactorMacros.twoFactorFields "enable"/]
      </fieldset>
    </div>
  </div>
[/@dialog.form]