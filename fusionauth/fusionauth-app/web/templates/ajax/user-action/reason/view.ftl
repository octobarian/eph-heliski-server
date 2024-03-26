[#ftl/]
[#-- @ftlvariable name="userActionReason" type="io.fusionauth.domain.UserActionReason" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

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
    [@properties.rowEval nameKey="text" object=userActionReason propertyName="text"/]
    [@properties.rowEval nameKey="id" object=userActionReason propertyName="id"/]
    [@properties.rowEval nameKey="code" object=userActionReason propertyName="code"/]
    [@properties.rowEval nameKey="insertInstant" object=userActionReason propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=userActionReason propertyName="lastUpdateInstant"/]
  [/@properties.table]

  <h3>[@message.print key="localized-texts"/]</h3>
  [#if (userActionReason.localizedTexts)?has_content]
    [@localizedTable userActionReason.localizedTexts/]
  [#else]
    <p>[@message.print "no-localized-texts"/]</p>
  [/#if]
[/@dialog.view]
