[#ftl/]
[#-- @ftlvariable name="recoveryCodes" type="java.util.List<java.lang.String>" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as twoFactorMacros/]

[@dialog.form titleKey="recovery-code-title" action="${request.contextPath}/ajax/user/two-factor/enable" formClass="full" includeFooter=false]
  [@control.hidden name="action" value="complete"/]
  <div class="row">
    <div class="col-xs">
      <fieldset>
        <p> [@message.print key="{description}recovery-codes-1" values=[recoveryCodes?size] /] </p>
      </fieldset>
      <fieldset>
        <div class="code d-flex" style="justify-content: center; flex-wrap: wrap; gap: 5px 15px; width: 250px;">
          [#list recoveryCodes as code]<div>${code}</div>[/#list]
        </div>
      </fieldset>
      <fieldset>
        <p> [@message.print key="{description}recovery-codes-2"/] </p>
      </fieldset>
    </div>
  </div>
  <footer>
    [@button.formIcon icon="check" color="blue" textKey="done" /]
  </footer>
[/@dialog.form]
