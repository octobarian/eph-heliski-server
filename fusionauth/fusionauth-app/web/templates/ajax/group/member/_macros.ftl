[#ftl/]
[#-- @ftlvariable name="groupId" type="java.util.UUID" --]
[#-- @ftlvariable name="group" type="io.fusionauth.domain.Group" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[#macro memberFields bulkManagement]
[@control.hidden name="bulkManagement"/]
<fieldset>
   [@control.hidden name="tenantId"/]
   [#if groupId?has_content && !bulkManagement]
     [@control.hidden name="groupId"/]
     [@control.text name="groupId" value="${group.name}" disabled=true/]
   [#else]
     [#local selectedGroup = ((groups![])?size == 1)?then(groups?first.id.toString(), '')/]
     [@control.select items=groups![] textExpr="name" valueExpr="id" headerValue="" headerL10n="select-a-group" name="groupId" selected="${selectedGroup}" required=true autofocus="autofocus"/]
   [/#if]
</fieldset>
<div class="scrollable vertical" style="max-height: 300px;">
  <table>
    <thead>
    <tr>
      <th>[@message.print key="login"/]</th>
      <th class="hide-on-mobile">[@message.print key="id"/]</th>
    </tr>
    </thead>
    <tbody>
      [#list users![] as user]
      <tr>
        <td>
          <input type="hidden" name="userId" value="${user.id}"/>
          ${user.login}
        </td>
        <td class="hide-on-mobile">${properties.display(user, "id")}</td>
      </tr>
      [/#list]
    </tbody>
  </table>
</div>
[/#macro]