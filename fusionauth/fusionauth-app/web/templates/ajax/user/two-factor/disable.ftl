[#ftl/]
[#-- @ftlvariable name="configuredMethods" type="java.util.List<io.fusionauth.domain.TwoFactorMethod>" --]
[#-- @ftlvariable name="method" type="java.lang.String" --]
[#-- @ftlvariable name="methodId" type="java.lang.String" --]
[#-- @ftlvariable name="methodValue" type="java.lang.String" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as twoFactorMacros/]

[#-- The Id is used to hook up the JS, so skip it if this is an admin disable, since the fields won't be here.  --]
[#assign formId = fusionAuth.has_one_role('admin')?then("", "two-factor-form")/]
[@dialog.form action="${request.contextPath}/ajax/user/two-factor/disable" id=formId formClass="full"]
  [@control.hidden name="method"/]
  [@control.hidden name="methodId"/]
  [@control.hidden name="userId"/]
  <div class="row">
    <div class="col-xs">
      <p class="mt-0 mb-4">
        <em>[@message.print "{description}disable-two-factor"/]</em>
      </p>

       [@properties.table]
         [@properties.row "method" message.inlineOptional(method, method) /]
          [#if method == "email" ]
            [@properties.row "email" methodValue /]
          [#elseif method == "sms"]
            [@properties.row "mobilePhone" methodValue /]
          [/#if]
         [@properties.row "methodId" methodId /]
       [/@properties.table]

      <fieldset>
        [#if fusionAuth.has_one_role('admin') ]
          <p> [@message.print "{description}admin-instructions"/] </p>
        [#else]
          [@twoFactorMacros.twoFactorFields "disable"/]
        [/#if]
      </fieldset>

    </div>
  </div>

[/@dialog.form]