[#ftl/]
[#-- @ftlvariable name="reasons" type="java.util.List<io.fusionauth.domain.UserActionReason>" --]
[#-- @ftlvariable name="fusionAuthId" type="java.util.UUID" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as userActionReasonMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true includeBack=true backURI="/admin/user-action/" breadcrumbs={"": "settings", "/admin/user-action/": "user-actions", "/admin/user-action/reason/": "reasons"}/]
    [@layout.main]
      [@panel.full]
        <table class="hover">
          <thead>
          <tr>
            <th><a href="#">[@message.print key="text"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
            <th><a href="#">[@message.print key="code"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list reasons![] as userActionReason]
              <tr>
                <td>${userActionReason.text}</td>
                <td class="hide-on-mobile">${userActionReason.id}</td>
                <td>${userActionReason.code}</td>
                <td class="action">
                  [@button.action href="edit/${userActionReason.id}" icon="edit" color="blue" key="edit"/]
                  [@button.action href="/ajax/user-action/reason/view/${userActionReason.id}" icon="search" color="green" key="view" ajaxView=true ajaxWideDialog=true/]
                  [@button.action href="/ajax/user-action/reason/delete/${userActionReason.id}" icon="trash" color="red" key="delete" ajaxForm=true/]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-reasons"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]