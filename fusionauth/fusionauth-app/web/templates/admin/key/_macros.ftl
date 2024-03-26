[#ftl/]
[#-- @ftlvariable name="key" type="io.fusionauth.domain.Key" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="keyId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}keyId')/]
    [#else]
      [@control.text name="keyId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="key.name" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}key.name')/]
  </fieldset>
[/#macro]