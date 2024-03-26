[#ftl/]

[#-- @ftlvariable name="connectors" type="java.util.List<io.fusionauth.domain.connector.BaseConnectorConfiguration>" --]
[#-- @ftlvariable name="editPasswordOption" type="io.fusionauth.app.action.admin.connector.BaseFormAction.EditPasswordOption" --]
[#-- @ftlvariable name="ldapSecurityMethods" type="io.fusionauth.domain.connector.LDAPConnectorConfiguration.LDAPSecurityMethod[]" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.connector.ConnectorType" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro connectorsTable]
  <table class="hover">
    <thead>
      <th><a href="#">[@message.print "name"/]</a></th>
      <th class="hide-on-mobile"><a href="#">[@message.print "id"/]</a></th>
      <th><a href="#">[@message.print "type"/]</a></th>
      <th class="hide-on-mobile"><a href="#">[@message.print key="debug"/]</a></th>
      <th data-sortable="false" class="action">[@message.print "action"/]</th>
    </thead>
    <tbody>
      [#list connectors as connector]
        <tr>
          <td>${properties.display(connector, "name")}</td>
          <td class="hide-on-mobile">${properties.display(connector, "id")}</td>
          <td>[@message.print "${connector.getType()}"/]</td>
          <td class="hide-on-mobile">${properties.display(connector, "debug")}</td>
          <td class="action">
            [@button.action href="/admin/connector/edit/${connector.type}/${connector.id}" icon="edit" key="edit" color="blue"/]
            [@button.action href="/ajax/connector/view/${connector.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
            [#if connector.id != fusionAuth.statics['io.fusionauth.domain.connector.BaseConnectorConfiguration'].FUSIONAUTH_CONNECTOR_ID]
              [@button.action href="/admin/connector/delete/${connector.id}" icon="trash" key="delete" color="red"/]
            [/#if]
          </td>
        </tr>
      [#else]
        <tr>
          <td colspan="3">[@message.print "no-connectors"/]</td>
        </tr>
      [/#list]
    </tbody>
  </table>
[/#macro]

[#macro connectorFields action]
  [@control.hidden name="type"/]

  [#switch type!""]
    [#case "LDAP"]
      [@ldapFields action=action/]
      [#break]
    [#case "Generic"]
      [@genericFields action=action/]
      [#break]
    [#default]
      [@control.hidden name="connectorId"/]
      [@control.text name="connectorId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
      [@control.text name="connector.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
  [/#switch]
[/#macro]

[#macro genericFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="connectorId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.hidden name="connectorId"/]
      [@control.text name="connectorId" id="connector_id_disabled" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="connector.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    [@control.text name="connector.authenticationURL" labelKey="generic.authenticationURL" autocapitalize="none" autocomplete="on" autocorrect="off" placeholder=function.message('{placeholder}generic.authenticationURL') required=true tooltip=function.message('{tooltip}generic.authenticationURL')/]
    [@control.text name="connector.connectTimeout" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}connector.connectTimeout')/]
    [@control.text name="connector.readTimeout" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}connector.readTimeout')/]
    [@control.checkbox name="connector.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}connector.debug')/]
  </fieldset>

  <ul class="tabs">
    <li><a href="#security">[@message.print key="security"/]</a></li>
    <li><a href="#headers">[@message.print key="headers"/]</a></li>
  </ul>

  <div id="security">
    <fieldset>
      [@control.text name="connector.httpAuthenticationUsername" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}connector.httpAuthenticationUsername')/]
      [@control.text name="connector.httpAuthenticationPassword" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}connector.httpAuthenticationPassword')/]
      [@control.select name="connector.sslCertificateKeyId" items=sslKeys![] required=false valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-client-certificate-key"  tooltip=function.message('{tooltip}connector.sslCertificateKeyId')/]
    </fieldset>
  </div>

  [@httpHeaders/]
[/#macro]

[#macro ldapFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="connectorId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.hidden name="connectorId"/]
      [@control.text name="connectorId" id="connector_id_disabled" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="connector.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    [@control.text name="connector.authenticationURL" labelKey="ldap.authenticationURL" autocapitalize="none" autocomplete="on" autocorrect="off" autofocus="autofocus" required=true placeholder=function.message('{placeholder}ldap.authenticationURL') tooltip=function.message('{tooltip}ldap.authenticationURL')/]
    [@control.select name="connector.securityMethod" items=ldapSecurityMethods wideTooltip=function.message('{tooltip}connector.securityMethod')/]
    [@control.text name="connector.connectTimeout" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}connector.connectTimeout')/]
    [@control.text name="connector.readTimeout" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}connector.readTimeout')/]
    [@control.select name="connector.lambdaConfiguration.reconcileId" items=ldapLambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="selection-required"  required=true tooltip=function.message('{tooltip}connector.lambdaConfiguration.reconcileId')/]
    [@control.checkbox name="connector.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}connector.debug')/]
  </fieldset>
  <ul class="tabs">
    <li><a href="#directory-configuration">[@message.print key="directory-configuration"/]</a></li>
  </ul>
  <div id="directory-configuration">
    <fieldset>
      [@control.text name="connector.baseStructure" autocapitalize="none" autocomplete="off" autocorrect="off" required=true placeholder=function.message('{placeholder}connector.baseStructure') tooltip=function.message('{tooltip}connector.baseStructure')/]
      [@control.text name="connector.systemAccountDN" autocapitalize="none" autocomplete="on" autocorrect="off" required=true placeholder=function.message('{placeholder}connector.systemAccountDN') tooltip=function.message('{tooltip}connector.systemAccountDN')/]
      [#if action == "edit"]
        [@control.checkbox name="editPasswordOption" value="update" uncheckedValue="useExisting" data_slide_open="password-fields" tooltip=message.inline("{tooltip}editPasswordOption")/]
        <div id="password-fields" class="slide-open [#if editPasswordOption == "update"]open[/#if]">
          [@control.password name="connector.systemAccountPassword" value="" autocomplete="new-password" required=true tooltip=function.message('{tooltip}connector.systemAccountPassword')/]
        </div>
      [#else]
        [#-- Add - just show the password field --]
        [@control.password name="connector.systemAccountPassword" value="" autocomplete="new-password" required=true tooltip=function.message('{tooltip}connector.systemAccountPassword')/]
      [/#if]
      [@control.text name="connector.loginIdAttribute" defaultValue="mail" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}connector.loginIdAttribute')/]
      [@control.text name="connector.identifyingAttribute" defaultValue="uid" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}connector.identifyingAttribute')/]
      [@control.select id="requestedAttributes" items=connector.requestedAttributes multiple=true name="connector.requestedAttributes" class="select no-wrap" labelKey="connector.requestedAttributes" required=true placeholder=function.message('{placeholder}connector.requestedAttributes') tooltip=function.message('{tooltip}connector.requestedAttributes')/]
    </fieldset>
  </div>
[/#macro]

[#macro securityConfiguration]
  <div id="security">
    <fieldset>
      [#nested /]
      [@control.select name="connector.sslCertificateKeyId" items=sslKeys![] required=false valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-client-certificate-key"  tooltip=function.message('{tooltip}connector.sslCertificateKeyId')/]
    </fieldset>
  </div>
[/#macro]

[#macro httpHeaders]
  <div id="headers">
    <fieldset>
      <table id="header-table" class="u-small-bottom-margin" data-template="header-row-template" data-add-button="header-add-button">
        <thead>
        <tr>
          <th>[@message.print key="name"/]</th>
          <th>[@message.print key="value"/]</th>
          <th data-sortable="false" class="action">[@message.print key="action"/]</th>
        </tr>
        </thead>
        <tbody>
        <tr class="empty-row">
          <td colspan="3">[@message.print key="no-headers"/]</td>
        </tr>
          [#list connector.headers?keys as name]
          <tr>
            <td><input type="text" class="full" placeholder="${function.message("name")}" name="headerNames[${name_index}]" value="${name}"/></td>
            <td><input type="text" class="full" placeholder="${function.message("value")}" name="headerValues[${name_index}]" value="${connector.headers[name]}"/></td>
            <td class="action"><a href="#" class="delete-button red button small-square"><i class="fa fa-trash" data-tooltip="${function.message('delete')}"></i></a>
            </td>
          </tr>
          [/#list]
        </tbody>
      </table>
      <script type="x-handlebars" id="header-row-template">
        <tr>
          <td><input type="text" class="full" placeholder="${function.message("name")}" name="headerNames[{{index}}]"/></td>
          <td><input type="text" class="full" placeholder="${function.message("value")}" name="headerValues[{{index}}]"/></td>
          <td class="action"><a href="#" class="delete-button red button small-square"><i class="fa fa-trash" data-tooltip="${function.message('delete')}"></i></a>
        </tr>
      </script>
      [@button.iconLinkWithText href="#" color="blue" icon="plus" textKey="add-header" id="header-add-button"/]
    </fieldset>
  </div>
[/#macro]