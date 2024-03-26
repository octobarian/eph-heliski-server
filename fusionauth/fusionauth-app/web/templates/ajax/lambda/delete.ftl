[#ftl/]
[#-- @ftlvariable name="lambda" type="io.fusionauth.domain.Lambda" --]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]
[@dialog.confirm action="delete" key="are-you-sure" idField="lambdaId"]
  [@message.showAPIErrorRespones storageKey="io.fusionauth.lambda.delete.errors"/]
  <fieldset>
    [@properties.table]
      [@properties.rowEval nameKey="name" object=lambda!{} propertyName="name"/]
      [@properties.rowEval nameKey="id" object=lambda!{} propertyName="id"/]
    [/@properties.table]
  </fieldset>
[/@dialog.confirm]
