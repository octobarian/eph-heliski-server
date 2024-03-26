[#ftl/]
[#-- @ftlvariable name="integrations" type="io.fusionauth.domain.Integrations" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script src="${request.contextPath}/js/admin/integrations/KafkaConfiguration.js?version=${version}"></script>
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.KafkaConfiguration();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="kafka" method="POST" id="kafka-integration" includeSave=true includeCancel=true cancelURI="/admin/integration/" breadcrumbs={"/admin/integration/": "integrations", "/admin/integration/kafka": "page-title"}]
      [@control.checkbox name="integrations.kafka.enabled" value="true" uncheckedValue="false" data_slide_open="kafka-enabled-settings"/]
      <div id="kafka-enabled-settings" class="slide-open [#if integrations.kafka.enabled]open[/#if]">
        <fieldset>
          [@control.text name="integrations.kafka.defaultTopic" autofocus=integrations.kafka.enabled?then('autofocus', '') autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}integrations.kafka.defaultTopic')/]
          [@control.textarea name="producerConfiguration"/]
        </fieldset>

        <fieldset>
          <legend>[@message.print key="verify-configuration"/]</legend>
          <p>[@message.print key="verify-configuration-description"/]</p>

          <div class="form-row">
            [@button.iconLinkWithText href="#" id="send-test-message" color="blue" icon="exchange" textKey="send-test-message" class="push-left"/]
          </div>
        </fieldset>

        <fieldset class="padded">
          <div id="kafka-ok" class="hidden">
            [@message.alert message=message.inline('test-success') type="info" icon="info-circle" includeDismissButton=false/]
          </div>
          <div id="kafka-error" class="hidden">
            [@message.alert message=message.inline('test-failure') type="error" icon="exclamation-circle" includeDismissButton=false/]
          </div>
          [#--noinspection HtmlFormInputWithoutLabel--]
          <textarea id="kafka-error-response" class="hidden"></textarea>
        </fieldset>
      </div>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]