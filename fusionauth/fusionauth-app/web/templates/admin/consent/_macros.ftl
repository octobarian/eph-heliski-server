[#ftl/]
[#setting url_escaping_charset='UTF-8'/]

[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Consent>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/locale.ftl" as locale/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro formFields action]
  <fieldset>
    [#if action=="edit"]
      [@control.hidden name="consentId"/]
      [@control.text disabled=true name="consentId" tooltip=message.inline('{tooltip}readOnly')/]
    [#else]
      [@control.text name="consentId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}consentId')/]
    [/#if]
    [@control.text required=true name="consent.name" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]
    [@control.text name="consent.defaultMinimumAgeForSelfConsent" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=message.inline('{tooltip}consent.defaultMinimumAgeForSelfConsent') rightAddonText="${function.message('YEARS')}"/]
    [@control.select name="consent.consentEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=message.inline('{tooltip}consent.consentEmailTemplateId')/]
    [@control.checkbox name="consent.multipleValuesAllowed" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}consent.multipleValuesAllowed') /]
  </fieldset>

  <fieldset class="mt-4">

    <ul class="tabs">
      <li><a href="#values">[@message.print key="consent.values"/]</a></li>
      <li><a href="#email-plus">[@message.print key="email-plus"/]</a></li>
      <li><a href="#localization">[@message.print key="localization"/]</a></li>
    </ul>

    <div id="values" class="hidden">
      <fieldset>
        <table id="values-table" data-template="value-template" data-add-button="value-add-button">
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
          <tr class="empty-row">
            <td colspan="2">[@message.print key="no-values"/]</td>
          </tr>
          [#list consent.values![] as val]
            <tr>
              <td><input type="text" class="tight" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="consent.values[${val_index}]" value="${(val!'')}"/></td>
              <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
            </tr>
          [/#list]
          </tbody>
        </table>
        <script type="x-handlebars" id="value-template">
        <tr>
          <td><input type="text" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="consent.values[{{index}}]"/></td>
          <td>[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
        </tr>
        </script>
        [@button.iconLinkWithText href="#" color="blue" id="value-add-button" icon="plus" textKey="add-value"/]
      </fieldset>
    </div>

    <div id="email-plus" class="hidden">
      <p><em>[@message.print key="{description}email-plus"/]</em></p>
      [@control.checkbox name="consent.emailPlus.enabled" value="true" uncheckedValue="false" data_slide_open="email-plus-body"/]

      <div id="email-plus-body" class="slide-open ${consent.emailPlus.enabled?then('open', '')}">
        <fieldset>
          [@control.select name="consent.emailPlus.emailTemplateId" items=emailTemplates valueExpr="id" required=true textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" tooltip=message.inline('{tooltip}consent.emailPlus.emailTemplateId')/]
          [@control.text name="consent.emailPlus.minimumTimeToSendEmailInHours" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=message.inline('{tooltip}consent.emailPlus.minimumTimeToSendEmailInHours') rightAddonText="${function.message('HOURS')}"/]
          [@control.text name="consent.emailPlus.maximumTimeToSendEmailInHours" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=message.inline('{tooltip}consent.emailPlus.maximumTimeToSendEmailInHours') rightAddonText="${function.message('HOURS')}"/]
        </fieldset>
      </div>
    </div>

    <div id="localization" class="hidden">
      <fieldset>
        <table id="consent-age-table" data-template="consent-age-template" data-add-button="add-localized-age-button">
          <thead>
          <tr>
            <th>[@message.print key="locale"/]</th>
            <th>[@message.print key="consent.defaultMinimumAgeForSelfConsent"/]</th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
          <tr class="empty-row">
            <td colspan="2">[@message.print key="no-localized-age-consents"/]</td>
          </tr>
          [#list consent.countryMinimumAgeForSelfConsent!{} as country, age]
            <tr>
              <td>[@locale.select country/]</td>
              <td><input type="text" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("{placeholder}age")}" name="consent.countryMinimumAgeForSelfConsent['${country}']" value="${age}"/></td>
              <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
            </tr>
          [/#list]
          </tbody>
        </table>
        <script type="x-handlebars" id="consent-age-template">
        <tr>
          <td>[@locale.select ""/]</td>
          <td><input type="text" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("{placeholder}age")}" name="consent.countryMinimumAgeForSelfConsent['${locales[0]}']"/></td>
          <td>[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
        </tr>
        </script>
        [@button.iconLinkWithText href="#" color="blue" id="add-localized-age-button" icon="plus" textKey="add-localized-age"/]
      </fieldset>
    </div>

  </fieldset>
[/#macro]

[#macro consentsTable]
  <table class="hover listing" data-sortable="false">
    <thead>
      [@helpers.tableHeader "name"/]
      [@helpers.tableHeader "id" "hide-on-mobile"/]
      <th data-sortable="false" class="hide-on-mobile">[@message.print "consent.values"/]</th>
      <th data-sortable="false" class="action">[@message.print "action"/]</th>
    </thead>
    <tbody>
    [#list results![] as consent]
      <tr>
        <td>${properties.display(consent, "name")}</td>
        <td class="hide-on-mobile">${properties.display(consent, "id")}</td>
        <td class="hide-on-mobile">${properties.display(consent, "values")}</td>
        <td class="action">
          [@button.action href="/admin/consent/edit/${consent.id}" icon="edit" key="edit" color="blue"/]
          [@button.action href="/ajax/consent/view/${consent.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
          [@button.action href="/admin/consent/delete/${consent.id}" icon="trash" key="delete" color="red"/]
        </td>
      </tr>
    [#else]
      <tr>
        <td colspan="4">[@message.print "no-results"/]</td>
      </tr>
    [/#list]
    </tbody>
  </table>
[/#macro]
