[#ftl/]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="hasDomainBasedIdentityProviders" type="boolean" --]
[#-- @ftlvariable name="showPasswordField" type="boolean" --]
[#-- @ftlvariable name="showPasswordValidationRules" type="boolean" --]
[#-- @ftlvariable name="method" type="java.lang.String" --]
[#-- @ftlvariable name="step" type="int" --]
[#-- @ftlvariable name="totalSteps" type="int" --]
[#-- @ftlvariable name="theme" type="io.fusionauth.domain.Theme" --]
[#-- @ftlvariable name="userCodeLength" type="int" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]


[@layout.html]
[@layout.head]
<script>
  Prime.Document.onReady(function() {
    new Prime.Widgets.Tabs(Prime.Document.queryById('ui-tabs'))
        .withErrorClassHandling('error')
        .withLocalStorageKey('settings.theme.ui-configuration.tabs')
        .initialize();

    Prime.Document.query('.theme-preview input[type="checkbox"],select').addEventListener('change', function(event) {
      var target=  Prime.Document.Element.wrap(event.target);
      target.queryUp('form').domElement.submit();
    });
  });
</script>
[/@layout.head]
<body>
[@panel.full panelClass="panel mt-4" mainClass="h-100"]
  [@properties.table]
    [@properties.rowEval nameKey="name" object=theme propertyName="name"/]
    [@properties.rowEval nameKey="id" object=theme propertyName="id"/]
    [@properties.rowEval nameKey="insertInstant" object=theme propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=theme propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#assign templates = []/]
  [#list fusionAuth.statics['io.fusionauth.domain.Theme$Templates'].Names as templateName]
    [#if templateName != "helpers"]
      [#assign templates = templates + [templateName]/]
    [/#if]
  [/#list]

  <div class="row h-100 theme-preview">
    <div class="col-xs-6 col-md-4 col-lg-6 col-xl-2">
      <ul id="ui-tabs" class="vertical-tabs vertical scrollable" style="max-height: calc(90vh - 186px); overflow-x: hidden;">
        [#list templates as template]
          <li><a href="#${template}">[@message.print key="theme.templates.${template}"/] <label><i class="fa fa-info-circle" data-tooltip="${function.message('{tooltip}theme.templates.${template}')}"></i></label></a></li>
        [/#list]
      </ul>
    </div>
    <div class="col-xs-6 col-md-8 col-lg-6 col-xl-10">
    [#list templates as template]
      <div id="${template}" class="vertical-tab hidden">
        <div>
          [#assign previewURL = "/admin/theme/preview"
          + "?applicationId=${applicationId}"
          + "&themeId=${theme.id}"
          + "&template=${template}"
          + "&hasDomainBasedIdentityProviders=${hasDomainBasedIdentityProviders?c}"
          + "&method=${method}"
          + "&showPasswordField=${showPasswordField?c}"
          + "&showPasswordValidationRules=${showPasswordValidationRules?c}"
          + "&step=${step}"
          + "&userCodeLength=${userCodeLength}"
          /]
        <iframe style="display: block; width: 100%; min-height: 500px; height: calc(100vh - 40vh); border: 1px solid #bfbfbf;" src="${previewURL}"></iframe>
        </div>
        <div class="mt-4">
            [@control.form action="view" method="GET" class="full labels-left"]
                [@control.hidden name="themeId"/]
                [#-- Show controls relevant to the template --]
                [#if template == "passwordChange" || template == "oauth2Register" || template == "oauth2CompleteRegistration" ]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.select items=applications name="applicationId" textExpr="name" valueExpr="id"/]
                    </div>
                    [#if template == "oauth2Register" || template == "oauth2CompleteRegistration" ]
                      <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                         [#assign formSteps = []/]
                         [#if totalSteps >0]
                           [#list 0..<totalSteps as i]
                              [#assign formSteps = formSteps + [i + 1] /]
                            [/#list]
                         [/#if]
                         [#if formSteps?has_content]
                           [@control.select items=formSteps name="step" /]
                         [/#if]
                      </div>
                       <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                        [@control.checkbox name="showPasswordValidationRules" value="true" uncheckedValue="false"/]
                      </div>
                    [#elseif template == "passwordChange"]
                      <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                        [@control.checkbox name="showPasswordValidationRules" value="true" uncheckedValue="false"/]
                      </div>
                    [/#if]
                  </div>
                [/#if]
                [#--  Begin a new if block, there is smoe overlap  --]
                [#if template == "oauth2Authorize" || template = "oauth2ChildRegistrationNotAllowedComplete" || template = "oauth2CompleteRegistration"]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.checkbox name="hasDomainBasedIdentityProviders" value="true" uncheckedValue="false"/]
                    </div>
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.checkbox name="showPasswordField" value="true" uncheckedValue="false"/]
                    </div>
                  </div>
                [#elseif template == "oauth2Device"]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.text name="userCodeLength"/]
                    </div>
                  </div>
               [#elseif template == "accountTwoFactorDisable"]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [#assign availableMethodObject = {}/]
                      [#list ["authenticator", "email", "sms"] as method ]
                        [#assign availableMethodObject = availableMethodObject + { method: message.inline(method)} /]
                      [/#list]
                      [@control.select items=availableMethodObject name="method" /]
                    </div>
                  </div>
                [/#if]
            [/@control.form]
        </div>
      </div>
    [/#list]
    </div>
  </div>
[/@panel.full]
</body>
[/@layout.html]
