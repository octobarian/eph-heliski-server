[#ftl/]
[#-- @ftlvariable name="connectors" type="java.util.List<io.fusionauth.domain.connector.BaseConnectorConfiguration>" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "_macros.ftl" as connectorPolicy/]

[@dialog.form action="add" formClass="full left"]
  [@connectorPolicy.fields "add"/]
[/@dialog.form]

