[#ftl/]
[#-- @ftlvariable name="eventLog" type="io.fusionauth.domain.EventLog" --]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/dialog.ftl" as dialog/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>

  [@properties.table]
    [@properties.rowEval nameKey="id" object=eventLog propertyName="id"/]
    [@properties.rowEval nameKey="insertInstant" object=eventLog propertyName="insertInstant"/]
    [@properties.rowEval nameKey="type" object=eventLog propertyName="type"/]
  [/@properties.table]

  <h3>[@message.print key="message"/]</h3>
  <pre class="code">${eventLog.message}</pre>

[/@dialog.view]