[#ftl/]
[#-- @ftlvariable name="nodeIds" type="java.util.List<java.util.UUID>" --]
[#-- @ftlvariable name="logs" type="java.util.Map<java.lang.String, java.lang.String>" --]
[#-- @ftlvariable name="logDirectory" type="java.lang.String" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head]
  <script>
  Prime.Document.onReady(function() {
    new FusionAuth.Admin.SystemLogs();
  });
</script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader breadcrumbs={"": "system", "/admin/system/log": "logs"}]
    [#if nodeIds?has_content]
      [@button.iconLink href="/admin/system/log/download?includeArchived=true" color="purple" icon="download" tooltipKey="download"/]
    [/#if]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full titleKey="logs"]

        [#if nodeIds?size > 1]
          <p><em>[@message.print key="{description}multiNode" values=[nodeIds?size]/]</em></p>
        [/#if]

        <p class="mt-0"><em>[@message.print key="{description}logs" /]</em></p>

        <ul id="node-tabs" class="tabs" [#if nodeIds?size == 1]style="display: none !important;"[/#if]>
          [#list nodeIds as nodeId]
            <li><a href="${request.contextPath}/ajax/system/log/?nodeId=${nodeId}">[@message.print key="node" values=[(nodeId?index + 1)]/]</a></li>
          [/#list]
        </ul>

        [#list nodeIds as nodeId]
          <div id="${request.contextPath}/ajax/system/log/?nodeId=${nodeId}" class="hidden" [#if nodeIds?size == 1]style="border-top: 0 !important; padding: 0;"[/#if]></div>
        [/#list]

      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]