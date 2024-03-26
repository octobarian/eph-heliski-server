[#ftl/]
[#-- @ftlvariable name="fullQuery" type="java.lang.String" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.EntityGrant>" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.EntityGrantSearchCriteria" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/search.ftl" as search/]

[#assign readOnly = !(fusionAuth.has_one_role("admin", "entity_manager", "user_manager", "user_support_manager"))/]

[#function sortColumn name]
  [#if s.orderBy?has_content && s.orderBy?contains(name) && s.orderBy?contains("asc")]
    [#return "sort-up"/]
  [#elseif s.orderBy?has_content && s.orderBy?contains(name) && s.orderBy?contains("desc")]
    [#return "sort-down"/]
  [/#if]
  [#return ""/]
[/#function]

[@search.pagination/]
<table class="hover" data-sortable="false">
  <thead>
    <tr>
      <th>[@message.print key="id"/]</th>
      <th class="sortable ${sortColumn('name')}" data-sort="name"><a href="#">[@message.print key="entityName"/]</a></th>
      <th>[@message.print key="entityType"/]</th>
      <th>[@message.print key="entityId"/]</th>
      <th class="${sortColumn('permissions')}">[@message.print key="permissions"/]</th>
      <th class="sortable ${sortColumn('insertInstant')}" data-sort="insertInstant"><a href="#">[@message.print key="insertInstant"/]</a></th>
      <th class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
  [#list results![] as result]
    <tr>
      <td>${properties.display(result, 'id')}</td>
      <td>${properties.display(result, "entity.name")}</td>
      <td>${properties.display(result, 'entity.type.name')}</td>
      <td>${properties.display(result, 'entity.id')}</td>
      <td>${properties.display(result, 'permissions')}</td>
      <td>${properties.display(result, 'insertInstant')}</td>
      <td class="action">
        [#if !readOnly]
          [@button.action href="/admin/entity/grant/upsert?entityId=${result.entity.id}&grant.userId=${result.userId!''}&grant.recipientEntityId=${result.recipientEntityId!''}&tenantId=${result.entity.tenantId}" icon="edit" key="edit" color="blue"/]
          [@button.action href="/ajax/entity/grant/delete?entityId=${result.entity.id}&userId=${result.userId!''}&recipientEntityId=${result.recipientEntityId!''}" icon="trash" key="delete" color="red" ajaxForm=true/]
        [/#if]
      </td>
    </tr>
  [#else]
    <tr>
      <td colspan="7">[@message.print "no-entities"/]</td>
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
