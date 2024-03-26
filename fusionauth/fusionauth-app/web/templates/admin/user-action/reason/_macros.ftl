[#ftl/]
[#-- @ftlvariable name="userActionReason" type="io.fusionauth.domain.UserActionReason" --]
[#-- @ftlvariable name="locales" type="java.util.Locale[]" --]
[#-- @ftlvariable name="userActionReasonId" type="java.util.UUID" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/locale.ftl" as locale/]
[#import "../../../_utils/message.ftl" as message/]

[#macro localizedTable id templateId addButtonId values field]
  <table id="${id}" data-template="${templateId}" data-add-button="${addButtonId}" data-field="${field}">
    <thead>
    <tr>
      <th>[@message.print key="locale"/]</th>
      <th>[@message.print key="text"/]</th>
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
    </tr>
    </thead>
    <tbody>
    <tr class="empty-row">
      <td colspan="3">[@message.print key="no-localized-texts"/]</td>
    </tr>
      [#if values?? && values?size > 0]
        [#list values?keys as l]
        <tr>
          <td>
            [@locale.select l/]
          </td>
          <td>
            <input type="text" class="tight" placeholder="[@message.print key="text"/]" name="${field}['${l}']" value="${(values(l))}"/>
          </td>
          <td class="action">
            [@button.action href="#" icon="trash" key="delete" color="red" additionalClass="delete-button"/]
          </td>
        </tr>
        [/#list]
      [/#if]
    </tbody>
  </table>
  [@button.iconLinkWithText href="#" textKey="add-localization" tooltipKey="add-localization" icon="plus" color="blue" id=addButtonId/]
[/#macro]

[#macro formFields action]
  <fieldset>
    [#if action == "add"]
      [@control.text name="userActionReasonId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.hidden name="userActionReasonId"/]
      [@control.text name="userActionReasonId" autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}userActionReasonId-edit')/]
    [/#if]
    [@control.text name="userActionReason.text" autocapitalize="on" autocomplete="off" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}userActionReason.text')/]
    [@control.text name="userActionReason.code" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}userActionReason.code')/]
  </fieldset>
  <fieldset>
    <p class="no-top-margin"><em>[@message.print key="localization-info"/]</em></p>
    <legend>[@message.print key="localization"/]</legend>
    [@localizedTable id="localized-texts" templateId="localization-template" addButtonId="add-localized-text" values=userActionReason.localizedTexts!{} field="userActionReason.localizedTexts"/]
    <script id="localization-template" type="text/x-handlebars-template">
      <tr>
        <td>
          [@locale.select ""/]
        </td>
        <td>
          <input type="text" class="tight" placeholder="[@message.print key="text"/]" name="{{field}}['${locales[0]}']"/>
        </td>
        <td class="action">
          [@button.action href="#" icon="trash" key="delete" color="red" additionalClass="delete-button"/]
        </td>
      </tr>
    </script>
  </fieldset>
[/#macro]