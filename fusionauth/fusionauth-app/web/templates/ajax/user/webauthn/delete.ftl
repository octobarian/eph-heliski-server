[#ftl/]
[#-- @ftlvariable name="credential" type="io.fusionauth.domain.WebAuthnCredential" --]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.form action="${request.contextPath}/ajax/user/webauthn/delete" id="webauthn-form" formClass="full"]
  [@control.hidden name="id"/]
  [@control.hidden name="userId"/]
  [@control.hidden name="tenantId"/]

  <fieldset>
    [@message.showAPIErrorRespones storageKey="io.fusionauth.webauthn.delete.errors"/]
    <p class="mt-0 mb-4">
      <em>[@message.print "{description}delete-webauthn-passkey"/]</em>
    </p>

    [@properties.table]
      [@properties.rowEval nameKey="displayName" object=credential propertyName="displayName"/]
      [@properties.rowEval nameKey="id" object=credential propertyName="id"/]
      [@properties.rowEval nameKey="identifier" object=credential propertyName="name"/]
      [@properties.rowEval nameKey="relyingPartyId" object=credential propertyName="relyingPartyId"/]
      [@properties.rowEval nameKey="insertInstant" object=credential propertyName="insertInstant"/]
      [@properties.rowEval nameKey="lastUseInstant" object=credential propertyName="lastUseInstant"/]
      [@properties.rowEval nameKey="signCount" object=credential propertyName="signCount"/]
      [@properties.rowEval nameKey="algorithm" object=credential  propertyName="algorithm"/]
    [/@properties.table]
  </fieldset>

[/@dialog.form]