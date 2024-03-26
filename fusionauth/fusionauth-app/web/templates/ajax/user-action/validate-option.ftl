[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/locale.ftl" as locale/]
[#import "../../_utils/message.ftl" as message/]

[@dialog.form action="validate-option" formClass="labels-left full"]
  <fieldset>
    [@control.text name="name" autocapitalize="on" autocomplete="off" autocorrect="on" autofocus="autofocus" required=true/]
  </fieldset>
  <fieldset>
    <table id="localized-option-names" data-template="option-localization-template" data-add-button="add-localized-option-name" data-field="localizedNames">
      <thead>
      <tr>
        <th>[@message.print key="locale"/]</th>
        <th>[@message.print key="text"/]</th>
        <th data-sortable="false" class="action">[@message.print key="action"/]</th>
      </tr>
      </thead>
      <tbody>
      <tr class="empty-row">
        <td colspan="3">
          [@message.print key="no-localized-names"/]
        </td>
      </tr>
      [#list (localizedNames!{})?keys as l]
        <tr>
          <td>[@locale.select l/]</td>
          <td><input type="text" placeholder="[@message.print key="text"/]" name="localizedNames['${l}']" value="${(localizedNames(l))}"/></td>
          <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
        </tr>
      [/#list]
      </tbody>
    </table>
    [@button.iconLinkWithText color="blue" icon="plus" href="#" textKey="add-localization" id="add-localized-option-name"/]
    <script id="option-localization-template" type="text/x-handlebars-template">
      <tr>
        <td>[@locale.select ""/]</td>
        <td><input type="text" placeholder="[@message.print key="text"/]" name="{{field}}['${locales[0]}']"/></td>
        <td class="action">[@button.action icon="trash" color="red" key="delete" additionalClass="delete-button" href="#"/]</td>
      </tr>
    </script>
  </fieldset>
[/@dialog.form]