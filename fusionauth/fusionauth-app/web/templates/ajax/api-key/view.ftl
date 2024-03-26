[#ftl/]
[#-- @ftlvariable name="apiKey" type="io.fusionauth.domain.APIKey" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=apiKey propertyName="id"/]
    [@properties.rowNestedValue nameKey="key"]
    <span data-secure-reveal="${apiKey.id}" class="d-inline-block">
      <a href="#" data-tooltip="${message.inline("click-to-reveal")}">
        <i class="fa fa-lock red-text"></i>
        &hellip;${apiKey.key?substring(apiKey.key?length - 7)}
      </a>
    </span>
    [/@properties.rowNestedValue]
    [@properties.row nameKey="description" value=properties.displayMapValue((apiKey.metaData.attributes)!'', "description")/]
    [@properties.rowEval nameKey="key-manager" object=apiKey propertyName="keyManager"/]
    [#if apiKey.tenantId??]
      [@properties.row nameKey="tenant" value=helpers.tenantName(apiKey.tenantId)/]
    [#else]
      [@properties.row nameKey="tenant" value=message.inline("all-tenants")/]
    [/#if]
    [@properties.rowEval nameKey="insertInstant" object=apiKey propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=apiKey propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="endpoints"/]</h3>
  [#if (apiKey.permissions.endpoints)?has_content]
    <table class="fields">
      <thead>
        <tr>
          <th>[@message.print key="endpoint"/]</th>
          <th class="text-center">[@message.print key="GET"/]</th>
          <th class="text-center">[@message.print key="POST"/]</th>
          <th class="text-center">[@message.print key="PUT"/]</th>
          <th class="text-center">[@message.print key="PATCH"/]</th>
          <th class="text-center">[@message.print key="DELETE"/]</th>
        </tr>
      </thead>
      <tbody>
      [#list apiKey.permissions.endpoints?keys as endpoint]
        <tr>
          <td>${endpoint}</td>
          <td class="text-center">[@properties.displayCheck apiKey.permissions.endpoints[endpoint].contains('GET')/]</td>
          <td class="text-center">[@properties.displayCheck apiKey.permissions.endpoints[endpoint].contains('POST')/]</td>
          <td class="text-center">[@properties.displayCheck apiKey.permissions.endpoints[endpoint].contains('PUT')/]</td>
          <td class="text-center">[@properties.displayCheck apiKey.permissions.endpoints[endpoint].contains('PATCH')/]</td>
          <td class="text-center">[@properties.displayCheck apiKey.permissions.endpoints[endpoint].contains('DELETE')/]</td>
        </tr>
      [/#list]
      </tbody>
    </table>
  [#else]
    <p>[@message.print "superuser"/]</p>
  [/#if]
[/@dialog.view]