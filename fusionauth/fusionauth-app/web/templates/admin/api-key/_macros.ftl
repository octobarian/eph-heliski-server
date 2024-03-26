[#ftl/]
[#-- @ftlvariable name="apiKey" type="io.fusionauth.domain.APIKey" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.APIKey>" --]
[#-- @ftlvariable name="endpoints" type="java.util.List<java.lang.String>" --]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/helpers.ftl" as helpers/]

[#macro apiKeysTable]
<table class="hover listing" data-sortable="false">
  <thead>
  <tr>
    [@helpers.tableHeader "key"/]
    [@helpers.tableHeader "id" "hide-on-mobile"/]
    <th data-sortable="false" class="hide-on-mobile">[@message.print key="description"/]</th>
    [@helpers.tableHeader "key-manager" "hide-on-mobile"/]
    <th data-sortable="false" class="hide-on-mobile">[@message.print key="tenant"/]</th>
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </tr>
  </thead>
  <tbody>
    [#list results![] as apiKey]
      <tr>
        <td class="break-all" style="min-width: 100px;" data-secure-reveal="${apiKey.id}">
          <a href="#" data-tooltip="${message.inline("click-to-reveal")}">
            <i class="fa fa-lock red-text"></i>&nbsp;
            &hellip;${apiKey.key?substring(apiKey.key?length - 7)}
          </a>
        </td>
        <td class="hide-on-mobile">${properties.display(apiKey, "id")}</td>
        <td class="hide-on-mobile">[@helpers.truncate (apiKey.metaData.attributes['description'])!'', 80/]</td>
        <td class="hide-on-mobile">${properties.displayBoolean(apiKey, "keyManager")}</td>
        <td class="hide-on-mobile">${apiKey.tenantId?has_content?then(helpers.tenantName(apiKey.tenantId), message.inline("all-tenants"))}</td>
        <td class="action">
          [@button.action href="edit/${apiKey.id}" icon="edit" key="edit" color="blue"/]
          [@button.action href="add?apiKeyId=${apiKey.id}" icon="copy" key="duplicate" color="purple"/]
          [@button.action href="/ajax/api-key/view/${apiKey.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
          [@button.action href="/ajax/api-key/delete/${apiKey.id}" icon="trash" key="delete" color="red" ajaxForm=true/]
        </td>
      </tr>
    [#else]
      <tr>
        <td colspan="6">[@message.print key="no-results"/]</td>
      </tr>
    [/#list]
  </tbody>
</table>
[/#macro]

[#macro endpointTable]
<legend>[@message.print key="endpoints"/]</legend>
[@message.alertColumn message=function.message('warning') type="warning" icon="exclamation-triangle" columnClass="col-xs tight-left" includeDismissButton=false/]
<p class="no-top-margin"><em>[@message.print key="instructions"/]</em></p>
<table id="endpoints" class="sticky-header api-keys">
  <thead>
  <tr>
    <th>[@message.print key="endpoint"/]</th>
    <th class="tight" data-select-col="GET"><a href="#">[@message.print key="GET"/]</a></th>
    <th class="tight" data-select-col="POST"><a href="#">[@message.print key="POST"/]</a></th>
    <th class="tight" data-select-col="PUT"><a href="#">[@message.print key="PUT"/]</a></th>
    <th class="tight" data-select-col="PATCH"><a href="#">[@message.print key="PATCH"/]</a></th>
    <th class="tight" data-select-col="DELETE"><a href="#">[@message.print key="DELETE"/]</a></th>
  </tr>
  </thead>
  <tbody>
    [#list endpoints as endpoint]
    <tr style="cursor: pointer;">
      <td data-select-row="true">${endpoint}</td>
      <td class="tight">[@control.checkbox name="apiKey.permissions.endpoints['" + endpoint + "']" value="GET" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="apiKey.permissions.endpoints['" + endpoint + "']" value="POST" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="apiKey.permissions.endpoints['" + endpoint + "']" value="PUT" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="apiKey.permissions.endpoints['" + endpoint + "']" value="PATCH" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="apiKey.permissions.endpoints['" + endpoint + "']" value="DELETE" labelKey="empty" includeFormRow=false/]</td>
    </tr>
    [/#list]
  </tbody>
</table>
[/#macro]
