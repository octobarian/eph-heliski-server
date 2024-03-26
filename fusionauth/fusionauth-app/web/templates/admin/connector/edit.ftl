[#ftl/]

[#-- @ftlvariable name="connectorId" type="java.util.UUID" --]
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
    [@layout.pageForm action="edit" method="POST" id="connector-form" pageTitleKey="edit-${type}" includeSave=true includeCancel=true cancelURI="/admin/connector/" breadcrumbs={"": "settings", "/admin/connector/": "connectors", "/admin/connector/edit/${type}/${connectorId}": "edit"}]
      [@connectorMacros.connectorFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]