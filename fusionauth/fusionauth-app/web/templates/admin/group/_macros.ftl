[#ftl/]
[#-- @ftlvariable name="group" type="io.fusionauth.domain.Group"--]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>"--]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>"--]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Group>" --]

[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro groupsTable]
  <table class="hover listing" data-sortable="false">
    <thead>
      [@helpers.tableHeader "name"/]
      [@helpers.tableHeader "id" "hide-on-mobile"/]
      [#if tenants?size > 1]
          [@helpers.tableHeader "tenant" /]
      [/#if]
      <th data-sortable="false" class="action">[@message.print "action"/]</th>
    </thead>
    <tbody>
      [#list results![] as group]
        <tr>
          <td>${properties.display(group, "name")}</td>
          <td class="hide-on-mobile">${properties.display(group, "id")}</td>
          [#if tenants?size > 1]
            <td class="hide-on-mobile"> ${helpers.tenantName(group.tenantId)}</td>
          [/#if]
          <td class="action">
            [@button.action href="/admin/group/edit/${group.id}?tenantId=${group.tenantId}" icon="edit" key="edit" color="blue" /]
            [@button.action href="add?groupId=${group.id}&tenantId=${group.tenantId}" icon="copy" key="duplicate" color="purple"/]
            [@button.action href="/ajax/group/view/${group.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
            [@button.action href="/admin/group/delete?groupId=${group.id}&tenantId=${group.tenantId}" icon="trash" key="delete" color="red"/]
          </td>
        </tr>
      [#else]
        <tr>
          <td colspan="4">
            [@message.print key="no-results"/]
          </td>
        </tr>
      [/#list]
    </tbody>
  </table>
[/#macro]

[#macro groupFields action]
  <fieldset>
    [#if action=="edit"]
      [@control.hidden name="groupId"/]
      [@control.hidden name="tenantId"/]
      [@control.text disabled=true name="groupId" tooltip=message.inline('{tooltip}readOnly')/]
      [#if tenants?size > 1]
        [@control.text name="tenantId" labelKey="tenant" value=helpers.tenantName(tenantId) disabled=true tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
    [#else]
      [@control.text name="groupId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}groupId')/]
    [/#if]
    [@control.text required=true name="group.name" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]

    [#if action=="add"]
      [#if tenants?size == 1]
        [@control.hidden name="tenantId" value=tenants?keys?first/]
      [#else]
        [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=true headerL10n="selection-required" headerValue="" tooltip=function.message('{tooltip}tenant')/]
      [/#if]
    [/#if]

  </fieldset>

  <fieldset class="form-row mt-4" >
    <legend>[@message.print "roles"/]</legend>
    [#if action == "add" && tenants?size > 1]
      <p><em>[@message.print "tenant-required-for-roles"/]</em></p>
    [/#if]

    [#-- Make a section for each tenant even if they have no applications so we can indicate no roles exist in this tenant --]
    [#list tenants as tenantId, tenant]
      [#list applications as app]
        [#if app.tenantId == tenantId]
          [#if app.roles?has_content]
            <div data-tenant-id="${tenantId}" [#if tenants?size > 1]class="hidden"[/#if]>
              [@control.checkbox_list items=app.roles name="roleIds" valueExpr="id" textExpr="display" labelRaw=app.name labelKey="empty" class="checkbox-list taller"/]
            </div>
          [/#if]
        [/#if]
      [/#list]
      <div id="no-application-roles" class="hidden">
       [@message.alert message.inline("no-application-roles") "info" "info-circle" false/]
      </div>
    [/#list]
  </fieldset>
[/#macro]
