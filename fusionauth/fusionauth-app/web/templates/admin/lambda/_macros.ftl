[#ftl/]
[#-- @ftlvariable name="engineTypes" type="io.fusionauth.domain.LambdaEngineType[]" --]
[#-- @ftlvariable name="lambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="types" type="io.fusionauth.domain.LambdaType[]" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Lambda>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="lambdaId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="lambdaId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="lambda.name" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    [#if action="add"]
      [@control.select items=types name="lambda.type" tooltip=function.message('{tooltip}lambda.type')/]
    [#else]
      [@control.hidden name="lambda.type"/]
      [@helpers.fauxInput type="text" name="lambda.type" labelKey="lambda.type" value=lambda.type?has_content?then(message.inline(lambda.type), '') tooltip=function.message('{tooltip}readOnly') disabled=true/]
    [/#if]
    [@control.select items=engineTypes name="lambda.engineType" wideTooltip=function.message('{tooltip}lambda.engineType')/]
    [@control.checkbox name="lambda.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}lambda.debug')/]
    [@control.textarea name="lambda.body" autocapitalize="on" autocomplete="on" autocorrect="on" required=true tooltip=function.message('{tooltip}lambda.body')/]
  </fieldset>
  [#list types as type]
    <div id="${type}" class="hidden">${type.example}</div>
  [/#list]
[/#macro]

[#macro lambdasTable]
  <table class="hover listing" data-sortable="false">
    <thead>
      [@helpers.tableHeader "name"/]
      [@helpers.tableHeader "id" "hide-on-mobile"/]
      <th data-sortable="false">[@message.print key="type"/]</th>
      [@helpers.tableHeader "engineType"/]
      <th data-sortable="false" class="hide-on-mobile"><a href="#">[@message.print key="debug"/]</a></th>
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
    </thead>
    <tbody>
      [#list results![] as lambda]
        <tr>
          <td>${properties.display(lambda, "name")}</td>
          <td class="hide-on-mobile">${lambda.id}</td>
          <td>[@message.print key=lambda.type.name()/]</td>
          <td class="hide-on-mobile">[@message.print key="LambdaEngineType.${lambda.engineType}" /]</td>
          <td class="hide-on-mobile">${properties.display(lambda, "debug")}</td>
          <td class="action">
            [@button.action href="edit/${lambda.id}" icon="edit" key="edit" color="blue"/]
            [@button.action href="add?lambdaId=${lambda.id}" icon="copy" key="duplicate" color="purple"/]
            [@button.action href="/ajax/lambda/view/${lambda.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
            [@button.action href="/ajax/lambda/delete/${lambda.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
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
