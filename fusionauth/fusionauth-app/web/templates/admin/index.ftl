[#ftl/]
[#-- @ftlvariable name="apiKeySetup" type="boolean" --]
[#-- @ftlvariable name="applicationSetup" type="boolean" --]
[#-- @ftlvariable name="dailyActiveUserReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="fusionAuthTenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="loginData" type="io.fusionauth.app.service.ReportUtil.ReportData" --]
[#-- @ftlvariable name="logins" type="io.fusionauth.domain.DisplayableRawLogin[]" --]
[#-- @ftlvariable name="loginReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="proxyConfigReport" type="io.fusionauth.app.action.admin.ProxyConfigTestAction.ProxyConfigReport" --]
[#-- @ftlvariable name="registrationReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="tenantSetup" type="boolean" --]
[#-- @ftlvariable name="totalsReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]

[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/admin.ftl" as layout/]
[#import "../_utils/helpers.ftl" as helpers/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]
[#import "../_utils/properties.ftl" as properties/]
[#import "../_utils/report.ftl" as report/]

[@layout.html]
[@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.Dashboard([[#list loginData.labels as label]"${label}"[#sep], [/#list]],
        [[#list loginData.counts as count]${count}[#sep], [/#list]], ${(reactorStatus.threatDetection == "ACTIVE")?c});
    });
  </script>
[/@layout.head]
[@layout.body]
  [@layout.pageHeader/]
  [@layout.main]

    [#-- Is the Proxy Config Screwed up? Let's check it. --]
    <div id="proxy-report-result" data-nonce="${context.getAttribute("ProxyTestNonce")}">
    </div>
    <iframe id="proxy-report-iframe" width="0" height="0" src="${request.contextPath}/admin/proxy-config-test" class="hidden"></iframe>

    [#if !applicationSetup || !apiKeySetup || !tenantSetup]
      [#assign setupIndex = 1/]
      [@panel.full titleKey="complete-setup" rowClass="row push-more-bottom" panelClass="panel green" mainClass="row"]
        [#if !applicationSetup]
          [#-- Application setup step --]
          <div class="col-xs-12 col-sm-6 col-md-4 blue-gray card">
            <header>
              <span class="corner">#${setupIndex}</span>
              <h3>[@message.print key="missing-application"/]</h3>
            </header>
            <main>
              <i class="fa fa-cube background hover"></i>
              <div>
                <p>
                  [@message.print key="missing-application-info"/]
                </p>
              </div>
            </main>
            <footer class="text-right">
              [@button.iconLinkWithText href="/admin/application/add" textKey="setup"/]
            </footer>
          </div>
          [#assign setupIndex += 1/]
        [/#if]

        [#if !apiKeySetup]
          [#-- API Key setup step --]
          <div class="col-xs-12 col-sm-6 col-md-4 blue-gray card">
            <header>
              <span class="corner">#${setupIndex}</span>
              <h3>[@message.print key="missing-api-key"/]</h3>
            </header>
            <main>
              <i class="fa fa-key background hover"></i>
              <div>
                <p>
                  [@message.print key="missing-api-key-info"/]
                </p>
              </div>
            </main>
            <footer class="text-right">
              [@button.iconLinkWithText href="/admin/api-key/add" textKey="add"/]
            </footer>
          </div>
          [#assign setupIndex += 1/]
        [/#if]

        [#if !tenantSetup]
          [#-- Email setup step --]
          <div class="col-xs-12 col-sm-6 col-md-4 blue-gray card">
            <header>
              <span class="corner">#${setupIndex}</span>
              <h3>[@message.print key="email-settings"/]</h3>
            </header>
            <main>
              <i class="fa fa-envelope-o background hover"></i>
              <div>
                <p>
                  [@message.print key="email-settings-info"/]
                </p>
              </div>
            </main>
            <footer class="text-right">
              [@button.iconLinkWithText href="/admin/tenant/edit/${fusionAuthTenantId}#email-configuration" textKey="setup"/]
            </footer>
          </div>
        [/#if]
      [/@panel.full]
    [/#if]

    [@panel.full ]

      <div class="row mb-4 tight-both">
        <div class="col-lg-3 col-md-6 col-xs-12 blue card">
          [@reportCard "users", totalsReport, "total-users", false/]
        </div>
        <div class="col-lg-3 col-md-6 col-xs-12 green card">
          [@reportCard "sign-in", loginReport, "logins-today", true/]
        </div>
        <div class="col-lg-3 col-md-6 col-xs-12 red card">
          [@reportCard "user-plus", registrationReport, "registrations-today", true/]
        </div>
        <div class="col-lg-3 col-md-6 col-xs-12 orange card">
          [@reportCard "line-chart", dailyActiveUserReport, "daily-active-users", true/]
        </div>
      </div>

      [#if reactorStatus.threatDetection == "ACTIVE" ]
      [#assign currentLocation = fusionAuth.currentLocation()!{}/]
      <div class="row">
        <div class="col-xs">
          <div id="login-heat-map" class="mb-4" style="height: 500px; width: 100%;" data-initial-longitude="${(currentLocation.longitude)!''}" data-initial-latitude="${(currentLocation.latitude)!''}"></div>
        </div>
      </div>
      [/#if]

      <header>
        <h2 style="padding-left: 0 !important;">[@message.print key="recent-logins"/]</h2>
      </header>

      <table class="hover">
        <thead>
          <tr>
            <th>[@message.print key="user"/]</th>
            <th class="hide-on-mobile">[@message.print key="application"/]</th>
            <th>[@message.print key="time"/]</th>
            [#if reactorStatus.threatDetection == "ACTIVE"]
            <th class="hide-on-mobile">[@message.print key="location"/]</th>
            [/#if]
            <th class="hide-on-mobile">[@message.print key="ip-address"/]</th>
          </tr>
        </thead>
        <tbody>
          [#list logins[0..*10] as login]
          <tr>
            <td class="break-all">[@properties.truncate login "loginId"  40/]</td>
            <td class="hide-on-mobile break-all">[@properties.truncate login "applicationName" 40/]</td>
            <td>${properties.displayZonedDateTime(login, "instant")}</td>
            [#if reactorStatus.threatDetection == "ACTIVE"]
            <td class="hide-on-mobile">${properties.display(login, "location.displayString")}</td>
            [/#if]
            <td class="hide-on-mobile"> ${properties.display(login, "ipAddress")} </td>
          </tr>
          [/#list]
        </tbody>
      </table>

      <div class="row">
        <div class="col-xs text-right tight-both">
          <a href="${request.contextPath}/admin/system/login-record/">[@message.print key="all-login-records"/]
            <i class="fa fa-arrow-right"></i>
          </a>
        </div>
      </div>
    [/@panel.full]

    <div class="row push-bottom">
      <div class="col-xs-12 panel" id="hourly-logins">
        [@report.typeToggle /]
        <header>
          <h2> [@message.print key="logins-by-hour"/] </h2>
        </header>
        <main>
          <canvas id="login-chart" height="400" width="400"></canvas>
        </main>
      </div>
    </div>
  [/@layout.main]

[/@layout.body]
[/@layout.html]

[#macro reportCard icon object titleKey includeChange]
  <header>
    <h3>[@message.print key=titleKey/]</h3>
    [#if includeChange]
      [#if object.change?has_content]
        <span class="${object.increase?then('increase', 'decrease')}">${object.change}%</span>
      [#else]
        <span>[@message.print key="not-available"/]</span>
      [/#if]
    [/#if]
  </header>
  <main>
    <i class="fa fa-${icon} background hover"></i>
    <p class="large text-center">${object.count}</p>
  </main>
[/#macro]