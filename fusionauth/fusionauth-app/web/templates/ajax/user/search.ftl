[#ftl/]
[#-- @ftlvariable name="fullQuery" type="java.lang.String" --]
[#-- @ftlvariable name="nextResults" type="java.lang.String" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[#assign readOnly = !(fusionAuth.has_one_role("admin", "user_manager", "user_support_manager"))/]

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
<table class="hover" data-user-table data-sortable="false">
  <thead>
  <tr>
    <th class="sortable icon ${sortColumn('login')}" data-sort="login,fullName">
      <label class="checkbox">
        <input type="checkbox">
        <span class="box"></span>
      </label>
      <a href="#">[@message.print key="login"/]</a>
    </th>
    <th class="hide-on-mobile sortable ${sortColumn('fullName')}" data-sort="fullName,email"><a href="#">[@message.print key="name"/]</a></th>
    <th class="hide-on-mobile sortable ${sortColumn('username')}" data-sort="username,email"><a href="#">[@message.print key="username"/]</a></th>
    [#if tenants?size > 1]
      <th class="hide-on-mobile sortable ${sortColumn('tenantId')}" data-sort="tenantId,email"><a href="#">[@message.print key="tenant"/]</a></th>
    [/#if]
    <th class="hide-on-mobile sortable ${sortColumn('insertInstant')}" data-sort="insertInstant,email"><a href="#">[@message.print key="insertInstant"/]</a></th>
    <th class="action">[@message.print key="action"/]</th>
  </tr>
  </thead>
  <tbody>
      [#list results![] as result]
      <tr>
        <td class="icon">
          <label class="checkbox">
            <input name="userId" type="checkbox" value="${result.id}"/>
            <span class="box"></span>
            [@helpers.avatar result/]
          </label>
          ${properties.display(result, "login")}
          [#if !result.active]<span class="small red stamp"><i class="fa fa-lock"></i> [@message.print key="locked"/]</span>[/#if]
        </td>
        <td class="hide-on-mobile">${properties.display(result, 'name')}</td>
        <td class="hide-on-mobile">${properties.display(result, 'uniqueUsername')}</td>
        [#if tenants?size > 1]
          <td class="hide-on-mobile">${helpers.tenantName(result.tenantId)}</td>
        [/#if]
        <td class="hide-on-mobile">${properties.display(result, 'insertInstant')}</td>
        <td class="action">
          [@button.action href="manage/${result.id}?tenantId=${result.tenantId}" icon="address-card-o" key="manage" color="purple"/]
          [#if !readOnly]
            [#if result.active]
              [#if result.id != ftlCurrentUser.id]
                [@button.action href="/ajax/user/deactivate/${result.id}?tenantId=${result.tenantId}" icon="unlock-alt" key="lock" color="green" ajaxForm=true/]
              [/#if]
            [#else]
              [@button.action href="/ajax/user/reactivate/${result.id}?tenantId=${result.tenantId}" icon="lock" key="unlock" color="red" ajaxForm=true/]
            [/#if]
          [/#if]
        </td>
      </tr>
    [#else]
    <tr>
      <td colspan="6">[@message.print key="no-users-found"/]</td>
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
