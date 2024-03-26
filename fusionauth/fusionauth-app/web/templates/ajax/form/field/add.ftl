[#ftl/]
[#-- @ftlvariable name="fields" type="java.util.List<io.fusionauth.domain.form.FormField>" --]
[#-- @ftlvariable name="step" type="int" --]

[#import "../../../_utils/dialog.ftl" as dialog/]

[@dialog.form action="add" formClass="full left"]
<fieldset>
  <input type="hidden" data-step="${step}" />
  [#list fields as field]
  <input type="hidden" data-name="${field.name}" data-id="${field.id}" data-key="${field.key}" data-control="${field.control}" data-required="${field.required?c}" data-type="${field.type}" />
  [/#list]
  [@control.select items=fields name="fieldId" textExpr="name" valueExpr="id" /]
</fieldset>
[/@dialog.form]

