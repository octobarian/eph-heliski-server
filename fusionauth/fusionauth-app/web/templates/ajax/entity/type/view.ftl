[#ftl/]
[#-- @ftlvariable name="accessTokenKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="entityType" type="io.fusionauth.domain.EntityType" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=entityType propertyName="name"/]
    [@properties.rowEval nameKey="id" object=entityType propertyName="id"/]
    [@properties.rowEval nameKey="insertInstant" object=entityType propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=entityType propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="jwtConfiguration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="enabled" object=entityType.jwtConfiguration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="timeToLiveSeconds" object=entityType.jwtConfiguration propertyName="timeToLiveInSeconds"/]
    [@properties.rowEval nameKey="accessTokenKey" object=accessTokenKey!{} propertyName="name"/]
  [/@properties.table]

  [#--  Permissions --]
  <h3>[@message.print key="permissions"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print key="name"/]</th>
        <th>[@message.print key="id"/]</th>
        <th class="text-center">[@message.print key="default"/]</th>
        <th>[@message.print key="description"/]</th>
      </tr>
    </thead>
    <tbody>
      [#if (entityType.permissions)?has_content]
        [#list entityType.permissions as permission]
          <tr>
            <td>${properties.display(permission, 'name')}</td>
            <td>${properties.display(permission, 'id')}</td>
            <td class="text-center">${properties.display(permission, 'isDefault')}</td>
            <td>${properties.display(permission, 'description')}</td>
          </tr>
        [/#list]
      [/#if]
    </tbody>
  </table>

  [#if (entityType.data)?? && entityType.data?has_content]
    <h3>[@message.print key="data"/]</h3>
    <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(entityType.data)}</pre>
  [/#if]
[/@dialog.view]
