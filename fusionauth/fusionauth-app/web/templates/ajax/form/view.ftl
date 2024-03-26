[#ftl/]
[#-- @ftlvariable name="form" type="io.fusionauth.domain.form.Form" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=form propertyName="name"/]
    [@properties.rowEval nameKey="id" object=form propertyName="id"/]
    [@properties.row nameKey="type" value=message.inline(form.type) /]
    [@properties.rowEval nameKey="insertInstant" object=form propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=form propertyName="lastUpdateInstant"/]
  [/@properties.table]
[/@dialog.view]