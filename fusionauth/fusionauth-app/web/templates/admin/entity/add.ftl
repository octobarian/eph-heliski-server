[#ftl/]
[#-- @ftlvariable name="entity" type="io.fusionauth.domain.Entity" --]
[#-- @ftlvariable name="entityTypes" type="java.util.List<io.fusionauth.domain.EntityType>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="entity-form" includeSave=true includeCancel=true cancelURI="/admin/entity/"  breadcrumbs={"": "entity-management", "/admin/entity/": "entities", "/admin/entity/add": "add"}]
      [#-- Add --]
      <fieldset>
        [@control.text name="entityId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}id')/]
        [@control.text required=true name="entity.name" autofocus="autofocus" tooltip=message.inline('{tooltip}displayOnly')/]
      </fieldset>
      <fieldset>
        [#if tenants?size == 1]
          [@control.hidden name="tenantId" value=tenants?keys?first/]
        [#else]
          [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=true headerL10n="selection-required" headerValue="" tooltip=function.message('{tooltip}tenant')/]
        [/#if]
        [@control.text name="entity.clientId" tooltip=function.message('{tooltip}entity.clientId') placeholder=function.message('{placeholder}entity.clientId')/]
        [@control.text name="entity.clientSecret" tooltip=function.message('{tooltip}entity.clientSecret') placeholder=function.message('{placeholder}entity.clientId')/]
      </fieldset>
      <fieldset>
        [#if entityTypes?size == 1]
          [@control.select items=entityTypes name="entity.type.id" textExpr="name" valueExpr="id" required=true tooltip=function.message('{tooltip}entity.type.id')/]
        [#else]
          [@control.select items=entityTypes name="entity.type.id" textExpr="name" valueExpr="id" headerL10n="selection-required" headerValue="" required=true tooltip=function.message('{tooltip}entity.type.id')/]
        [/#if]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]