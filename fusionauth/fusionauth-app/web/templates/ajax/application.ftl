[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]

[#-- The caller should insert this HTML into an existing select element --]
[#list applications![] as application]
 <option value="${application.id}">${application.name}</option>[#lt]
[/#list]
