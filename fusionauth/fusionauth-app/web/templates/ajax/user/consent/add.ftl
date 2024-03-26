[#ftl/]
[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]
[#-- @ftlvariable name="consents" type="java.util.List<io.fusionauth.domain.Consent>" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as consentMacros/]

[@dialog.form action="add" formClass="full" id="add-user-consent-form"]
  <div id="consent-controls">
    [@consentMacros.consentFields/]
  </div>
[/@dialog.form]
