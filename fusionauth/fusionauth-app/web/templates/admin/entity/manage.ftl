[#ftl/]
[#setting url_escaping_charset='UTF-8'/]
[#-- @ftlvariable name="entity" type="io.fusionauth.domain.Entity" --]
[#-- @ftlvariable name="entityId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#--[#import "../../_utils/helpers.ftl" as helpers/]--]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.ManageEntity('${entityId}');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "entity-management", "/admin/entity/": "entities", "/admin/entity/manage/${entityId}?tenantId=${tenantId}": "manage"}/]
    [@layout.main]
      [@panel.full panelClass="panel"]
        <div class="row push-bottom entity-details">
          <div class="col-xs-12 col-md-4 col-lg-12">
            [@properties.table]
              [@properties.row nameKey="name" value=entity.name/]
              [@properties.row nameKey="id" value=entity.id/]
              [@properties.row nameKey="clientId" value=entity.clientId/]
              [@properties.row nameKey="insertInstant" value=entity.insertInstant/]
              [@properties.row nameKey="lastUpdateInstant" value=entity.lastUpdateInstant/]
              [@properties.row nameKey="type" value=entity.type.name/]
              [@properties.rowEval nameKey="parentId" object=entity propertyName="parentId"/]
            [/@properties.table]
          </div>
        </div>

        <ul class="tabs">
          <li><a href="#entities">[@message.print key="entity-grants"/]</a></li>
        </ul>

        <div id="entities" class="table-actions">
          [@control.form action="${request.contextPath}/ajax/entity/grant/search" method="GET" class="full pt-4" id="entity-search-form"]
            [@control.text name="s.name" labelKey="empty" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" placeholder=function.message('{placeholder}queryString') includeFormRow=true/]
            <div class="form-row">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="#" color="blue" icon="undo" textKey="reset" class="reset-button" name="reset"/]
              [@button.iconLinkWithText href="/admin/entity/grant/upsert?grant.recipientEntityId=${entityId}&tenantId=${tenantId}" color="green" icon="plus" textKey="add" class="add-button float-right" name="add"/]
            </div>
          [/@control.form]

          <div id="entity-search-results">
          </div>
        </div>
      [/@panel.full]

      <div id="error-dialog" class="prime-dialog hidden">
        [@dialog.basic titleKey="error" includeFooter=true]
          <p>
            [@message.print key="[AJAXError]"/]
          </p>
        [/@dialog.basic]
      </div>
    [/@layout.main]
  [/@layout.body]
[/@layout.html]

