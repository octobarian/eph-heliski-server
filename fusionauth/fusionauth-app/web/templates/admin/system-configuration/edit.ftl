[#ftl/]
[#-- @ftlvariable name="timezones" type="java.util.SortedSet<java.lang.String>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.SystemConfigurationForm();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit" method="POST" id="applications-form" includeSave=true cancelURI="/admin/" breadcrumbs={"": "settings", "/admin/system-configuration/edit": "system"}]
      <ul id="tabs" class="tabs">
        <li><a href="#cors-settings">[@message.print key="cors"/]</a></li>
        <li><a href="#report-settings">[@message.print key="reports"/]</a></li>
        <li><a href="#ui-settings">[@message.print key="ui"/]</a></li>
        <li><a href="#advanced">[@message.print key="advanced"/]</a></li>
      </ul>

      <div id="report-settings" class="hidden">
        <fieldset>
          <legend>[@message.print key="report-settings"/]</legend>
          [@control.select items=timezones name="systemConfiguration.reportTimezone" selected="${systemConfiguration.reportTimezone!'America/Denver'}" tooltip=function.message('{tooltip}systemConfiguration.reportTimezone')/]
        </fieldset>
      </div>

      <div id="cors-settings" class="hidden">
        <fieldset>
          <legend>[@message.print key="cors-filter"/]</legend>
          <p><em>[@message.print key="{description}cors-filter"/]</em></p>
          [@control.checkbox name="systemConfiguration.corsConfiguration.enabled" data_slide_open="cors-configuration" value="true" uncheckedValue="false"/]
        </fieldset>
        <div id="cors-configuration" class="slide-open [#if (systemConfiguration.corsConfiguration.enabled)!false]open[/#if]">
          [@control.checkbox name="systemConfiguration.corsConfiguration.allowCredentials" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.allowCredentials')/]
          [@control.select id="cors-allowed-headers" items=systemConfiguration.corsConfiguration.allowedHeaders multiple=true name="corsConfiguration.allowedHeaders" class="select no-wrap" required=false data_cors_allowed_headers_add_label=message.inline("{addlabel}systemConfiguration.corsConfiguration.allowedHeaders") tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.allowedHeaders')/]
          [@control.checkbox_list items=allowedMethods name="corsConfiguration.allowedMethods" includeFormRow=false tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.allowedMethods')/]
          [@control.select id="cors-allowed-origins" items=systemConfiguration.corsConfiguration.allowedOrigins multiple=true name="corsConfiguration.allowedOrigins" class="select no-wrap" required=false data_cors_allowed_origins_add_label=message.inline("{addlabel}systemConfiguration.corsConfiguration.allowedOrigins") tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.allowedOrigins')/]
          [@control.select id="cors-exposed-headers" items=systemConfiguration.corsConfiguration.exposedHeaders multiple=true name="corsConfiguration.exposedHeaders" class="select no-wrap" required=false data_cors_exposed_headers_add_label=message.inline("{addlabel}systemConfiguration.corsConfiguration.exposedHeaders") tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.exposedHeaders')/]
          [@control.text name="systemConfiguration.corsConfiguration.preflightMaxAgeInSeconds" title="${helpers.approximateFromSeconds(systemConfiguration.corsConfiguration.preflightMaxAgeInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=false tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.preflightMaxAgeInSeconds')/]
          [@control.checkbox name="systemConfiguration.corsConfiguration.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}systemConfiguration.corsConfiguration.debug')/]
        </div>
      </div>

      <div id="ui-settings" class="hidden">
        <fieldset>
          <legend>[@message.print key="ui-settings"/]</legend>
          <p><em>[@message.print key="ui-settings-description"/]</em></p>
          [@control.text name="systemConfiguration.uiConfiguration.logoURL"/]
          [@control.text class="jscolor {required:false}" name="systemConfiguration.uiConfiguration.headerColor" tooltip=function.message('{tooltip}systemConfiguration.uiConfiguration.headerColor')/]
          [@control.text class="jscolor {required:false}" name="systemConfiguration.uiConfiguration.menuFontColor" tooltip=function.message('{tooltip}systemConfiguration.uiConfiguration.menuFontColor')/]
        </fieldset>
      </div>

      <div id="advanced" class="hidden">
        <fieldset>
          <legend>[@message.print key="audit-log-settings"/]</legend>
            [@control.checkbox name="systemConfiguration.auditLogConfiguration.delete.enabled" value="true" uncheckedValue="false" data_slide_open="audit-log-delete-settings" tooltip=function.message('{tooltip}systemConfiguration.auditLogConfiguration.delete.enabled')/]
          <div id="audit-log-delete-settings" class="slide-open [#if (systemConfiguration.auditLogConfiguration.delete.enabled)!false]open[/#if]">
            [@control.text name="systemConfiguration.auditLogConfiguration.delete.numberOfDaysToRetain" rightAddonText="${function.message('DAYS')}" required=true tooltip=function.message('{tooltip}systemConfiguration.auditLogConfiguration.delete.numberOfDaysToRetain')/]
          </div>
        </fieldset>

        <fieldset>
          <legend>[@message.print key="login-record-settings"/]</legend>
            [@control.checkbox name="systemConfiguration.loginRecordConfiguration.delete.enabled" value="true" uncheckedValue="false" data_slide_open="login-record-delete-settings" tooltip=function.message('{tooltip}systemConfiguration.loginRecordConfiguration.delete.enabled')/]
          <div id="login-record-delete-settings" class="slide-open [#if (systemConfiguration.loginRecordConfiguration.delete.enabled)!false]open[/#if]">
            [@control.text name="systemConfiguration.loginRecordConfiguration.delete.numberOfDaysToRetain" rightAddonText="${function.message('DAYS')}" required=true tooltip=function.message('{tooltip}systemConfiguration.loginRecordConfiguration.delete.numberOfDaysToRetain')/]
          </div>
        </fieldset>

        <fieldset>
          <legend>[@message.print key="event-log-settings"/]</legend>
          [@control.text name="systemConfiguration.eventLogConfiguration.numberToRetain" rightAddonText="${function.message('records')}" required=true tooltip=function.message('{tooltip}systemConfiguration.eventLogConfiguration.numberToRetain')/]
        </fieldset>
      </div>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
