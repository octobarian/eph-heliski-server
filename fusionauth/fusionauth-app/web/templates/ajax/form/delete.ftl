[#ftl/]
[#-- @ftlvariable name="formId" type="java.util.UUID" --]
[#-- @ftlvariable name="form" type="io.fusionauth.domain.form.Form" --]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]
[@dialog.confirm action="delete" key="are-you-sure" idField="formId"]
  [@message.showAPIErrorRespones storageKey="io.fusionauth.form.delete.errors"/]
  <fieldset>
    [@properties.table]
      [@properties.rowEval nameKey="name" object=form!{} propertyName="name"/]
      [@properties.rowEval nameKey="id" object=form!{} propertyName="id"/]
    [/@properties.table]
  </fieldset>
[/@dialog.confirm]
