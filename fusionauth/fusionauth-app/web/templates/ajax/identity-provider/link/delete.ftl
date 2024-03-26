[#ftl/]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider<?>" --]
[#-- @ftlvariable name="identityProviderUser" type="io.fusionauth.domain.IdentityProviderLink" --]
[#-- @ftlvariable name="identityProviderId" type="java.util.UUID" --]
[#-- @ftlvariable name="identityProviderUserId" type="java.lang.String" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.confirm action="delete" key="are-you-sure" idField="identityProviderId" idField2="identityProviderUserId" idField3="userId" ]
  <fieldset>
    [@properties.table]
      [@properties.rowEval nameKey="id" object=identityProviderUser!{} propertyName="identityProviderUserId"/]
      [@properties.rowEval nameKey="displayName" object=identityProviderUser!{} propertyName="displayName"/]
      [@properties.rowEval nameKey="identityProvider" object=identityProvider!{} propertyName="name"/]
      [@properties.rowEval nameKey="identityProviderId" object=identityProvider!{} propertyName="id"/]
    [/@properties.table]
  </fieldset>
[/@dialog.confirm]
