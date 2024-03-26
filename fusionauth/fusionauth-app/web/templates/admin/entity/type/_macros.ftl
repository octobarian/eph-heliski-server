[#ftl/]
[#setting url_escaping_charset='UTF-8'/]

[#-- @ftlvariable name="accessTokenKeys" type="io.fusionauth.domain.Key[]" --]
[#-- @ftlvariable name="entityType" type="io.fusionauth.domain.EntityType" --]
[#-- @ftlvariable name="entityTypes" type="java.util.List<io.fusionauth.domain.EntityType>" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    [#if action=="edit"]
      [@control.hidden name="entityTypeId"/]
      [@control.text disabled=true name="entityTypeId" tooltip=message.inline('{tooltip}readOnly')/]
    [#else]
      [@control.text name="entityTypeId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}entityTypeId')/]
    [/#if]
    [@control.text required=true name="entityType.name" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]
  </fieldset>

  <fieldset class="mt-4">
    <ul class="tabs">
      [#if action == "add"]
      <li><a href="#permissions">[@message.print key="permissions"/]</a></li>
      [/#if]
      <li><a href="#jwt-settings">[@message.print key="jwt"/]</a></li>
    </ul>
    <div id="jwt-settings" class="hidden">
      <p>
        <em>[@message.print key="{description}jwt-settings"/]</em>
      </p>
      [@control.checkbox name="entityType.jwtConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="jwt-settings-body"/]
      <div id="jwt-settings-body" data-jwt-settings-body="true" class="slide-open ${entityType.jwtConfiguration.enabled?then('open', '')}">
        [@control.text name="entityType.jwtConfiguration.timeToLiveInSeconds" title="${helpers.approximateFromSeconds(entityType.jwtConfiguration.timeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message("{tooltip}jwtConfiguration.timeToLiveInSeconds")/]
        [@control.select name="entityType.jwtConfiguration.accessTokenKeyId" items=accessTokenKeys![] required=false valueExpr="id" textExpr="displayName" headerValue="" headerL10n="none-selected-use-tenant" tooltip=function.message('{tooltip}jwtConfiguration.accessTokenKeyId')/]
      </div>
    </div>
    [#if action == "add"]
    <div id="permissions" class="hidden">
      <table id="permission-table" data-template="permission-row-template" data-add-button="permission-add-button">
        <thead>
        <tr>
          <th>[@message.print key="name"/]</th>
          <th>[@message.print key="default"/]</th>
          <th>[@message.print key="description"/]</th>
          <th data-sortable="false" class="action">[@message.print key="action"/]</th>
        </tr>
        </thead>
        <tbody>
        <tr class="empty-row">
          <td colspan="4">[@message.print key="no-permissions"/]</td>
        </tr>
        [#if entityType?? && entityType.permissions?size > 0]
          [#list entityType.permissions as permission]
            <tr>
              <td><input type="text" class="tight" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="entityType.permissions[${permission_index}].name" value="${((permission.name)!'')}"/></td>
              <td><input type="checkbox" class="tight" name="entityType.permissions[${permission_index}].isDefault" value="true" [#if (permission.isDefault)!false]checked[/#if]/></td>
              <td><input type="text" class="tight" autocomplete="off" placeholder="${function.message("description")}" name="entityType.permissions[${permission_index}].description" value="${((permission.description)!'')}"/></td>
              <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
            </tr>
          [/#list]
        [/#if]
        </tbody>
      </table>
      <script type="x-handlebars" id="permission-row-template">
        <tr>
          <td><input type="text" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="entityType.permissions[{{index}}].name"/></td>
          <td><label class="checkbox"><input type="checkbox" name="entityType.permissions[{{index}}].isDefault"/><span class="box"></span></label></td>
          <td><input type="text" autocomplete="off" placeholder="${function.message("description")}" name="entityType.permissions[{{index}}].description"/></td>
          <td>[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
        </tr>
      </script>
      [@button.iconLinkWithText href="#" color="blue" id="permission-add-button" icon="plus" textKey="add-permission"/]
    </div>
    [/#if]
  </fieldset>
[/#macro]
