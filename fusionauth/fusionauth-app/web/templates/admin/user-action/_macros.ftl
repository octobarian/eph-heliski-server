[#ftl/]
[#setting url_escaping_charset='UTF-8'/]

[#-- @ftlvariable name="userAction" type="io.fusionauth.domain.UserAction" --]
[#-- @ftlvariable name="userActions" type="java.util.List<io.fusionauth.domain.UserAction>" --]
[#-- @ftlvariable name="locales" type="java.util.Locale[]" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/locale.ftl" as locale/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro localizedTable id templateId addButtonId values field]
  <table id="${id}" data-template="${templateId}" data-add-button="${addButtonId}" data-field="${field}" class="col-sm-12 no-border">
    <tr class="empty-row">
      <td>
        [@message.print key="no-localized-names"/]
      </td>
    </tr>
    [#list values?keys as l]
      <tr>
        <td>
          <div class="row">
            <div class="col-xs-5 col-md-4 tight-left">
              [@locale.select l/]
            </div>
            <div class="col-xs-5 col-md-4 tight-left">
              <input type="text" placeholder="[@message.print key="text"/]" name="${field}['${l}']" value="${(values(l))}"/>
            </div>
            <div class="col-xs-2 col-md-4 tight-left">
              [@button.action href="#" color="red" additionalClass="delete-button" icon="trash" key="delete"/]
            </div>
          </div>
        </td>
      </tr>
    [/#list]
  </table>
  <div class="push-less-bottom">
    [@button.iconLinkWithText href="#" class="delete-button" textKey="delete-option" icon="trash"/]
    [@button.iconLinkWithText color="blue" icon="plus" href="#" textKey="add-localization" id=addButtonId/]
  </div>
[/#macro]

[#macro formFields action]
  <fieldset>
    [#if action == "add"]
      [@control.text name="userAction.id" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="userAction.id" disabled=true tooltip=function.message('{tooltip}userAction.id-edit')/]
    [/#if]
    [@control.text name="userAction.name" autocapitalize="on" autocomplete="off" autocorrect="on" autofocus="autofocus" required=true/]
    [@control.select items=transactionTypes name="userAction.transactionType" required=true tooltip=function.message('{tooltip}userAction.transactionType')/]
    [@control.checkbox name="userAction.temporal" value="true" uncheckedValue="false" data_slide_open="time-based-options" tooltip=function.message('{tooltip}userAction.temporal')/]
    <div id="time-based-options" class="slide-open [#if (userAction.temporal)!false]open[/#if]">
      [@control.checkbox name="userAction.preventLogin" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}userAction.preventLogin')/]
      [@control.checkbox name="userAction.sendEndEvent" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}userAction.sendEndEvent')/]
    </div>
    [@control.checkbox name="userAction.userNotificationsEnabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}userAction.userNotificationsEnabled')/]
  </fieldset>
  <ul class="tabs">
    <li><a href="#options">[@message.print key="options"/]</a></li>
    <li><a href="#localization">[@message.print key="localization"/]</a></li>
    <li><a href="#email">[@message.print key="email"/]</a></li>
  </ul>
  <div id="options">
    <fieldset>
      <p class="no-top-margin"><em>[@message.print key="option-info"/]</em></p>
      <table id="option-table" data-template="option-template">
        <thead>
        <tr>
          <th>[@message.print key="option"/]</th>
          <th data-sortable="false" class="action">[@message.print key="action"/]</th>
        </tr>
        </thead>
        <tbody>
        <tr class="empty-row">
          <td colspan="2">
            [@message.print key="no-options"/]
          </td>
        </tr>
          [#list (userAction.options)![] as option]
          <tr>
            <td>
              ${option.name}
              <input type="hidden" name="userAction.options[${option_index}].name" value="${option.name}"/>
              [#list (option.localizedNames!{})?keys as l]
                <input type="hidden" name="userAction.options[${option_index}].localizedNames['${l}']" value="${option.localizedNames(l)}"/>
              [/#list]
            </td>
            <td class="action">
              [#assign params="name=${option.name?url}"/]
              [#list (option.localizedNames!{})?keys as l]
                [#assign params=params + "&localizedNames['${l?url}']=${option.localizedNames(l)?url}"/]
              [/#list]
              [@button.action href="/ajax/user-action/validate-option?${params}" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
              [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button" ajaxForm=true/]
            </td>
          </tr>
          [/#list]
        </tbody>
      </table>
      <script id="option-template" type="text/x-handlebars-template">
        <tr>
          <td>
            {{name}}
            <input type="hidden" name="userAction.options[{{index}}].name" value="{{name}}"/>
            {{#each localizedNames as |name locale|}}
            <input type="hidden" name="userAction.options[{{../index}}].localizedNames['{{locale}}']" value="{{name}}"/>
            {{/each}}
          </td>
          <td class="action">
            [@button.action href="/ajax/user-action/validate-option?name={{name}}{{#each localizedNames as |name locale|}}&localizedNames['{{locale}}']={{name}}{{/each}}" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
            [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button" ajaxForm=true/]
          </td>
        </tr>
      </script>
      [@button.iconLinkWithText icon="plus" href="/ajax/user-action/validate-option" id="option-add-button" textKey="add-option" color="blue"/]
    </fieldset>
  </div>

  <div id="localization">
    <fieldset>
      <p class="no-top-margin"><em>[@message.print key="localization-info"/]</em></p>
      <table id="localized-names" data-template="localization-template" data-add-button="add-localized-name" data-field="userAction.localizedNames">
        <thead>
        <tr>
          <th>[@message.print key="locale"/]</th>
          <th>[@message.print key="text"/]</th>
          <th data-sortable="false" class="action">[@message.print key="action"/]</th>
        </tr>
        </thead>
        <tbody>
        <tr class="empty-row">
          <td colspan="3">
            [@message.print key="no-localized-names"/]
          </td>
        </tr>
          [#list (userAction.localizedNames!{})?keys as l]
          <tr>
            <td>[@locale.select l/]</td>
            <td><input type="text" placeholder="[@message.print key="text"/]" name="userAction.localizedNames['${l}']"
                       value="${(userAction.localizedNames(l))}"/></td>
            <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
          </tr>
          [/#list]
        </tbody>
      </table>
      [@button.iconLinkWithText color="blue" icon="plus" href="#" textKey="add-localization" id="add-localized-name"/]
      <script id="localization-template" type="text/x-handlebars-template">
        <tr>
          <td>[@locale.select ""/]</td>
          <td><input type="text" placeholder="[@message.print key="text"/]" name="{{field}}['${locales[0]}']"/></td>
          <td class="action">[@button.action icon="trash" color="red" key="delete" additionalClass="delete-button" href="#"/]</td>
        </tr>
      </script>
    </fieldset>
  </div>

  <div id="email">
    <fieldset>
      <p class="no-top-margin"><em>[@message.print key="email-info"/]</em></p>
      [@control.checkbox name="userAction.userEmailingEnabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}userAction.userEmailingEnabled')/]
      [@control.checkbox name="userAction.includeEmailInEventJSON" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}userAction.includeEmailInEventJSON')/]
    </fieldset>
    <div id="start-email-template">
      [@control.select selected="${userAction.startEmailTemplateId!''}" items=emailTemplates name="userAction.startEmailTemplateId" textExpr="name" valueExpr="id" headerValue="" headerL10n="selection-required" tooltip=function.message('{tooltip}userAction.startEmailTemplateId')/]
    </div>
    <div id="time-based-email-templates">
      [@control.select selected="${userAction.modifyEmailTemplateId!''}" items=emailTemplates name="userAction.modifyEmailTemplateId" textExpr="name" valueExpr="id" headerValue="" headerL10n="selection-required" tooltip=function.message('{tooltip}userAction.modifyEmailTemplateId')/]
      [@control.select selected="${userAction.cancelEmailTemplateId!''}" items=emailTemplates name="userAction.cancelEmailTemplateId" textExpr="name" valueExpr="id" headerValue="" headerL10n="selection-required" tooltip=function.message('{tooltip}userAction.cancelEmailTemplateId')/]
      [@control.select selected="${userAction.endEmailTemplateId!''}" items=emailTemplates name="userAction.endEmailTemplateId" textExpr="name" valueExpr="id" headerValue="" headerL10n="selection-required" tooltip=function.message('{tooltip}userAction.endEmailTemplateId')/]
    </div>
  </div>
[/#macro]

[#macro userActionsTable deactivated]
<table class="hover">
  <thead>
  <tr>
    <th><a href="#">[@message.print key="userAction.name"/]</a></th>
    <th class="hide-on-mobile"><a href="#">[@message.print key="userAction.id"/]</a></th>
    <th class="hide-on-mobile text-center"><a href="#">[@message.print key="userAction.temporal"/]</a></th>
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </tr>
  </thead>
  <tbody>
    [#if userActions?? && userActions?size > 0]
      [#list userActions as userAction]
      <tr>
        <td>${userAction.name}</td>
        <td class="hide-on-mobile">${userAction.id}</td>
        <td data-sort-value="${userAction.temporal?c}" class="hide-on-mobile text-center">[@properties.displayCheck userAction.temporal/]</td>
        <td class="action">
          [#if deactivated]
            [@button.action href="/ajax/user-action/reactivate/${userAction.id}" icon="plus-circle" key="reactivate" color="green" ajaxForm=true/]
            [@button.action href="../delete/${userAction.id}" icon="trash" key="delete" color="red"/]
          [#else]
            [@button.action href="edit/${userAction.id}" icon="edit"  key="edit" color="blue"/]
            [@button.action href="/ajax/user-action/view/${userAction.id}" icon="search" key="view" color="green" ajaxView=true  ajaxWideDialog=true/]
            [@button.action href="/ajax/user-action/deactivate/${userAction.id}" icon="minus-circle" key="deactivate" color="gray" ajaxForm=true/]
            [@button.action href="delete/${userAction.id}" icon="trash" key="delete" color="red"/]
          [/#if]
        </td>
      </tr>
      [/#list]
    [#else]
    <tr>
      <td colspan="5">[@message.print key="no-user-actions"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
[/#macro]