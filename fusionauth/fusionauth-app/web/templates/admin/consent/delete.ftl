[#ftl/]
[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/consent/"
                      saveColor="red" saveKey="delete" saveIcon="trash"
                      breadcrumbs={"": "settings", "/admin/consent/": "consent", "/admin/consent/delete/${consent.id}": "page-title"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=consent propertyName="name"/]
          [@properties.rowEval nameKey="id" object=consent propertyName="id"/]
        [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="consentId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" /]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]