[#ftl/]
[#-- @ftlvariable name="key" type="io.fusionauth.domain.Key" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#assign shadowKey = false/]
[#if key?has_content]
  [#assign shadowKey = fusionAuth.statics['io.fusionauth.api.service.system.KeyService'].ClientSecretShadowKeys.contains(key.id)/]
[/#if]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=key propertyName="name"/]
    [@properties.rowEval nameKey="id" object=key propertyName="id"/]
    [#if shadowKey]
      [@properties.rowEval nameKey="kid" object=key propertyName="doesNotExist"/]
    [#else]
      [@properties.rowEval nameKey="kid" object=key propertyName="kid"/]
    [/#if]
    [@properties.row nameKey="algorithm" value=key.algorithm?has_content?then(message.inline(key.algorithm), "\x2013") /]
    [#if !key.algorithm??]
      [@properties.row nameKey="type" value=message.inline(key.type.name()) /]
    [/#if]
    [@properties.row nameKey="use" value=message.inline(key.use()) /]
    [#if key.type == "HMAC"]
      [#if shadowKey]
        [@properties.row nameKey="secret" value=properties.display(key, "secret")/]
      [#else]
        [#assign reviewLink]
          [@control.form action="reveal" method="POST"]
            [@control.hidden name="keyId" value=key.id/]
            [@message.print key="hiddenSecret"/]
            <button class="text-link">[@message.print key="click-here"/]</button>
            [@message.print key="to-reveal"/]
          [/@control.form]
        [/#assign]
        [@properties.row nameKey="secret" value=reviewLink id="hmac-secret"/]
      [/#if]
    [#else]
      [#assign keyLength]${key.length} ${message.inline("bits")}[/#assign]
      [@properties.row nameKey="length" value=keyLength/]
    [/#if]
    [@properties.rowEval nameKey="insertInstant" object=key propertyName="insertInstant"/]
    [@properties.rowEval nameKey="lastUpdateInstant" object=key propertyName="lastUpdateInstant"/]
  [/@properties.table]

  [#if shadowKey]
    <h3>[@message.print key="{header}keyDescription"/]</h3>
    <fieldset class="ml-2 pr-3">
      <p>[@message.print key="{description}clientSecretShadowKey"/]</p>
    </fieldset>
  [/#if]

  [#if key.certificateInformation??]
    <h3>[@message.print key="certificate-information"/]</h3>
    [@properties.table]
      [@properties.rowEval nameKey="issuer" object=key propertyName="certificateInformation.issuer"/]
      [@properties.rowEval nameKey="subject" object=key propertyName="certificateInformation.subject"/]
      [@properties.rowEval nameKey="serial" object=key propertyName="certificateInformation.serialNumber"/]

      [@properties.rowEval nameKey="validFrom" object=key propertyName="certificateInformation.validFrom"/]
      [@properties.row nameKey="validTo" value=properties.displayZonedDateTime(key, "certificateInformation.validTo", "date-time-format", true) /]

      [@properties.rowEval nameKey="md5Fingerprint" object=key propertyName="certificateInformation.md5Fingerprint"/]
      [@properties.rowEval nameKey="sha1Fingerprint" object=key propertyName="certificateInformation.sha1Fingerprint"/]
      [@properties.rowEval nameKey="sha256Fingerprint" object=key propertyName="certificateInformation.sha256Fingerprint"/]

      [@properties.rowEval nameKey="sha1Thumbprint" object=key propertyName="certificateInformation.sha1Thumbprint"/]
      [@properties.rowEval nameKey="sha256Thumbprint" object=key propertyName="certificateInformation.sha256Thumbprint"/]
    [/@properties.table]
  [/#if]

  [#if key.certificate??]
    <h3>[@message.print key="{header}certificate"/]</h3>
    [@properties.table]
      <tr>
        <td class="top">
          [@message.print key="certificate"/]
          [@message.print key="propertySeparator"/]
        </td>
        <td><pre class="code not-pushed">${key.certificate}</pre></td>
      </tr>
      <tr>
        <td style="overflow: auto;" class="top">
          [@message.print key="certificateRaw"/]
          [@message.print key="propertySeparator"/]
        </td>
        <td>
          <div>
            <pre style="white-space: pre-wrap; word-break: break-word;" class="code not-pushed">${(key.certificate?replace("-----.+-----", "", "r")?replace("\n", "", "r"))}</pre>
          </div>
        </td>
      </tr>
    [/@properties.table]
    [/#if]

    [#if key.publicKey??]
    <h3>[@message.print key="{header}publicKey"/]</h3>
    [@properties.table]
      <tr>
        <td class="top">
          [@message.print key="publicKey"/]
          [@message.print key="propertySeparator"/]
        </td>
        <td><pre class="code not-pushed">${key.publicKey}</pre></td>
      </tr>
      <tr>
        <td style="overflow: auto;" class="top">
          [@message.print key="publicKeyRaw"/]
          [@message.print key="propertySeparator"/]
        </td>
        <td>
          <div>
            <pre style="white-space: pre-wrap; word-break: break-word;" class="code not-pushed">${(key.publicKey?replace("-----.+-----", "", "r")?replace("\n", "", "r"))}</pre>
          </div>
        </td>
      </tr>
    [/@properties.table]
    [/#if]

    [#-- If this is an asymetric key pair or we just have a private key from an asymetric key pair. --]
    [#if (key.publicKey?? && key.algorithm??) || (!key.publicKey?? && key.algorithm?? && !key.algorithm?starts_with("HS"))]
    <h3>[@message.print key="{header}privateKey"/]</h3>
    <p>[@message.print key="hiddenPrivateKey"/]</p>
    [/#if]
[/@dialog.view]
