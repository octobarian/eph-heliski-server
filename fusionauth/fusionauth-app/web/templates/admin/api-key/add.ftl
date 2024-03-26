[#ftl/]
[#-- @ftlvariable name="apiKey" type="io.fusionauth.domain.APIKey" --]
[#import "_macros.ftl" as apiMacros/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.EndpointTable(Prime.Document.queryById('endpoints'));
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="api-key-form" includeSave=true includeCancel=true cancelURI="/admin/api-key/"  breadcrumbs={"": "settings", "/admin/api-key/": "api-authentication-keys", "/admin/api-key/add": "add"}]
      <fieldset>
        [@control.text name="apiKeyId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}apiKeyId')/]
        [@control.text name="apiKey.key" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}apiKey.key')/]
        [@control.text name="apiKey.metaData.attributes['description']" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" tooltip=function.message('{tooltip}displayOnly')/]
      </fieldset>
      <fieldset>
      [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=false headerL10n="all-tenants" headerValue="" tooltip=function.message('{tooltip}tenant')/]
      [@control.checkbox name="apiKey.keyManager" value="true" uncheckedValue="false" wideTooltip=function.message('{tooltip}apiKey.keyManager')/]
      [@control.select name="apiKey.ipAccessControlListId" items=ipAccessControlLists valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-access-control-list" tooltip=function.message('{tooltip}apiKey.ipAccessControlListId')/]
       </fieldset>
      <fieldset>
        [@apiMacros.endpointTable/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
