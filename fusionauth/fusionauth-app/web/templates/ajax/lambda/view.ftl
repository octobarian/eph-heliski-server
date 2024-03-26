[#ftl/]
[#-- @ftlvariable name="lambda" type="io.fusionauth.domain.Lambda" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=lambda propertyName="name"/]
    [@properties.rowEval nameKey="id" object=lambda propertyName="id"/]
    [@properties.rowRaw name=message.inline("engineType") value=message.inline("LambdaEngineType.${lambda.engineType}") /]
    [@properties.rowEval nameKey="debug" object=lambda propertyName="debug" booleanAsCheckmark=false/]
    [@properties.row nameKey="type" value=message.inline(lambda.type) /]
    [@properties.rowEval nameKey="insertInstant" object=lambda propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=lambda propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="body"/]</h3>
  <pre class="code">${lambda.body}</pre>
[/@dialog.view]
