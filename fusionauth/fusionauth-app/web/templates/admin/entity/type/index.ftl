[#ftl/]
[#-- @ftlvariable name="entityTypes" type="java.util.List<io.fusionauth.domain.EntityType>" --]
[#-- @ftlvariable name="firstResult" type="int" --]
[#-- @ftlvariable name="lastResult" type="int" --]
[#-- @ftlvariable name="totalCount" type="int" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.EntityTypeSearchCriteria" --]

[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      const form = Prime.Document.queryById('entity-type-form');
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.entity.type.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "entity-management", "/admin/entity/type/": "page-title"}]
      <div id="entity-types-action" class="split-button" data-local-storage-key="entity-types-split-button">
        <a class="gray button item" href="#">
          <i class="fa fa-spinner fa-pulse"></i>
          <span> [@message.print key="loading"/]</span>
         </a>
        <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
        </button>
        <div class="menu">
          [#list {"type":"", "scim-client":"scim-client", "scim-server":"scim-server"} as key, value]
            <a id="add-${key}" class="item" href="/admin/entity/type/add/${value}">
              <i class="green-text fa fa-plus"></i>
              <span> [@message.print key="add-${key}"/] </span>
            </a>
          [/#list]
        </div>
      </div>
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full displayTotal=(entityTypes![])?size]
        [@control.form id="entity-type-form" action="${request.contextPath}/admin/entity/type/" method="GET" class="labels-above full push-bottom" searchResults="entity-type-results"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs tight-left">
              <div class="form-row">
                [@control.text name="s.name" labelKey="empty" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" placeholder="${function.message('search-placeholder')}"/]
              </div>
            </div>
          </div>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="/admin/entity/type/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="entity-type-results">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="hover listing" data-sortable="false">
              <thead>
                [@helpers.tableHeader "name"/]
                [@helpers.tableHeader "id" "hide-on-mobile"/]
                [@helpers.tableHeader "entityTypePermissionsCount" "" "number"/]
                [@helpers.tableHeader "insertInstant"/]
                <th data-sortable="false" class="action">[@message.print "action"/]</th>
              </thead>
              <tbody>
              [#list results![] as result]
                <tr>
                  <td>${properties.display(result, "name")}</td>
                  <td class="hide-on-mobile">${properties.display(result, "id")}</td>
                  <td data-sort-value="${result.permissions?size}">${properties.displayNumber(result, "permissions")}</td>
                  <td class="hide-on-mobile">${properties.display(result, 'insertInstant')}</td>
                  <td class="action">
                    [@button.action href="/admin/entity/type/edit/${result.id}" icon="edit" key="edit" color="blue"/]
                    [@button.action href="/admin/entity/type/permission/?entityTypeId=${result.id}" icon="key" key="manage-permissions" color="purple"/]
                    [@button.action href="/ajax/entity/type/view/${result.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
                    [@button.action href="/admin/entity/type/delete/${result.id}" icon="trash" key="delete" color="red"/]
                  </td>
                </tr>
              [#else]
                <tr>
                  <td colspan="5">[@message.print "no-entity-types"/]</td>
                </tr>
              [/#list]
              </tbody>
            </table>
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
