[#ftl/]
[#-- @ftlvariable name="grants" type="java.util.List<io.fusionauth.domain.EntityGrant>" --]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

<div class="table-actions simple pagination">
  <div class="page-controls">
    [@search.pagination][/@search.pagination]
  </div>
</div>
<table class="hover" data-sortable="false">
  <thead class="light-header">
  <tr>
    <th class="application">[@message.print key="application"/]</th>
    <th class="instant">[@message.print key="time"/]</th>
    <th class="ip-address">[@message.print key="ip-address"/]</th>
  </tr>
  </thead>
  <tbody>
  [#if logins?? && logins?size > 0]
    [#list logins as login]
    <tr>
      <td>${properties.display(login, "applicationName")}</td>
      <td>${function.format_zoned_date_time(login.instant, function.message('date-time-seconds-format'), zoneId)}</td>
      <td>${properties.display(login, "ipAddress")}</td>
    </tr>
    [/#list]
  [#else]
  <tr>
    <td colspan="3">[@message.print key="no-logins"/]</td>
  </tr>
  [/#if]
  </tbody>
</table>