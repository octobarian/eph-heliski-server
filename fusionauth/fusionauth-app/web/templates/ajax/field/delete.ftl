[#ftl/]
[#-- @ftlvariable name="fieldId" type="java.util.UUID" --]
[#-- @ftlvariable name="field" type="io.fusionauth.domain.form.FormField" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[@dialog.confirm action="delete" key="are-you-sure" idField="fieldId"/]
