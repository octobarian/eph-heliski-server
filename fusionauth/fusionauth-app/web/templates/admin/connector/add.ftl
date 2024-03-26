[#ftl/]

[#-- @ftlvariable name="type" type="io.fusionauth.domain.connector.ConnectorType" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as connectorMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.ConnectorForm("${type}");
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="connector-form" pageTitleKey="add-${type}" includeSave=true includeCancel=true cancelURI="/admin/connector/" breadcrumbs={"": "settings", "/admin/connector/": "connectors", "/admin/connector/add/${type}": "add"}]
      [@connectorMacros.connectorFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]