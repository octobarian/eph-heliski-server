[#ftl/]
[#-- @ftlvariable name="ipAccessControlList" type="io.fusionauth.domain.IPAccessControlList" --]
[#-- @ftlvariable name="aclActions" type="io.fusionauth.domain.IPAccessControlEntryAction[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="ipAccessControlListId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="ipAccessControlListId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="ipAccessControlList.name" autocapitalize="none" autocomplete="on" autocorrect="off" autofocus="autofocus" required=true/]
  </fieldset>
  <fieldset class="mt-4">
    <ul class="tabs">
      <li><a href="#acl-entries">[@message.print key="acl-entries"/]</a></li>
    </ul>
    <div id="acl-entries">
      <fieldset>
        <p class="mt-0"><em>[@message.print key="{description}ipAccessControlList.entries"/]</em></p>
        <table id="acl-entries-table" class="u-small-bottom-margin" data-template="acl-entry-row-template" data-add-button="acl-entry-add-button">
          <thead>
          <tr>
            <th>[@message.print key="entry.startIPAddress"/]</th>
            <th>[@message.print key="entry.endIPAddress"/]</th>
            <th>[@message.print key="entry.action"/]</th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
          <tr class="empty-row">
            <td colspan="3">[@message.print key="no-acl-entries"/]</td>
          </tr>
            [#list ipAccessControlList.entries as entry]
            [#assign defaultRule = (entry.startIPAddress!'') == "*"/]
            <tr class="form-controls">
              <td>
                [@control.text name="ipAccessControlList.entries[${entry?index}].startIPAddress" labelKey="empty" disabled=defaultRule autocapitalize="none" autocomplete="off" autocorrect="off" includeFormRow=false/]
                [#if defaultRule][@control.hidden name="ipAccessControlList.entries[${entry?index}].startIPAddress" /][/#if]
              </td>
              <td>[@control.text name="ipAccessControlList.entries[${entry?index}].endIPAddress" labelKey="empty" disabled=defaultRule autocapitalize="none" autocomplete="off" autocorrect="off" includeFormRow=false/]</td>
              <td>[@control.select name="ipAccessControlList.entries[${entry?index}].action" labelKey="empty" items=aclActions includeFormRow=false/]</td>
              <td class="action">[@button.action href="#" icon="trash" key="delete" color="red" additionalClass=defaultRule?then("disabled", "delete-button")/]</td>
            </tr>
            [/#list]
          </tbody>
        </table>
        <script type="x-handlebars" id="acl-entry-row-template">
          <tr class="form-controls">
            <td><input type="text" name="ipAccessControlList.entries[{{index}}].startIPAddress" autocapitalize="none" autocomplete="off" autocorrect="off"/></td>
            <td><input type="text" name="ipAccessControlList.entries[{{index}}].endIPAddress" autocapitalize="none" autocomplete="off" autocorrect="off"/></td>
            <td>
              <label class="select">
                <select name="ipAccessControlList.entries[{{index}}].action">
                  <option name="Allow">${message.inline("Allow")}</option>
                  <option name="Block">${message.inline("Block")}</option>
                </select>
              </label>
            </td>
            <td class="action">[@button.action href="#" icon="trash" key="delete" additionalClass="delete-button" color="red"/]</a>
          </tr>
        </script>
        [@button.iconLinkWithText href="#" color="blue" icon="plus" textKey="add-acl-entry" id="acl-entry-add-button"/]
      </fieldset>
      [@message.showFieldErrors "ipAccessControlList.entries" /]
    </div>
  </fieldset>
[/#macro]