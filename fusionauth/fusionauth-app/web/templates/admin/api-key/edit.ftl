[#ftl/]
[#-- @ftlvariable name="apiKeyId" type="java.util.UUID" --]
[#-- @ftlvariable name="apiKey" type="io.fusionauth.domain.APIKey" --]
[#import "_macros.ftl" as apiMacros/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
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
    [@layout.pageForm action="edit" method="POST" id="api-key-form" includeSave=true includeCancel=true cancelURI="/admin/api-key/"  breadcrumbs={"": "settings", "/admin/api-key/": "api-authentication-keys", "/admin/api-key/edit/${apiKeyId}": "edit"}]
      <fieldset>
        [@control.hidden name="apiKeyId"/]
        [@control.hidden name="apiKey.key"/]
        [@control.text name="apiKeyId" disabled=true tooltip=message.inline('{tooltip}readOnly')/]
        [@control.text name="apiKey.key" disabled=true tooltip=message.inline('{tooltip}readOnly')/]
        [@control.text name="apiKey.metaData.attributes['description']" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]
       </fieldset>
       <fieldset>
        [#if apiKey.tenantId?has_content]
          [@control.text name="apiKey.tenantId" value=helpers.tenantName(apiKey.tenantId) disabled=true tooltip=message.inline('{tooltip}readOnly')/]
        [#else]
          [@control.text name="apiKey.tenantId" value=message.inline("all-tenants") disabled=true tooltip=message.inline('{tooltip}readOnly')/]
        [/#if]
        [@control.checkbox name="apiKey.keyManager" value="true" uncheckedValue="false" wideTooltip=function.message('{tooltip}apiKey.keyManager')/]
        [@control.select name="apiKey.ipAccessControlListId" items=ipAccessControlLists valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-access-control-list" tooltip=function.message('{tooltip}apiKey.ipAccessControlListId')/]
      </fieldset>
      <fieldset>
        [@apiMacros.endpointTable/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
