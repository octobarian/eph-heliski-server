[#ftl/]
[#-- @ftlvariable name="bulkManagement" type="boolean" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "_macros.ftl" as memberMacros/]

[@dialog.form action="remove" formClass="labels-left full" disableSubmit=errorMessages?has_content]
  [@memberMacros.memberFields bulkManagement/]
[/@dialog.form]
