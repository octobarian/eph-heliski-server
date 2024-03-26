[#ftl/]
[#-- @ftlvariable name="logins" type="java.util.List<io.fusionauth.domain.DisplayableRawLogin>" --]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

<div class="table-actions simple pagination">
  <div class="page-controls">
    [@button.ajaxLink additionalClass="previous" icon="angle-left" tooltipKey="previous"/]
    <a href="#" class="disabled">&hellip;</a>
    [@button.ajaxLink additionalClass="next ${(logins?? && logins?size lt 10)?then('disabled', '')}" icon="angle-right" tooltipKey="next"/]
  </div>
</div>
<table class="hover">
  <thead class="light-header">
  <tr>
    <th class="application">[@message.print key="application"/]</th>
    <th class="instant">[@message.print key="time"/]</th>
    [#if reactorStatus.threatDetection == "ACTIVE"]
    <th class="location">[@message.print key="location"/]</th>
    [/#if]
    <th class="ip-address">[@message.print key="ip-address"/]</th>
  </tr>
  </thead>
  <tbody>
  [#if logins?? && logins?size > 0]
    [#list logins as login]
    <tr>
      <td>${properties.display(login, "applicationName")}</td>
      <td>${properties.displayZonedDateTime(login, "instant", "date-time-seconds-format")}</td>
      [#if reactorStatus.threatDetection == "ACTIVE"]
      <td>${properties.display(login, "location.displayString")}
      [/#if]
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