[#ftl/]
[#import "message.ftl" as message/]

[#macro rules passwordValidationRules tenantId]
<div class="font-italic" id="password-rules-${tenantId}">
  [@message.print "password-rules"/]
  <ul>
    <li>[@message.print key="password-length" values=[passwordValidationRules.minLength, passwordValidationRules.maxLength]/]</li>
    [#if passwordValidationRules.requireMixedCase]
      <li>[@message.print "password-mixedCase"/]</li>
    [/#if]
    [#if passwordValidationRules.requireNonAlpha]
      <li>[@message.print "password-nonAlpha"/]</li>
    [/#if]
    [#if passwordValidationRules.requireNumber]
      <li>[@message.print "password-requireNumber"/]</li>
    [/#if]
    [#if passwordValidationRules.rememberPreviousPasswords.enabled]
      <li>[@message.print key="password-previously-used" values=[passwordValidationRules.rememberPreviousPasswords.count]/]</li>
    [/#if]
  </ul>
</div>
[/#macro]