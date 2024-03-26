[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="render" type="java.lang.String" --]

[#if render == "checkboxList"]

  [#if application.roles?has_content]
    <label for="registration_roles">[@control.message key="registration.roles"/]</label>
    <div id="registration_roles" class="checkbox-list taller">
      [#list application.roles as role]
        <div class="checkbox">
          <label class="checkbox">
            <input type="checkbox" id="registration.roles-${role_index}" name="registration.roles" data-super-role="${role.isSuperRole?string}" value="${role.name}"/>
            <span class="box"></span><span class="label">${role.display}</span>
          </label>
        </div>
      [/#list]
    </div>
    [#else]
      <label>[@control.message key="registration.roles"/]</label>
      <span>[@control.message key="no-roles"/]</span>
    [/#if]

[#elseif render == "options"]

   [#-- The caller should insert this HTML into an existing select element --]
   [#list application.roles as role]
     <option value="${role.name}">${role.name}</option>
   [/#list]

[/#if]
