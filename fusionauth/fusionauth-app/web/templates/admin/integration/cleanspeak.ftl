[#ftl/]
[#-- @ftlvariable name="integrations" type="io.fusionauth.domain.Integrations" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="cleanspeak" method="POST" id="cleanspeak-integration" includeSave=true includeCancel=true cancelURI="/admin/integration/" breadcrumbs={"/admin/integration/": "integrations", "/admin/integration/cleanspeak": "page-title"}]
      [@control.checkbox name="integrations.cleanspeak.enabled" value="true" uncheckedValue="false" data_slide_open="clean-speak-enabled-settings"/]
      <div id="clean-speak-enabled-settings" class="slide-open [#if integrations.cleanspeak.enabled]open[/#if]">
        [@control.text name="integrations.cleanspeak.url" autofocus=integrations.cleanspeak.enabled?then('autofocus', '') autocapitalize="none" autocomplete="on" autocorrect="off" required=true placeholder="http://localhost:8001" tooltip=function.message('{tooltip}integrations.cleanspeak.url')/]
        [@control.text name="integrations.cleanspeak.apiKey" autocapitalize="none" autocomplete="on" autocorrect="off" tooltip=function.message('{tooltip}integrations.cleanspeak.apiKey')/]
        [@control.checkbox name="integrations.cleanspeak.usernameModeration.enabled" value="true" uncheckedValue="false" data_slide_open="clean-speak-username-moderation-settings" tooltip=function.message('{tooltip}integrations.cleanspeak.usernameModeration.enabled')/]
        <div id="clean-speak-username-moderation-settings" class="slide-open [#if integrations.cleanspeak.usernameModeration.enabled]open[/#if]">
          [@control.select name="integrations.cleanspeak.usernameModeration.applicationId" textExpr="name" valueExpr="id" items=cleanSpeakApplications![] headerValue="" headerL10n="selection-required" tooltip=function.message('{tooltip}integrations.cleanspeak.usernameModeration.applicationId')/]
        </div>
      </div>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]