[#ftl/]
[#-- @ftlvariable name="userAction" type="io.fusionauth.domain.UserAction" --]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro localizedTable values]
  [@properties.table]
    [#list values?keys as locale]
      [@properties.rowRaw name=locale.displayName value=values(locale)/]
    [/#list]
  [/@properties.table]
[/#macro]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=userAction propertyName="name"/]
    [@properties.rowEval nameKey="id" object=userAction propertyName="id"/]
    [@properties.rowEval nameKey="prevent-login" object=userAction propertyName="preventLogin" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="send-end-event" object=userAction propertyName="sendEndEvent" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="user-notifications-enabled" object=userAction propertyName="userNotificationsEnabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="insertInstant" object=userAction propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=userAction propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="localized-names"/]</h3>
  [#if userAction.localizedNames?has_content]
    [@localizedTable userAction.localizedNames/]
  [#else]
  <p>[@message.print "no-localized-names"/]</p>
  [/#if]

  <h3>[@message.print key="options"/]</h3>
  [#if userAction.options?has_content]
    <table class="properties">
      <tbody>
      [#list userAction.options as option]
        <tr>
          <td>
            ${option.name}
          </td>
          <td>
            [#if option.localizedNames?has_content]
              [@localizedTable option.localizedNames/]
            [/#if]
          </td>
        </tr>
      [/#list]
      </tbody>
    </table>
  [#else]
  <p>[@message.print "no-action-options"/]</p>
  [/#if]
[/@dialog.view]