[#ftl/]
[#-- @ftlvariable name="ipAccessControlList" type="io.fusionauth.domain.IPAccessControlList" --]
[#-- @ftlvariable name="blocked" type="java.lang.Boolean" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.form action="test" formClass="full" submitIcon="flask" submitTextKey="test" cancelTextKey="close"]
  [@properties.table]
    [@properties.row nameKey="id" value=properties.display(ipAccessControlList, "id")/]
    [@properties.row nameKey="name" value=properties.display(ipAccessControlList, "name")/]
  [/@properties.table]

  <table>
    <thead style="display: table; table-layout: fixed; width: 100%;">
      <tr>
        <th>[@message.print key="startIPAddress"/]</th>
        <th>[@message.print key="endIPAddress"/]</th>
        <th>[@message.print key="action"/]</th>
      </tr>
    </thead>
    <tbody class="scrollable vertical" style="display: block; max-height: 400px;">
    [#list ipAccessControlList.entries as entry]
      <tr style="display: table; table-layout: fixed; width: 100%;">
        <td>${properties.display(entry, "startIPAddress")}</td>
        <td>${properties.display(entry, "endIPAddress")}</td>
        <td>${properties.display(entry, "action")}</td>
      </tr>
    [/#list]
    </tbody>
  </table>

  <p class="mb-3">
    <em>[@message.print key="{description}test" /]</em>
  </p>
  <fieldset>
    [@control.hidden name="ipAccessControlListId" /]
    [@control.text name="testIPAddress" autofocus="autofocus" required=true/]
    [#if blocked??]
     <span class="blocked-result ${blocked?then('red', 'green')}-text ml-1">
      [#if blocked]
      <i class="fa fa-times"></i> [@message.print key="blocked" /]
      [#else]
      <i class="fa fa-check"></i> [@message.print key="allowed" /]
      [/#if]
     </span>
    [/#if]
  </fieldset>
[/@dialog.form]