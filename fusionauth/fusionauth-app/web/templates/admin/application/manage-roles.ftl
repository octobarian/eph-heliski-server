[#ftl/]

[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="systemConfiguration" type="io.fusionauth.domain.SystemConfiguration" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as applicationMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.ManageRolesForm();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true includeSave=false includeBack=true addURI="/ajax/application/add-role?applicationId=${applicationId}" backURI="/admin/application/" breadcrumbs={"/admin/application/": "applications", "/admin/application/manage-roles?applicationId=${applicationId}": "manage-roles"}]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full titleKey="roles-for" titleValues=[application.name]]
        <table>
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th>[@message.print key="id"/]</th>
            <th>[@message.print key="default"/]</th>
            <th>[@message.print key="superRole"/]</th>
            <th>[@message.print key="description"/]</th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list application.roles as role]
              <tr>
                <td>${properties.display(role, 'name')}</td>
                <td>${properties.display(role, 'id')}</td>
                <td>${properties.display(role, 'isDefault')}</td>
                <td>${properties.display(role, 'isSuperRole')}</td>
                <td>${properties.display(role, 'description')}</td>
                <td class="action">
                  [@button.action href="/ajax/application/edit-role?applicationId=${applicationId}&roleId=${role.id}" icon="edit" key="edit" color="blue" ajaxView=false ajaxForm=true ajaxWideDialog=true/]
                  [@button.action href="/ajax/application/delete-role?applicationId=${applicationId}&roleId=${role.id}" icon="trash" key="delete" color="red" ajaxView=false ajaxForm=true/]
                </td>
              </tr>
            [#else]
              <tr class="empty-row">
                <td colspan="5">[@message.print key="no-roles"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]