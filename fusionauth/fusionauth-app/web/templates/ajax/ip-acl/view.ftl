[#ftl/]
[#-- @ftlvariable name="ipAccessControlList" type="io.fusionauth.domain.IPAccessControlList" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=ipAccessControlList propertyName="id"/]
    [@properties.rowEval nameKey="name" object=ipAccessControlList propertyName="name"/]
    [@properties.rowEval nameKey="insertInstant" object=ipAccessControlList propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=ipAccessControlList propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#-- Entries --]
  <h3>[@message.print key="entries"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print key="startIPAddress"/]</th>
        <th>[@message.print key="endIPAddress"/]</th>
        <th>[@message.print key="action"/]</th>
      </tr>
    </thead>
    <tbody>
      [#list ipAccessControlList.entries as entry]
        <tr>
          <td>${properties.display(entry "startIPAddress")}</td>
          <td>${properties.display(entry "endIPAddress")}</td>
          <td>${properties.display(entry "action")}</td>
        </tr>
      [#else]
        <tr>
          <td colspan="3" style="font-weight: inherit;">[@message.print key="no-entries"/]</td>
        </tr>
      [/#list]
    </tbody>
  </table>

[/@dialog.view]
