[#ftl/]
[#-- @ftlvariable name="entityId" type="java.util.UUID" --]
[#-- @ftlvariable name="entity" type="io.fusionauth.domain.Entity" --]
[#-- @ftlvariable name="grant" type="io.fusionauth.domain.EntityGrant" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/EntityGrant.js" type="text/javascript"></script>
    <script type="text/javascript">
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.EntityGrant();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [#assign cancelURI = "/admin/"/]
    [#assign breadcrumbs = {}/]
    [#if grant?? && grant.userId??]
      [#assign cancelURI = "/admin/user/manage/${grant.userId}?tenantId=${tenantId}"/]
      [#assign breadcrumbs = {"/admin/user/": "users", "/admin/user/manage/${grant.userId}?tenantId=${tenantId}": "manage", "/admin/entity/grant/upsert?entityId=${entityId!''}&grant.userId=${grant.userId!''}&grant.recipientEntityId=${grant.recipientEntityId!''}&tenantId=${tenantId}": "grant"}/]
    [#elseif grant?? && grant.recipientEntityId??]
      [#assign cancelURI = "/admin/entity/manage/${grant.recipientEntityId}?tenantId=${tenantId}"/]
      [#assign breadcrumbs = {"": "entity-management", "/admin/entity/": "entities", "/admin/entity/manage/${grant.recipientEntityId}?tenantId=${tenantId}": "manage", "/admin/entity/grant/upsert?entityId=${entityId!''}&grant.userId=${grant.userId!''}&grant.recipientEntityId=${grant.recipientEntityId!''}&tenantId=${tenantId}": "grant"}/]
    [/#if]
    [@layout.pageForm action="upsert" method="POST" id="entity-grant-form" class="full" includeSave=true includeCancel=true cancelURI=cancelURI breadcrumbs=breadcrumbs]
      [@control.hidden name="entityId"/]
      [@control.hidden name="grant.recipientEntityId"/]
      [@control.hidden name="grant.userId"/]
      [@control.hidden name="tenantId"/]
      [#if entityId??]
        <fieldset>
          [@control.text name="entity.name" disabled=true/]
        </fieldset>
        [#if entity.type.permissions?size > 0]
          <fieldset>
            [@control.checkbox_list items=entity.type.permissions name="grant.permissions" valueExpr="name" textExpr="name" required=false/]
          </fieldset>
        [#else]
          [@message.print key="no-permissions"/]
        [/#if]
      [#else]
        [@control.text name="q" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus=true placeholder=function.message('{placeholder}entityId')/]
      [/#if]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]