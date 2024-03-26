[#ftl/]
[#-- @ftlvariable name="credential" type="io.fusionauth.domain.WebAuthnCredential" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="displayName" object=credential  propertyName="displayName"/]
    [@properties.rowEval nameKey="id" object=credential  propertyName="id"/]
    <tr>
      <td class="top">
        [@message.print key="name"/]&nbsp; <i class="fa fa-info-circle blue-text" data-tooltip="${message.inline('{tooltip}webauthn-name')}"></i>[@message.print key="propertySeparator"/]
      </td>
      <td>
        ${properties.display(credential, "name")}
      </td>
    </tr>
    [@properties.rowEval nameKey="relyingPartyId" object=credential  propertyName="relyingPartyId"/]
    [@properties.rowEval nameKey="insertInstant" object=credential  propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUseInstant" object=credential  propertyName="lastUseInstant"/]
    [@properties.rowEval nameKey="signCount" object=credential  propertyName="signCount"/]
    [@properties.rowEval nameKey="transports" object=credential  propertyName="transports"/]
    [@properties.rowEval nameKey="algorithm" object=credential  propertyName="algorithm"/]
    <tr>
      <td class="top">
        [@message.print key="publicKey"/]
        [@message.print key="propertySeparator"/]
      </td>
      <td>
        [#-- Unexpected.. but account for a null publicKey --]
        [#if credential.publicKey?has_content]
          <pre class="code not-pushed">${properties.display(credential, "publicKey")}</pre>
        [#else]
          ${"\x2013"}
        [/#if]
      </td>
    </tr>
  [/@properties.table]
[/@dialog.view]