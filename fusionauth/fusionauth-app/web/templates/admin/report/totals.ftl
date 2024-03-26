[#ftl/]
[#-- @ftlvariable name="applicationMap" type="java.util.Map<java.util.UUID, io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="response" type="io.fusionauth.domain.api.report.TotalsReportResponse" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=false breadcrumbs={"": "reports", "/admin/report/totals": "totals"}/]
    [@layout.main]
      [@panel.full]

      <fieldset>
        <legend>[@message.print key="global-totals"/]</legend>
        <p><em>[@message.print key="global-totals-description"/]</em></p>
        [@properties.table]
          [@properties.rowEval "current-registrations" response "globalRegistrations"/]
          [@properties.rowEval "total-registrations" response "totalGlobalRegistrations"/]
        [/@properties.table]
      </fieldset>

      <fieldset>
        <legend>[@message.print key="application-totals"/]</legend>
        <p><em>[@message.print key="application-totals-description"/]</em></p>
        <table class="hover">
          <thead>
          <tr>
            <th>[@message.print key="application"/]</th>
            [#if tenants?size > 1]
              <th>[@message.print key="tenant"/]</th>
            [/#if]
            <th>[@message.print key="current-registrations"/]</th>
            <th>[@message.print key="total-registrations"/]</th>
            <th>[@message.print key="logins"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list response.applicationTotals?keys as applicationId]
            <tr>
              <td>${applicationMap(applicationId).name}</td>
              [#if tenants?size > 1]
                <td>${helpers.tenantName(applicationMap(applicationId).tenantId)}</td>
              [/#if]
              <td>${response.applicationTotals(applicationId).registrations?string('#,###')}</td>
              <td>${response.applicationTotals(applicationId).totalRegistrations?string('#,###')}</td>
              <td>${response.applicationTotals(applicationId).logins?string('#,###')}</td>
            </tr>
            [/#list]
          </tbody>
        </table>
      </fieldset>

      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]