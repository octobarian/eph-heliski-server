[#-- @ftlvariable name="nodeCount" type="int" --]
[#-- @ftlvariable name="node" type="io.fusionauth.api.domain.FusionAuthNodeMapper.FusionAuthNode" --]
[#-- @ftlvariable name="logs" type="java.util.List<com.inversoft.util.Pair<java.lang.String, java.lang.String>>" --]
[#-- @ftlvariable name="nodeId" type="java.util.UUID" --]

[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@properties.table]
  [#if nodeCount > 1]
    [@properties.rowEval nameKey="nodeId" object=node propertyName="id" /]
    [@properties.rowEval nameKey="nodeURL"object=node propertyName="url" /]
    [@properties.rowEval nameKey="me" object=node propertyName="me" /]
  [/#if]
[/@properties.table]

[#if logs?has_content]
  <ul class="tabs">
    [#list logs as logEntry]
    <li><a href="#${nodeId}_${logEntry.first.replace("-", "_")}">${logEntry.first}</a></li>
    [/#list]
  </ul>

  [#list logs as logEntry]
    <div id="${nodeId}_${logEntry.first.replace("-", "_")}" class="hidden">
      <fieldset>
       <pre class="code not-pushed log-content">${logEntry.second}</pre>
      </fieldset>
    </div>
  [/#list]
[#else]
  <p><em>[@message.print key="{description}no-logs" /]</em></p>
[/#if]