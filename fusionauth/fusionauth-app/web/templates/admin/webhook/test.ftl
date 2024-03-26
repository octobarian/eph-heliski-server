[#ftl/]
[#-- @ftlvariable name="id" type="java.util.UUID" --]
[#-- @ftlvariable name="codeUserActionExample" type="java.lang.String" --]
[#-- @ftlvariable name="eventTypes" type="java.util.List<io.fusionauth.domain.event.EventType>" --]
[#-- @ftlvariable name="temporalUserActionExample" type="java.lang.String" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as webhookMacros/]

[#function selected value]
  [#if eventType?? && eventType == value]
    [#return "selected=\"selected\""/]
  [/#if]

  [#return ""/]
[/#function]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.WebhookTest()
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@control.form id="webhook-test-form" action="${request.contextPath}/admin/webhook/test/${id}" method="POST" class="labels-left full"]
      [@layout.pageHeader includeSave=true includeCancel=true cancelURI="/admin/webhook/" saveColor="purple" saveKey="send" saveIcon="send-o" breadcrumbs={"": "settings", "/admin/webhook/": "webhooks", "/admin/webhook/test/${id}": "test"}]
        [@button.iconLink id="webhook-test-reset" href="#" color="blue" icon="undo" tooltipKey="reset"/]
      [/@layout.pageHeader]
      [@layout.main]
        [@panel.full]
        <p class="no-top-margin"><em>[@message.print key="intro"/]</em></p>
        <fieldset>
          [@control.text name="webhook.url" disabled=true/]
        </fieldset>
        <div class="form-row">
          <label for="event-type-select">[@message.print key="event-type"/]</label>
          <label class="select">
            <select id="event-type-select">
              [#list eventTypes as type]
                [#if type == "UserAction"]
                  <option value="${type}_Temporal" ${selected("${type}_Temporal")}>[@message.print key="${type}_Temporal" values=[type.eventName()] /]</option>
                  <option value="${type}_Code" ${selected("${type}_Code")}>[@message.print key="${type}_Code" values=[type.eventName()] /]</option>
                [#else]
                  <option value="${type}" ${selected("${type}")}>[@message.print key="${type}" values=[type.eventName()]/]</option>
                [/#if]
              [/#list]
            </select>
          </label>
        </div>
        <div id="form-container" class="form-row">
          [#list eventTypes as type]
            [#if type == "UserAction"]
              <div id="${type}_Temporal" class="hidden">
                [@control.textarea name="${type}_TemporalExample" labelKey="event"/]
                [@control.hidden name="type" value="${type}"/]
                [@control.hidden name="eventType" value="${type}_Temporal"/]
              </div>
              <div id="${type}_Code" class="hidden">
                [@control.textarea name="${type}_CodeExample" labelKey="event"/]
                [@control.hidden name="type" value="${type}"/]
                [@control.hidden name="eventType" value="${type}_Code"/]
              </div>
            [#else]
              <div id="${type}" class="hidden">
                [@control.textarea name="${type}Example" labelKey="event"/]
                [@control.hidden name="type" value="${type}"/]
                [@control.hidden name="eventType" value="${type}"/]
              </div>
            [/#if]
          [/#list]
        </div>
        [/@panel.full]
      [/@layout.main]
    [/@control.form]
  [/@layout.body]
[/@layout.html]
