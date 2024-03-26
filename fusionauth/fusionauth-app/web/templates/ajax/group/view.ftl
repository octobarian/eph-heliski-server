[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.Map<java.util.UUID, io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="group" type="io.fusionauth.domain.Group" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=group propertyName="name"/]
    [@properties.rowEval nameKey="id" object=group propertyName="id"/]
    [@properties.row nameKey="tenant" value=helpers.tenantName(group.tenantId)/]
    [@properties.rowEval nameKey="insertInstant" object=group propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=group propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#-- Roles --]
  <h3>[@message.print key="application-roles"/]</h3>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="application"/]</th>
      <th>[@message.print key="roles"/]</th>
    </tr>
    </thead>
    <tbody>
        [#list group.roles!{} as key, roles]
        <tr>
          [#--noinspection FtlReferencesInspection--]
          <td> ${properties.display(applications(key), "name")}</td>
          <td>
            [#list roles as role]
              ${role.name}${role?has_next?then(function.message('listSeparator'), '')}
            [/#list]
          </td>
        </tr>
        [#else]
        <tr>
          <td colspan="3">[@message.print key="no-roles"/]</td>
        </tr>
        [/#list]
    </tbody>
  </table>

  [#if (group.data)?? && group.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(group.data)}</pre>
  [/#if]
[/@dialog.view]
