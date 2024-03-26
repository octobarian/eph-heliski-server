[#ftl/]
[#-- @ftlvariable name="forms" type="java.util.List<io.fusionauth.domain.form.Form>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]

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
    [@layout.pageHeader titleKey="page-title" includeAdd=true breadcrumbs={"": "customizations", "/admin/form/": "forms"}/]
    [@layout.main]
      [@panel.full displayTotal=(forms![])?size]
        <table class="hover">
          <thead>
          <tr>
            <th><a href="#">[@message.print key="name"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
            <th><a href="#">[@message.print key="type"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list forms![] as form]
              <tr>
                <td>${properties.display(form, "name")}</td>
                <td class="hide-on-mobile">${properties.display(form, "id")}</td>
                <td>${properties.display(form, "type")}</td>
                <td class="action">
                  [@button.action href="edit/${form.id}" icon="edit" key="edit" color="blue"/]
                  [@button.action href="add?formId=${form.id}" icon="copy" key="duplicate" color="purple"/]
                  [@button.action href="/ajax/form/view/${form.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
                  [@button.action href="/ajax/form/delete/${form.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-forms"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
