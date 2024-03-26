[#ftl/]
[#-- @ftlvariable name="identityProviderId" type="java.util.UUID" --]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="delete" method="POST" class="full" includeSave=true includeCancel=true cancelURI="/admin/identity-provider/" saveColor="red" saveKey="delete" saveIcon="trash" breadcrumbs={"": "settings", "/admin/identity-provider/": "identity-providers", "/admin/identity-provider/delete?identityProvider=${identityProvider.id}": "delete"}]
      [@message.print key="warning"/]
      <fieldset>
        [@properties.table]
          [@properties.rowEval nameKey="name" object=identityProvider propertyName="name"/]
          [@properties.rowEval nameKey="type" object=identityProvider propertyName="type"/]
          [@properties.rowEval nameKey="id" object=identityProvider propertyName="id"/]
          [#if identityProvider.domains??]
            [@properties.rowEval nameKey="domains" object=identityProvider propertyName="domains"/]
          [/#if]
         [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.hidden name="identityProviderId"/]
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
