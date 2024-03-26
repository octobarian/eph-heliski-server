[#ftl/]
[#-- @ftlvariable name="connectors" type="java.util.List<io.fusionauth.domain.connector.BaseConnectorConfiguration>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/message.ftl" as message/]
[#import "_macros.ftl" as connectorMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
            .initialize();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "settings", "/admin/connector/": "connectors"}]
      <div id="messenger-actions" class="split-button" data-local-storage-key="connectors-split-button">
        <a class="gray button item" href="#">
          <i class="fa fa-spinner fa-pulse"></i>
          <span> [@message.print key="loading"/]</span>
         </a>
        <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
        </button>
        <div class="menu">
          [#list ["LDAP", "Generic"] as connector]
            <a id="add-${connector?lower_case}" class="item" href="/admin/connector/add/${connector}">
              <i class="green-text fa fa-plus"></i>
              <span> [@message.print key="add-${connector?lower_case}"/] </span>
            </a>
          [/#list]
        </div>
      </div>
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full displayTotal=(connectors![])?size]
        [@connectorMacros.connectorsTable/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]