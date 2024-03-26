[#ftl/]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]

[#-- The caller should insert this HTML into an existing select element --]
[#list groups![] as group]
 <option value="${group.id}">${group.name}</option>[#lt]
[/#list]
