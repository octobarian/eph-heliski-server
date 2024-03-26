[#ftl/]
[#-- @ftlvariable name="entity" type="io.fusionauth.domain.Entity" --]
[#-- @ftlvariable name="entityId" type="java.util.UUID" --]

[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        var element = Prime.Document.queryById('entity_clientSecret');
        new FusionAuth.Admin.ClientSecret(element)
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${entityId}" method="POST" includeSave=true includeCancel=true cancelURI="/admin/entity/"
                      breadcrumbs={"": "entity-management", "/admin/entity/": "entities", "/admin/entity/edit/${entityId}?tenantId=${tenantId}": "edit"}]
      [#-- Edit --]
      [@control.hidden name="entityId"/]
      [@control.hidden name="tenantId"/]

      <fieldset>
        [@control.text disabled=true name="entityId" tooltip=message.inline('{tooltip}readOnly')/]
        [@control.text required=true name="entity.name" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]
        [#if tenants?size > 1]
          [@control.text name="tenantId" labelKey="tenant" value=helpers.tenantName(tenantId) autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
        [/#if]
      </fieldset>
      <fieldset>
        [@control.text  disabled=true name="entity.clientId" tooltip=function.message('{tooltip}readOnly')/]
        [@control.hidden name="entity.clientId"/]

        [@control.text name="entity.clientSecret" tooltip=function.message('{tooltip}readOnly') disabled=true rightAddonButton="<i class=\"fa fa-arrow-circle-right\"></i> <span class=\"text\">${message.inline('regenerate')?markup_string}</span>"?no_esc data_hidden="client-secret-hidden" data_warn="entity-warn"/]
        [@control.hidden id="client-secret-hidden" name="entity.clientSecret"/]
      </fieldset>
      <fieldset>
        [@control.select items=entityTypes name="entity.type.id" textExpr="name" valueExpr="id" headerL10n="selection-required" headerValue="" tooltip=function.message('{tooltip}readOnly') disabled=true /]
        [@control.hidden name="entity.type.id"/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]