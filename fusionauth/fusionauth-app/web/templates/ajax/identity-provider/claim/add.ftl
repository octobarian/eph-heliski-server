[#ftl/]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.form action="add" formClass="full"]
<fieldset>
  [@control.hidden name="identityProviderId"/]
  [@control.text name="incomingClaim" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true tooltip=function.message('{tooltip}incomingClaim')/]
  [#assign supportedClaims = fusionAuth.statics['io.fusionauth.api.service.identity.ExternalJWTIdentityProviderValidator'].SupportedClaimMappings/]
  [@control.select items=supportedClaims name="fusionAuthClaim" headerValue="" headerL10n="selection-required" required=true tooltip=function.message('{tooltip}fusionAuthClaim') /]
</fieldset>
[/@dialog.form]

