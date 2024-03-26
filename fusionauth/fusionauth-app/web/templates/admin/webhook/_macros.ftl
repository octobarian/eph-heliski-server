[#ftl/]
[#-- @ftlvariable name="eventTypes" type="java.util.List<io.fusionauth.domain.event.EventType>" --]
[#-- @ftlvariable name="signingKeys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="webhook" type="io.fusionauth.domain.Webhook" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="webhookId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="webhookId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="webhook.url" autocapitalize="none" autocomplete="on" autocorrect="off" autofocus="autofocus" placeholder="e.g. http://www.example.com/webhook" required=true/]
    [@control.text name="webhook.connectTimeout" defaultValue="1000" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}webhook.connectTimeout')/]
    [@control.text name="webhook.readTimeout" defaultValue="2000" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}webhook.readTimeout')/]
    [@control.textarea name="webhook.description" autocapitalize="on" autocomplete="on" autocorrect="on" tooltip=function.message('{tooltip}displayOnly') class="textarea resize vertical"/]
  </fieldset>
  <fieldset class="mt-4">
    <ul class="tabs">
      <li><a href="#events">[@message.print key="events"/]</a></li>
      <li><a href="#tenants">[@message.print key="tenants"/]</a></li>
      <li><a href="#security">[@message.print key="security"/]</a></li>
      <li><a href="#headers">[@message.print key="headers"/]</a></li>
    </ul>
    <div id="events">
      <fieldset>
        <p class="no-top-margin"><em>[@message.print key="{description}instanceEvent"/]</em></p>
        <table id="events-table" class="hover">
          <thead>
          <tr>
            <th>[@message.print key="event"/]</th>
            <th>[@message.print key="description"/]</th>
            <th>[@message.print key="system"/]</th>
            <th><a data-toggle-column href="#">[@message.print key="enabled"/]</a></th>
          </tr>
          </thead>
          <tbody>
          [#list eventTypes as type]
            <tr style="cursor: pointer;">
              <td>${type.eventName()}</td>
              <td>[@message.print key="{description}${type}"/]</td>
              <td>${properties.displayBoolean(type, "instanceEvent")}</td>
              <td>[@control.checkbox name="webhook.eventsEnabled['${type}']" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
            </tr>
          [/#list]
          </tbody>
        </table>
      </fieldset>
    </div>
    <div id="security">
      <fieldset>
        [@control.text name="webhook.httpAuthenticationUsername" autocapitalize="none" autocomplete="off" autocorrect="off"/]
        [@control.text name="webhook.httpAuthenticationPassword" autocapitalize="none" autocomplete="off" autocorrect="off"/]
        [@control.select name="webhook.sslCertificateKeyId" items=sslKeys![] required=false valueExpr="id" textExpr="name" data_slide_open="manual-certificate-entry" data_slide_open_value="" headerValue="" headerL10n="none-selected-client-certificate-key" tooltip=function.message('{tooltip}webhook.sslCertificateKeyId')/]
        <div class="form-row">
          <label></label>
          <div id="manual-certificate-entry" class="slide-open[#if !(webhook.sslCertificateKeyId?has_content)] open[/#if]">
            [@control.textarea name="webhook.sslCertificate" autocapitalize="none" autocomplete="off" autocorrect="off" labelKey="empty" includeFormRow=false/]
          </div>
        </div>
      </fieldset>
      <fieldset>
        [@control.checkbox name="webhook.signatureConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="signing-keys-list" tooltip=function.message('{tooltip}webhook.signatureConfiguration')/]
        <div id="signing-keys-list" class="slide-open [#if webhook.signatureConfiguration.enabled]open[/#if]">
         [@control.select name="webhook.signatureConfiguration.signingKeyId" items=signingKeys![] required=true valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-webhook-signing-key-required"/]
        </div>
      </fieldset>
    </div>
    <div id="tenants">
      <fieldset>
        [@control.checkbox name="webhook.global" value="true" uncheckedValue="false" data_slide_open="tenants-list" tooltip=function.message('{tooltip}webhook.global')/]
        <div id="tenants-list" class="slide-open [#if (!webhook.global)!true]open[/#if]">
          [@control.checkbox_list name="webhook.tenantIds" items=tenants valueExpr="id" textExpr="name"/]
        </div>
      </fieldset>
    </div>
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
            [#list webhook.headers?keys as name]
            <tr>
              <td><input type="text" class="full" placeholder="${function.message("name")}" name="headerNames[${name_index}]" value="${name}"/></td>
              <td><input type="text" class="full" placeholder="${function.message("value")}" name="headerValues[${name_index}]" value="${webhook.headers[name]}"/></td>
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
  </fieldset>
[/#macro]
