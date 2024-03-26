[#ftl/]
[#-- @ftlvariable name="messageTemplates" type="java.util.List<io.fusionauth.domain.message.MessageTemplate>" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.MessageTemplateListing();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true  breadcrumbs={"": "customizations", "/admin/message/template/": "message-templates"}/]
    [@layout.main]
      [@panel.full]
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
            [#list messageTemplates![] as messageTemplate]
              <tr>
                <td>${properties.display(messageTemplate, "name")}</td>
                <td class="hide-on-mobile">${properties.display(messageTemplate, "id")}</td>
                <td>[@message.print "${messageTemplate.getType()}"/]</td>
                <td class="action">
                  [@button.action href="edit/${messageTemplate.id}" icon="edit" key="edit" color="blue"/]
                  [@button.action href="add?messageTemplateId=${messageTemplate.id}" icon="copy" key="duplicate" color="purple"/]
                  [@button.action href="/ajax/message/template/view/${messageTemplate.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
                  [@button.action href="/ajax/message/template/delete/${messageTemplate.id}" icon="trash" key="delete" color="red" ajaxForm=true/]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-message-templates"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]