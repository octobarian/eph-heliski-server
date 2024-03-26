[#ftl/]
[#-- @ftlvariable name="instance" type="io.fusionauth.api.domain.Instance" --]
[#-- @ftlvariable name="productInformation" type="io.fusionauth.api.domain.ProductInformation" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[#list productInformation.nodes as node]
  [#if node.me]
    [#assign selectedTabId = "node${node?index}"/]
  [/#if]
[/#list]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      var tabs = new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
          .withErrorClassHandling('error')
          .withLocalStorageKey('system.about.tabs')
          .initialize();

      tabs.selectTab('${selectedTabId}')
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader breadcrumbs={"": "system", "/admin/system/about": "about"}/]
    [@layout.main]
      [@panel.full titleKey="product-information"]
        <fieldset>
          [@properties.table]
            [@properties.rowNestedValue nameKey="version"]
              [#if version.isPreRelease()]
              Early Access
              [/#if]
              ${properties.display(productInformation, "currentProductVersion")}
              [#if version.isPreRelease()]
                &nbsp; <i class="fa fa-exclamation-triangle orange-text" data-tooltip="Warning, this version cannot be upgraded"></i>
              [/#if]
            [/@properties.rowNestedValue]
            [@properties.rowNestedValue nameKey="latest-version"]
              [#if productInformation.productUpdateAvailable]
                ${productInformation.latestProductVersion}
              [#else]
                <i class="fa fa-check green-text"></i>
              [/#if]
            [/@properties.rowNestedValue]
            [@properties.row nameKey="nodes" value=productInformation.nodes?size /]
            [@properties.row nameKey="instance-id" value=properties.display(instance, "id")/]
            [@properties.row nameKey="runtimeMode" value=message.inline("RuntimeMode." + productInformation.runtimeMode)/]
          [/@properties.table]
        </fieldset>

        <ul class="tabs">
          [#list productInformation.nodes as node]
          <li><a href="#node${node?index}">[@message.print key="node"/]&nbsp;${node?index + 1}</a></li>
          [/#list]
        </ul>
        [#list productInformation.nodes as node]
          <div id="node${node?index}" class="hidden">
          <fieldset>
            [@properties.table]
              [@properties.rowEval nameKey="nodeId" object=node propertyName="id" /]
              [#assign ipAddressCount = (node.ipAddresses!{})?keys?size /]
              [@properties.rowNestedValue nameKey=(ipAddressCount == 1)?then("ip-address", "ip-addresses")]
                [#list (node.ipAddresses!{})?keys as interface]
                  [#list node.ipAddresses[interface] as address]${address.getHostAddress()!''}[#if !address?is_last]${message.inline("listSeparator")}[/#if][/#list][#if !interface?is_last]${message.inline("listSeparator")}[/#if]
                [#else]
                &ndash;
                [/#list]
              [/@properties.rowNestedValue]
              [@properties.rowNestedValue nameKey="platform"]
                  [#if node.platform.toDisplayString()??]
                    ${node.platform.toDisplayString()}
                    <i class="pl-1 fa fa-info-circle blue-text" data-additional-classes="wide" data-tooltip="${message.inline("{tooltip}platform")}"></i>[#t/]
                  [#else]
                    ${"\x2013"}
                  [/#if]
              [/@properties.rowNestedValue]
              [@properties.rowEval nameKey="startup" object=node propertyName="insertInstant" /]
              [@properties.rowEval nameKey="uptime" object=node propertyName="uptimeInDays" /]
             [#if productInformation.nodes?size > 1]
               [@properties.rowEval nameKey="me" object=node propertyName="me" /]
             [/#if]
            [/@properties.table]
          </fieldset>
          </div>
        [/#list]
      [/@panel.full]

      [@panel.full titleKey="system-information"]
        <fieldset>
          [@properties.table]
            [@properties.rowNestedValue nameKey="dbEngine"]
               [@message.print key=productInformation.dbEngine/] ${properties.display(productInformation, "dbEngineVersion", "")}
            [/@properties.rowNestedValue]
            [@properties.rowNestedValue nameKey="searchEngine"]
              [#compress]
              [#if productInformation.searchEngineDistribution??]
                [@message.print key=productInformation.searchEngineDistribution/]
              [#else]
                [@message.print key=productInformation.searchEngine/]
              [/#if]
              ${properties.display(productInformation, "searchEngineVersion", "")}
              [/#compress]
            [/@properties.rowNestedValue]
          [/@properties.table]
        </fieldset>
      [/@panel.full]

    [/@layout.main]
  [/@layout.body]
[/@layout.html]