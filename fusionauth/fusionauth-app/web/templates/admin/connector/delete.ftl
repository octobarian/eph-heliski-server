[#ftl/]
[#-- @ftlvariable name="connectorId" type="java.util.UUID" --]
[#-- @ftlvariable name="connector" type="io.fusionauth.domain.connector.BaseConnectorConfiguration" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/connector/" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"": "settings", "/admin/connector/": "connectors", "/admin/connector/delete/${connectorId}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=connector propertyName="name"/]
          [@properties.rowEval nameKey="type" object=connector propertyName="type"/]
          [@properties.rowEval nameKey="id" object=connector propertyName="id"/]
         [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="connectorId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
