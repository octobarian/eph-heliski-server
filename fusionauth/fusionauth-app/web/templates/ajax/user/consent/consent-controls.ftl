[#ftl/]
[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]
[#-- @ftlvariable name="consents" type="java.util.List<io.fusionauth.domain.Consent>" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as consentMacros/]

[@consentMacros.consentFields/]
