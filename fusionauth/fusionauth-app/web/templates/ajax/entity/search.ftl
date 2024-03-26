[#ftl/]
[#-- @ftlvariable name="fullQuery" type="java.lang.String" --]
[#-- @ftlvariable name="nextResults" type="java.lang.String" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Entity>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[#function sortColumn name]
  [#if s.sortFields?has_content && s.sortFields[0].name == name && s.sortFields[0].order == "asc"]
    [#return "sort-up"/]
  [#elseif s.sortFields?has_content && s.sortFields[0].name == name && s.sortFields[0].order == "desc"]
    [#return "sort-down"/]
  [/#if]
  [#return ""/]
[/#function]

[#-- Used by JavaScript to populate the query string <pre> --]
<input type="hidden" name="fullQuery" value='${(fullQuery!'')}'/>
[#-- If needed to populate the search after criteria for the backrooms --]
[@control.hidden name="nextResults"/]

[@search.pagination/]
<table class="hover" data-sortable="false">
  <thead>
    <tr>
      <th class="sortable ${sortColumn('name')}" data-sort="name,typeId,insertInstant"><a href="#">[@message.print key="name"/]</a></th>
      <th class="hide-on-mobile sortable ${sortColumn('id')}" data-sort="id,name,insertInstant"><a href="#">[@message.print key="id"/]</a></th>
      <th class="sortable ${sortColumn('typeId')}" data-sort="typeId,name,insertInstant"><a href="#">[@message.print key="type"/]</a></th>
      [#if tenants?size > 1]
        <th class="hide-on-mobile sortable ${sortColumn('tenantId')}" data-sort="tenantId,name,insertInstant"><a href="#">[@message.print key="tenant"/]</a></th>
      [/#if]
      <th class="hide-on-mobile sortable ${sortColumn('insertInstant')}" data-sort="insertInstant,name,typeId"><a href="#">[@message.print key="insertInstant"/]</a></th>
      <th class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
  [#list results![] as result]
    <tr>
      <td>${properties.display(result, "name")}</td>
      <td class="hide-on-mobile">${properties.display(result, 'id')}</td>
      <td>${properties.display(result, 'type.name')}</td>
      [#if tenants?size > 1]
        <td class="hide-on-mobile">${helpers.tenantName(result.tenantId)}</td>
      [/#if]
      <td class="hide-on-mobile">${properties.display(result, 'insertInstant')}</td>
      <td class="action">
         [@button.action href="/admin/entity/manage/${result.id}?tenantId=${result.tenantId}" icon="clone" key="manage" color="purple"/]
         [@button.action href="/admin/entity/edit/${result.id}?tenantId=${result.tenantId}" icon="edit" key="edit" color="blue"/]
         [@button.action href="/ajax/entity/view/${result.id}?tenantId=${result.tenantId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
         [@button.action href="/admin/entity/delete/${result.id}?tenantId=${result.tenantId}" icon="trash" key="delete" color="red"/]
      </td>
    </tr>
  [#else]
    <tr>
      <td colspan="6">[@message.print "no-entities"/]</td>
    </tr>
  [/#list]
  </tbody>
  </table>
[#if numberOfPages gt 1]
  [@search.pagination/]
[/#if]

[#if fieldMessages['queryString']?has_content]
  <div class="prime-dialog" id="search-errors">
    [@dialog.basic titleKey="bad-search" includeFooter=true]
      ${fieldMessages['queryString'][0]}
    [/@dialog.basic]
  </div>
[/#if]
