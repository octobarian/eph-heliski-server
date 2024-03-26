[#ftl/]
[#-- @ftlvariable name="group" type="io.fusionauth.domain.Group" --]
[#-- @ftlvariable name="member" type="io.fusionauth.domain.GroupMember" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=member propertyName="id"/]
    [@properties.rowEval nameKey="created" object=member propertyName="insertInstant"/]
    [@properties.row nameKey="tenant" value=helpers.tenantName(user.tenantId)/]
    [@properties.rowEval nameKey="insertInstant" object=member propertyName="insertInstant"/]
  [/@properties.table]

  <h3>[@message.print key="group"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=group propertyName="id"/]
    [@properties.rowEval nameKey="name" object=group propertyName="name"/]
  [/@properties.table]

  [#if (member.data)?? && member.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(member.data)}</pre>
  [/#if]
[/@dialog.view]
