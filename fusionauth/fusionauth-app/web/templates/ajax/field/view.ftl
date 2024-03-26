[#ftl/]
[#-- @ftlvariable name="field" type="io.fusionauth.domain.form.FormField" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=field propertyName="name"/]
    [@properties.rowEval nameKey="id" object=field propertyName="id"/]
    [@properties.row nameKey="control" value=message.inline(field.control) /]
    [@properties.row nameKey="type" value=message.inline(field.type) /]
    [@properties.rowEval nameKey="options" object=field propertyName="options"/]
    [@properties.rowEval nameKey="required" object=field propertyName="required" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="confirm" object=field propertyName="confirm" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="insertInstant" object=field propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=field propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="validation"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="enabled" object=field propertyName="validator.enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="expression" object=field propertyName="validator.expression"/]
  [/@properties.table]

  [#if (field.data)?? && field.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(field.data)}</pre>
  [/#if]
[/@dialog.view]