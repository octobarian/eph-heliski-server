[#ftl/]
[#-- @ftlvariable name="expires" type="java.lang.Boolean" --]
[#-- @ftlvariable name="expiryUnits" type="io.fusionauth.domain.ExpiryUnit[]" --]

[#--
  Includes the expiration radio button choices for expires/indefinte and inputs for the value and unit of the expiration
--]
[#macro expirationControls]
  <div id="expiration-controls">
    [@control.checkbox name="expires" value="true" uncheckedValue="false"/]
    <div id="expiration-values">
      [@control.text name="expiryValue" autocapitalize="none" autocomplete="off" autocorrect="off"/]
      [@control.select items=expiryUnits name="expiryUnit"/]
    </div>
  </div>
[/#macro]