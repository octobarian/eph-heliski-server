[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="isRegistered" type="boolean" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]

[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title=theme.message("account")/]
  [@helpers.body]
    [@helpers.header]
      [#-- Custom header code goes here --]
    [/@helpers.header]

    [@helpers.main title="" rowClass="row center" colClass="col-xs-12 col-sm-12 col-md-10 col-lg-8"]
      <a href="${request.contextPath}/account/logout?client_id=${client_id!''}">${theme.message("back-to-login")}</a>
    [/@helpers.main]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]
