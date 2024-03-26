[#ftl/]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.IPAccessControlList>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      const form = Prime.Document.queryById('ip-acl-form');
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.ip-acl.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/ip-acl/": "ip-acls"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="ip-acl-form" action="${request.contextPath}/admin/ip-acl/" method="GET" class="labels-above full push-bottom" searchResults="ip-acl-results"]
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
              [@button.iconLinkWithText href="/admin/ip-acl/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="ip-acl-results">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="hover listing" data-sortable="false">
              <thead>
              <tr>
                [@helpers.tableHeader property="name"/]
                [@helpers.tableHeader class="hide-on-mobile" property="id"/]
                <th class="hide-on-mobile">[@message.print key="acl-entries"/]</th>
                <th data-sortable="false" class="action">[@message.print key="action"/]</th>
              </tr>
              </thead>
              <tbody>
                [#list results![] as ipAccessControlList]
                  <tr>
                    <td>${properties.display(ipAccessControlList, "name")}</td>
                    <td class="hide-on-mobile">${properties.display(ipAccessControlList, "id")}</td>
                    <td class="hide-on-mobile">${properties.displayNumber(ipAccessControlList, "entries")}</td>
                    <td class="action">
                      [@button.action href="/admin/ip-acl/edit/${ipAccessControlList.id}" icon="edit" key="edit" color="blue"/]
                      [@button.action href="/admin/ip-acl/add/${ipAccessControlList.id}" icon="copy" key="duplicate" color="purple"/]
                      [@button.action href="/ajax/ip-acl/test/${ipAccessControlList.id}" icon="flask" key="test" color="purple" ajaxWideDialog=true ajaxForm=true /]
                      [@button.action href="/ajax/ip-acl/view/${ipAccessControlList.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
                      [@button.action href="/ajax/ip-acl/delete/${ipAccessControlList.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                    </td>
                  </tr>
                [#else]
                  <tr>
                    <td colspan="4">[@message.print key="no-acl-entries"/]</td>
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
