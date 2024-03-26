[#ftl/]

[#-- @ftlvariable name="messengers" type="java.util.List<io.fusionauth.domain.messenger.BaseMessengerConfiguration>" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.messenger.MessengerType" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro messengersTable]
  <table class="hover">
    <thead>
      <th><a href="#">[@message.print "name"/]</a></th>
      <th class="hide-on-mobile"><a href="#">[@message.print "id"/]</a></th>
      <th><a href="#">[@message.print "type"/]</a></th>
      <th><a href="#">[@message.print "transport"/]</a></th>
      <th class="hide-on-mobile"><a href="#">[@message.print key="debug"/]</a></th>
      <th data-sortable="false" class="action">[@message.print "action"/]</th>
    </thead>
    <tbody>
      [#list messengers![] as messenger]
        <tr>
          <td>${properties.display(messenger, "name")}</td>
          <td class="hide-on-mobile">${properties.display(messenger, "id")}</td>
          <td>[@message.print "${messenger.getType()}"/]</td>
          <td>${properties.display(messenger, "transport")}</td>
          <td class="hide-on-mobile">${properties.display(messenger, "debug")}</td>
          <td class="action">
            [#-- TODO : Should we add a send test button like we do for email templates? We would just need to select an available messenger that can send this type of template. --]
            [@button.action href="edit/${messenger.type}/${messenger.id}" icon="edit" key="edit" color="blue"/]
            [@button.action href="add/${messenger.type}?messengerId=${messenger.id}" icon="copy" key="duplicate" color="purple"/]
            [@button.action href="/ajax/messenger/view/${messenger.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
            [@button.action href="delete/${messenger.id}" icon="trash" key="delete" color="red"/]
          </td>
        </tr>
      [#else]
        <tr>
          <td colspan="3">[@message.print "no-messengers"/]</td>
        </tr>
      [/#list]
    </tbody>
  </table>
[/#macro]

[#macro messengerFields action]
  [@control.hidden name="type"/]

  [#switch type!""]
    [#case "Twilio"]
      [@twilioFields action=action/]
      [#break]
    [#case "Generic"]
      [@genericFields action=action/]
      [#break]
    [#case "Kafka"]
      [@kafkaFields action=action/]
      [#break]
    [#default]
      [@control.hidden name="messengerId"/]
      [@control.text name="messengerId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
      [@control.text name="messenger.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
  [/#switch]
[/#macro]

[#macro twilioFields action]
  <div id="twilio-settings">
    <fieldset>
      [#if action=="add"]
        [@control.text name="messengerId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
      [#else]
        [@control.hidden name="messengerId"/]
        [@control.text name="messengerId" id="messenger_id_disabled" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="messenger.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    </fieldset>
    <fieldset>
      [@control.text name="messenger.url" defaultValue="https://api.twilio.com" autocapitalize="none" autocomplete="on" autocorrect="off" required=true tooltip=function.message('{tooltip}messenger.url') /]
      [@control.text name="messenger.accountSID" autocapitalize="none" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=function.message('{tooltip}messenger.accountSID')/]
      [@control.text name="messenger.authToken" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=function.message('{tooltip}messenger.authToken')/]
      [@control.text name="messenger.fromPhoneNumber" autocapitalize="none" autocomplete="on" autocorrect="off" tooltip=function.message('{tooltip}messenger.fromPhoneNumber')/]
      [@control.text name="messenger.messagingServiceSid" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" tooltip=function.message('{tooltip}messenger.messagingServiceSid')/]
      [@control.checkbox name="messenger.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}messenger.debug')/]
    </fieldset>
  </div>
  <fieldset>
    <legend>[@message.print key="verify-configuration"/]</legend>
    <p>[@message.print key="verify-configuration-description-twilio"/]</p>
    <div class="form-row">
      <label for="test-phone-number">[@message.print key="test-phone-number"/]<span class="required">*</span></label>
      <div class="input-addon-group">
        <input id="test-phone-number" type="text" autocomplete="off" autocorrect="off" autocapitalize="none" value="${ftlCurrentUser.mobilePhone!''}" />
        <a id="send-test-message" href="#" class="button blue"><i class="fa fa-arrow-circle-right"></i> <span class="text">[@message.print key="send-test-message"/]</span></a>
      </div>
    </div>
  </fieldset>

  <fieldset class="padded">
    <div id="twilio-ok" class="hidden">
      [@message.alert message=message.inline('test-success') type="info" icon="info-circle" includeDismissButton=false/]
    </div>
    <div id="twilio-error" class="hidden">
      [@message.alert message=message.inline('test-failure') type="error" icon="exclamation-circle" includeDismissButton=false/]
    </div>
    <textarea id="twilio-error-response" class="hidden"></textarea>
  </fieldset>
[/#macro]

[#macro genericFields action]
  <div id="generic-settings">
    <fieldset>
      [#if action=="add"]
        [@control.text name="messengerId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
      [#else]
        [@control.hidden name="messengerId"/]
        [@control.text name="messengerId" id="messenger_id_disabled" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
      [/#if]

      [@control.text name="messenger.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    </fieldset>
    <fieldset>
      [@control.text name="messenger.url" autocapitalize="none" autocomplete="on" autocorrect="off" required=true tooltip=function.message('{tooltip}messenger.url')/]
      [@control.text name="messenger.connectTimeout" defaultValue="1000" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}messenger.connectTimeout')/]
      [@control.text name="messenger.readTimeout" defaultValue="2000" rightAddonText="${function.message('MILLISECONDS')}" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}messenger.readTimeout')/]
      [@control.checkbox name="messenger.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}messenger.debug')/]
   </fieldset>
    <fieldset class="mt-4">
      <ul class="tabs">
        <li><a href="#security">[@message.print key="security"/]</a></li>
        <li><a href="#headers">[@message.print key="headers"/]</a></li>
      </ul>
      <div id="security">
        <fieldset>
          [@control.text name="messenger.httpAuthenticationUsername" autocapitalize="none" autocomplete="off" autocorrect="off"/]
          [@control.text name="messenger.httpAuthenticationPassword" autocapitalize="none" autocomplete="off" autocorrect="off"/]
          [@control.textarea name="messenger.sslCertificate" autocapitalize="none" autocomplete="off" autocorrect="off"/]
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
              [#list messenger.headers?keys as name]
              <tr>
                [#-- TODO : MFA : Brett : Why aren't we using normal controls here? --]
                <td><input type="text" class="full" placeholder="${function.message("name")}" name="headerNames[${name_index}]" value="${name}"/></td>
                <td><input type="text" class="full" placeholder="${function.message("value")}" name="headerValues[${name_index}]" value="${messenger.headers[name]}"/></td>
                <td class="action"><a href="#" class="delete-button red button small-square"><i class="fa fa-trash" data-tooltip="${function.message('delete')}"></i></a></td>
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
  </div>

  <fieldset>
      <legend>[@message.print key="verify-configuration"/]</legend>
      <p>[@message.print key="verify-configuration-description-generic"/]</p>
      <a id="send-test-generic" href="#" class="button blue"><i class="fa fa-arrow-circle-right"></i> <span class="text">[@message.print key="send-test-generic"/]</span></a>
  </fieldset>

  <fieldset class="padded">
    <div id="generic-ok" class="hidden">
      [@message.alert message=message.inline('messenger.generic.test-success') type="info" icon="info-circle" includeDismissButton=false/]
    </div>
    <div id="generic-error" class="hidden">
      [@message.alert message=message.inline('messenger.generic.test-failure') type="error" icon="exclamation-circle" includeDismissButton=false/]
    </div>
    <textarea id="generic-error-response" class="hidden"></textarea>
  </fieldset>
[/#macro]

[#macro kafkaFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="messengerId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.hidden name="messengerId"/]
      [@control.text name="messengerId" id="messenger_id_disabled" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="messenger.name" autocapitalize="none" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
  </fieldset>
  <fieldset>
    [@control.text name="messenger.defaultTopic" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}messenger.kafka.defaultTopic')/]
    [@control.textarea name="producerConfiguration"/]
    [@control.checkbox name="messenger.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}messenger.debug')/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="messenger.kafka.verify-configuration"/]</legend>
    <p>[@message.print key="messenger.kafka.verify-configuration-description"/]</p>

    <div class="form-row">
      [@button.iconLinkWithText href="#" id="send-test-message" color="blue" icon="exchange" textKey="send-test-message" class="push-left"/]
    </div>
  </fieldset>

  <fieldset class="padded">
    <div id="kafka-ok" class="hidden">
      [@message.alert message=message.inline('messenger.kafka.test-success') type="info" icon="info-circle" includeDismissButton=false/]
    </div>
    <div id="kafka-error" class="hidden">
      [@message.alert message=message.inline('messenger.kafka.test-failure') type="error" icon="exclamation-circle" includeDismissButton=false/]
    </div>
    [#--noinspection HtmlFormInputWithoutLabel--]
    <textarea id="kafka-error-response" class="hidden"></textarea>
  </fieldset>
[/#macro]
