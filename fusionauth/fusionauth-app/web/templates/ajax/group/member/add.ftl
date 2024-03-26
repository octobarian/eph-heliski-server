[#ftl/]
[#-- @ftlvariable name="bulkManagement" type="boolean" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "_macros.ftl" as memberMacros/]

[#-- 1. When being called on the manage page, groups will be defined, keep submit enabled
     2. When being called from the user index page to bulk add, disable the submit once there are errors.
--]
[@dialog.form action="add" formClass="labels-left full" disableSubmit=(bulkManagement && errorMessages?has_content)]
  [@memberMacros.memberFields bulkManagement/]
[/@dialog.form]
