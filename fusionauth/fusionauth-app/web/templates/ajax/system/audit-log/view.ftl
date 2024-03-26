[#ftl/]
[#-- @ftlvariable name="auditLog" type="io.fusionauth.domain.AuditLog" --]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/dialog.ftl" as dialog/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>

  [@properties.table]
    [@properties.rowEval nameKey="id" object=auditLog propertyName="id"/]
    [@properties.rowEval nameKey="insertInstant" object=auditLog propertyName="insertInstant"/]
    [@properties.rowEval nameKey="insertUser" object=auditLog propertyName="insertUser"/]
    [@properties.rowEval nameKey="reason" object=auditLog propertyName="reason"/]
    [@properties.rowEval nameKey="message" object=auditLog propertyName="message"/]
  [/@properties.table]

  [#if auditLog.oldValue?has_content || auditLog.newValue?has_content]
    <h3>[@message.print key="changed"/]</h3>
    <div class="scrollable horizontal">
      <table class="fields">
        <thead>
        <tr>
          <th>[@message.print key="oldValue"/]</th>
          <th>[@message.print key="newValue"/]</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>
            [#if auditLog.oldValue?has_content]
              <pre>${fusionAuth.stringify(auditLog.oldValue)}</pre>
            [#else]
              &ndash;
            [/#if]
          </td>
          <td>
            [#if auditLog.newValue?has_content]
              <pre>${fusionAuth.stringify(auditLog.newValue)}</pre>
            [#else]
              &ndash;
            [/#if]
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  [/#if]
[/@dialog.view]