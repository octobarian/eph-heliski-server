[#ftl/]
[#setting url_escaping_charset='UTF-8'/]

[#-- @ftlvariable name="noInternet" type="boolean" --]
[#-- @ftlvariable name="metrics" type="io.fusionauth.domain.reactor.ReactorMetrics" --]
[#-- @ftlvariable name="status" type="io.fusionauth.domain.reactor.ReactorStatus" --]
[#-- @ftlvariable name="tenants" type="java.util.Map<java.util.UUID, io.fusionauth.domain.Tenant>" --]
[#-- @ftlvariable name="totalActionRequired" type="int" --]
[#-- @ftlvariable name="totalPasswordsBreached" type="int" --]
[#-- @ftlvariable name="totalPasswordsChecked" type="int" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[#macro reportCard icon value titleKey]
  <header>
    <h3>[@message.print key=titleKey/]</h3>
  </header>
  <main>
    <i class="fa fa-${icon} background hover"></i>
    [#if (value!0) > 999999999]
      [#assign fontSize = "lg-text" /]
    [#elseif (value!0) > 999999]
      [#assign fontSize = "xl-text" /]
    [#else]
      [#assign fontSize = "xxl-text" /]
    [/#if]
    <p class="${fontSize} text-center">${value?string('#,###')}</p>
  </main>
[/#macro]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/Reactor.js?version=${version}"></script>
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.Reactor();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false breadcrumbs={"/admin/reactor/": "reactor"}]
      [#if status.licensed]
        [#if status.breachedPasswordDetection == "ACTIVE" || status.breachedPasswordDetection == "DISCONNECTED"]
          [@button.ajaxLink href="/ajax/reactor/regenerate-key?primeCSRFToken=${csrfToken}" id="regenerate-key" color="orange" icon="refresh" tooltipKey="{tooltip}regenerate" additionalClass="square button" ajaxForm=true ajaxWideDialog=true/]
        [/#if]
        [@button.iconLink href="/admin/reactor/deactivate" icon="minus-circle" color="red" tooltipKey="deactivate"/]
      [/#if]
    [/@layout.pageHeader]

    [@layout.main]
      [#-- Unavailable, activate the Reactor --]
      [#if !status.licensed]
        [@panel.full titleKey="activate" panelClass="panel orange"]
          <p class="mt-2 mb-4">[@message.print key="{description}purchase"/]</p>
          <div class="col-lg-12 col-md-12 col-sm-12 tight-left mb-4">
            [@control.form action="${request.contextPath}/admin/reactor/activate" method="POST" class="full tight"]
             <fieldset>
                [@control.text id="activate-license" name="licenseId" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" includeFormRow=true/]
                <div class="form-row">
                  <label class="checkbox">
                    <input type="checkbox" name="" data-slide-open="license-text">
                    <span class="box"></span>
                    <span class="label">[@message.print key="haveAirGappedLicense"/]</span>
                  </label>
                </div>
                <div id="license-text" class="slide-open">
                  <p class="mt-0"> [@message.print key="{description}license"/] </p>
                  [@control.text name="license" autocapitalize="none" autocomplete="off" autocorrect="off" includeFormRow=true/]
                </div>
             </fieldset>
             <div class="form-row">
               <button class="button blue" data-activating="${message.inline('activating')}"><i class="fa fa-arrow-circle-right"></i> <span class="text">${message.inline('activate')}</span></button>
             </div>
            [/@control.form]
          </div>
        [/@panel.full]
      [/#if]

      [#-- Overview --]
      [@panel.full]

        <div class="row mb-4">
          <div class="col-lg-4 col-md-6 col-xs-12 blue card">
            [@reportCard "lock", totalPasswordsChecked, "total-checked" /]
          </div>
          <div class="col-lg-4 col-md-6 col-xs-12 red card">
            [@reportCard "user-secret", totalPasswordsBreached, "total-breached" /]
          </div>
          <div class="col-lg-4 col-md-6 col-xs-12 orange card">
            [@reportCard "warning", totalActionRequired, "total-remaining-breaches" /]
          </div>
        </div>

        [#if totalActionRequired  > 0 ]
          <fieldset style="border-left: 3px solid orange; padding-left: 15px;">
            <h3>[@message.print key="action-required"/]</h3>
            <p>
             [#if totalActionRequired > 1]
               [@message.print key="reactor-action-required" values=[totalActionRequired?string('#,###')] /]
             [#else]
              [@message.print key="reactor-action-required-single"/]
             [/#if]
            </p>

             [#assign queryString = "_exists_:breachedPasswordStatus AND NOT (breachedPasswordStatus:None)"/]
             <a href="${request.contextPath}/admin/user/?queryString=${queryString?url}" class="blue button mt-2">
               <i class="fa fa-search"></i>
               [@message.print key="breached-users" /]
             </a>
         </fieldset>
        [/#if]

        <fieldset>
          [@properties.table classes="properties mt-4"]
            [@properties.rowEval nameKey="instanceId" object=instance propertyName="id"/]
            [#assign licensedStatus]
              ${properties.display(status, "licensed", "\x2013", true, true)}
              [#if status.licenseAttributes?has_content && status.licenseAttributes["LicensedPlan"]??]
                 &nbsp;${status.licenseAttributes["LicensedPlan"]}[#rt]
              [/#if]
              [#-- Display when not using a production license --]
              [#if status.licenseAttributes?has_content && status.licenseAttributes["LicenseType"] != "Production"]
                 .&nbsp; ${status.licenseAttributes["LicenseType"]}, usage will not count towards your billable MAU.[#lt]
              [/#if]
            [/#assign]
            [@properties.row nameKey="licensed" value=licensedStatus/]
            [#if status.expiration??]
              [@properties.rowEval nameKey="expiration" object=status propertyName="expiration"/]
            [/#if]
            [@properties.rowEval nameKey="advancedIdentityProviders" object=status propertyName="advancedIdentityProviders"/]
            [@properties.rowEval nameKey="advancedLambdas" object=status propertyName="advancedLambdas"/]
            [#-- Advanced MFA has capabbilities --]
            [@properties.rowNestedValue nameKey="advancedMultiFactorAuthentication"]
               ${properties.display(status, "advancedMultiFactorAuthentication")}[#rt]
               [#if status.applicationMultiFactorAuthentication == "ACTIVE"]
                 .&nbsp;Including Application configuration.[#lt]
               [/#if]
            [/@properties.rowNestedValue]
            [@properties.rowEval nameKey="advancedRegistration" object=status propertyName="advancedRegistration"/]
            [@properties.rowEval nameKey="breachedPasswordDetection" object=status propertyName="breachedPasswordDetection"/]
            [@properties.rowEval nameKey="connectors" object=status propertyName="connectors"/]
            [@properties.rowEval nameKey="entityManagement" object=status propertyName="entityManagement"/]
            [@properties.rowEval nameKey="scimServer" object=status propertyName="scimServer"/]
            [@properties.rowEval nameKey="threatDetection" object=status propertyName="threatDetection"/]
            [#-- WebAuthn has capabilities, skills if you will. --]
            [@properties.rowNestedValue nameKey="webAuthn"]
               ${properties.display(status, "webAuthn")}[#rt]
               [#if status.webAuthnRoamingAuthenticators == "ACTIVE"]
                .&nbsp;Including cross-platform authenticators.[#lt]
               [/#if]
            [/@properties.rowNestedValue]
          [/@properties.table]
          [#if status.threatDetection == "DISABLED"]
            <p><em>[@message.print key="{description}threatDetectionDisabled"/]</em></p>
          [/#if]
        </fieldset>

       <fieldset class="mt-4">
        <legend>[@message.print key="tenants"/]</legend>
        <p><em>[@message.print key="{description}tenants"/]</em></p>
        <table class="hover">
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th>[@message.print key="enabled"/]</th>
            <th>[@message.print key="total-checked"/]</th>
            <th>[@message.print key="total-breached"/]</th>
            <th>[@message.print key="total-remaining-breaches"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list tenants?values as tenant]
            <tr>
              <td>${properties.display(tenant, "name")}</td>
              <td>${properties.display(tenant.passwordValidationRules.breachDetection, "enabled")}</td>
              <td>${properties.display(metrics.breachedPasswordMetrics(tenant.id)!{}, "passwordsCheckedCount")}</td>
              <td>${properties.display(metrics.breachedPasswordMetrics(tenant.id)!{}, "totalBreached()")}</td>
              <td>${properties.display(metrics.breachedPasswordMetrics(tenant.id)!{}, "actionRequired")}</td>
            </tr>
            [/#list]
          </tbody>
        </table>
      </fieldset>
      [/@panel.full]

    [/@layout.main]
  [/@layout.body]
[/@layout.html]