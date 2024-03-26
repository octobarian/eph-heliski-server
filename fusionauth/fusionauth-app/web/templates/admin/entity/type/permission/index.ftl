[#ftl/]

[#-- @ftlvariable name="entityType" type="io.fusionauth.domain.EntityType" --]
[#-- @ftlvariable name="entityTypeId" type="java.util.UUID" --]

[#import "../../../../_utils/button.ftl" as button/]
[#import "../../../../_layouts/admin.ftl" as layout/]
[#import "../../../../_utils/message.ftl" as message/]
[#import "../../../../_utils/panel.ftl" as panel/]
[#import "../../../../_utils/properties.ftl" as properties/]
[#import "../_macros.ftl" as entityTypeMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.PermissionsForm();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true includeSave=false includeBack=true addURI="/ajax/entity/type/permission/add?entityTypeId=${entityTypeId}" backURI="/admin/entity/type/" breadcrumbs={"": "entity-management", "/admin/entity/type/": "entity-types", "/admin/entity/type/permission/?entityTypeId=${entityTypeId}": "manage-permissions"}]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full displayTotal=entityType.permissions?size displayTotalItemsKey="permissions" titleKey="permissions-for" titleValues=[entityType.name]]
        <table>
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th>[@message.print key="default"/]</th>
            <th>[@message.print key="description"/]</th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list entityType.permissions as permission]
              <tr>
                <td>${properties.display(permission, 'name')}</td>
                <td>${properties.display(permission, 'isDefault')}</td>
                <td>${properties.display(permission, 'description')}</td>
                <td class="action">
                  [@button.action href="/ajax/entity/type/permission/edit?entityTypeId=${entityTypeId}&permissionId=${permission.id}" icon="edit" key="edit" color="blue" ajaxView=false ajaxForm=true ajaxWideDialog=true/]
                  [@button.action href="/ajax/entity/type/permission/delete?entityTypeId=${entityTypeId}&permissionId=${permission.id}" icon="trash" key="delete" color="red" ajaxView=false ajaxForm=true/]
                </td>
              </tr>
            [#else]
              <tr class="empty-row">
                <td colspan="5">[@message.print key="no-permissions"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]