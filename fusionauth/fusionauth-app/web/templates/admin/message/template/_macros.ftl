[#ftl/]
[#-- @ftlvariable name="messageTemplate" type="io.fusionauth.domain.message.MessageTemplate" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.message.MessageType" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as props/]

[#macro template action]
  <fieldset>
    <p class="no-top-margin">
      <em>[@message.print key="freemarker-note"/]</em>
    </p>
    [#if action == "add"]
      [@control.text name="messageTemplateId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="messageTemplateId" disabled=true tooltip=message.inline('{tooltip}readOnly')/]
      [@control.hidden name="messageTemplateId"/]
    [/#if]
    [@control.text name="messageTemplate.name" autocapitalize="on" autocomplete="off" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly') /]
    [@control.hidden id="form_type_hidden" name="type"/]
    [#if action == "add"]
      [@control.select name="type" disabled=true items=types tooltip=function.message('{tooltip}type')/]
    [#else]
       [@control.select name="type" disabled=true items=types tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
  </fieldset>
  [#if type == "SMS"]
    [@sms action=action/]
  [/#if]
[/#macro]

[#macro sms action]
    <fieldset class="mt-4">
      <ul class="tabs">
        <li><a href="#text">[@message.print key="template"/]</a></li>
        <li><a href="#localization">[@message.print key="localization"/]</a></li>
      </ul>
      <div id="text" class="hidden">
        [@control.textarea name="messageTemplate.defaultTemplate" class="tall code" autocapitalize="on" autocomplete="on" autocorrect="on" required=true tooltip=function.message('{tooltip}messageTemplate.defaultTemplate')/]
        <div class="text-right">
          [@button.iconLinkWithText href="/ajax/message/template/preview" color="blue" icon="search" textKey="preview" tooltipKey="message-preview"/]
        </div>
      </div>
      <div id="localization" class="hidden">
        <table id="localization-table" data-template="localization-template">
          <thead>
          <tr>
            <th>[@message.print key="locale"/]</th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            <tr class="empty-row">
              <td colspan="3">[@message.print key="no-localized-versions"/]</td>
            </tr>
            [#list messageTemplate.localizations![] as locale]
            <tr data-locale="${locale}" data-template="${((messageTemplate.localizedTemplates(locale))!'')}">
              <td>
                ${props.display(locale, "displayName")}
                <input id="messageTemplate.localizedTemplates${locale}" type="hidden" name="messageTemplate.localizedTemplates['${locale}']" value="${((messageTemplate.localizedTemplates(locale))!'')}"/>
              </td>
              <td class="action">
                [@button.action href="/ajax/message/template/validate-localization" color="blue" icon="edit" key="edit"/]
                [@button.action href="/ajax/message/template/preview" color="green" icon="search" key="view"/]
                [@button.action href="/ajax/message/template/delete-localization" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
              </td>
            </tr>
            [/#list]
          </tbody>
        </table>
        [@button.iconLinkWithText href="/ajax/message/template/validate-localization" textKey="add-localization" id="add-localization" icon="plus"/]
        <script type="x-handlebars" id="localization-template">
          <tr>
            <td>
              {{localeDisplay}}
              <input id="messageTemplate.localizedTemplates{{locale}}" type="hidden" name="messageTemplate.localizedTemplates['{{locale}}']" value="{{template}}"/>
            </td>
            <td class="action">
              [@button.action href="/ajax/message/template/validate-localization" color="blue" icon="edit" key="edit"/]
              [@button.action href="/ajax/message/template/preview" color="green" icon="search" key="view"/]
              [@button.action href="/ajax/message/template/delete-localization" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
            </td>
          </tr>
        </script>
      </div>
    </fieldset>
[/#macro]