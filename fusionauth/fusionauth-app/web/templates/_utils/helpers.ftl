[#ftl/]
[#-- @ftlvariable name="canEditRoles" type="boolean" --]
[#import "message.ftl" as message/]

[#-- Functions --]
[#function hashToAttributes hash]
  [#assign result = ""/]
  [#list hash?keys as key]
    [#assign result = result + " ${key?string?replace('_', '-')}=${hash[key]?string}"/]
  [/#list]
   [#-- Return an extra space to ensure it can but up against anything else --]
  [#return result  + " "]
[/#function]

[#-- Truncate the string at the max length and add a title tag if the length is exceeded. --]
[#macro truncate string maxLength default="\x2013"]
  [#if string?has_content]
    [#if string?length lte maxLength]
      ${string}
    [#else]
      <span title="${string}">${string?substring(0, maxLength - 1)}&hellip;</span>
    [/#if]
  [#else]
    ${default}
  [/#if]
[/#macro]

[#macro avatar user]
[#if user.imageUrl??]
  <img src="${user.imageUrl}" class="profile w-100" alt="profile image"/>
[#elseif user.lookupEmail()??]
  <img src="${function.gravatar(user.lookupEmail(), 200)}" class="profile w-100" alt="profile image"/>
[#else]
  <img src="${request.contextPath}/images/missing-user-image.svg" class="profile w-100" alt="profile image"/>
[/#if]
[/#macro]

[#-- Prefer [@control.select/] - use this if you don't need the backing portion of prime --]
[#macro select options=[] labelKey="" id="" attributes...]
[#if labelKey?has_content && labelKey != ""]
<label for="${id}">[@message.print key="${labelKey}"/]</label>
[/#if]
<label class="select">
  [#if attributes['leftAddon']?? || attributes['rightAddon']??]
  <div class="input-addon-group">
    [#if attributes['leftAddon']??]
      <span class="icon"><i class="fa fa-${attributes['leftAddon']}"></i></span>
    [/#if]
  [/#if]
  <select class="select" id="${id}">
    [#list options as option]
      <option value="${option}">${option}</option>
    [/#list]
  </select>
  [#if attributes['leftAddon']?? || attributes['rightAddon']??]
    [#if attributes['rightAddon']??]
      <span class="icon"><i class="fa fa-${attributes['rightAddon']}"></i></span>
    [/#if]
  </div>
  [/#if]
</label>
[/#macro]

[#macro fauxCheckbox name="" labelKey="" uncheckedValue="" includeFormRow=true id="" tooltip="" attributes...]
  [#local id=id?has_content?then(id, name)/]
  [#if includeFormRow]
<div [#if id?has_content]id="${id}-form-row"[/#if] class="form-row">
  [/#if]
  [#if labelKey!="empty" && (labelKey?has_content || name?has_content)]
    <label [#if id?has_content]for="${id}"[/#if]>[@message.print key=labelKey?has_content?then(labelKey, name)/]</label>
  [/#if]
  [#if name != ""]
  <input type="hidden" name="__cb_${name}" value="${uncheckedValue}"/>
  [/#if]
  <label class="toggle" [#if tooltip?has_content]data-tooltip="${tooltip}"[/#if]><input type="checkbox"[#if id?has_content] id="${id}"[/#if] ${hashToAttributes(attributes)}/><span class="rail"></span><span class="pin"></span></label>
  [#if includeFormRow]
</div>
  [/#if]
[/#macro]

[#macro booleanCheckboxList id name values=[] tooltip=""]
<div class="form-row">
  <label for="${id}">[@message.print key=name/]
  [#if tooltip??]
    <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>
  [/#if]
  </label>
  <div id="${id}" class="checkbox-list">
    [#list values as value]
      <div class="checkbox">
        <label class="checkbox">
          [#local fqName = name + "." + value/]
          <input type="hidden" name="__cb_${fqName}" value="false"/>
          [#local checkboxValue=("((" + fqName + ")!'')")?eval/]
          <input type="checkbox" value="true" name="${fqName}" [#if checkboxValue?? && checkboxValue]checked="checked"[/#if]>
          <span class="box"></span><span class="label">[@message.print key=fqName/]</span>
        </label>
      </div>
    [/#list]
  </div>
</div>
[/#macro]

[#macro customFormRow id="" labelKey="" required=false tooltip="" classes=""]
<div class="form-row ${classes}">
  [#if labelKey?has_content][#t/]
    <label for="${id}"[#if fieldMessages?size > 0 && fieldMessages?keys?seq_contains(labelKey)] class="error"[/#if]>[@message.print key=labelKey/][#if required]<span class="required">*</span>[/#if][#t/]
    [#if tooltip?has_content][#t/]
    <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>[#t/]
    [/#if][#t/]
    </label>[#t/]
  [#elseif labelKey == "empty"]
  <label></label>
  [/#if]
  <div class="inline-block">
    [#nested/]
  </div>
</div>
[/#macro]

[#macro fauxInput type name id="" value="" autocapitalize="none" autocomplete="on" autocorrect="off" autofocus=false labelKey="" placeholder="" leftAddon="" rightAddon="" rightAddonButton="" required=false tooltip="" disabled=false]
  [#local id=id?has_content?then(id, name)/]
<div class="form-row">
  [#if labelKey?has_content && labelKey!="empty"][#t/]
    <label for="${id}"[#if fieldMessages?size > 0 && fieldMessages?keys?seq_contains(labelKey)] class="error"[/#if]>[@message.print key=labelKey/][#if required]<span class="required">*</span>[/#if][#t/]
    [#if tooltip?has_content][#t/]
      <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>[#t/]
    [/#if][#t/]
    </label>[#t/]
  [/#if]
  [#if leftAddon?has_content || rightAddon?has_content || rightAddonButton?has_content]
    <div class="input-addon-group">
      [#if leftAddon?has_content]<span class="icon"><i class="fa fa-${leftAddon}"></i></span>[/#if]
  [/#if]
  <input id="${id}" type="${type}" name="${name}" [#if type != "password"]value="${value}"[/#if] autocapitalize="${autocapitalize}" autocomplete="${autocomplete}" autocorrect="${autocorrect}" [#if autofocus]autofocus="autofocus"[/#if] placeholder="${placeholder}" [#if disabled]disabled="disabled"[/#if]>

  [#if leftAddon?has_content || rightAddon?has_content || rightAddonButton?has_content]
     [#if rightAddon?has_content]${rightAddon}[/#if]
     [#if rightAddonButton?has_content]<a href="#" class="button blue">${rightAddonButton}</a>[#t/][/#if]
    </div>
  [/#if]
</div>
[/#macro]

[#function approximateFromMinutes minutes]
  [#if minutes <= 90] [#-- less than or equal to 90 minutes --]
    [#return  minutes + " " + function.message((minutes > 1)?then("MINUTES", "MINUTE"))/]
  [#elseif minutes < 2880] [#-- less than to 48 hours --]
    [#local hours = (minutes / (60))?string("##0")/]
    [#return ((minutes % 60) != 0)?then("~", "") + hours + " " + function.message(((minutes / 60) > 1)?then("HOURS", "HOUR"))/]
  [#else]
    [#local days = (minutes / (24 * 60))?string("##0")/]
    [#return ((minutes % (24 * 60)) != 0)?then("~", "") + days + " " + function.message(((minutes / (24 * 60)) > 1)?then("DAYS", "DAY"))/]
  [/#if]
[/#function]

[#function approximateFromSeconds seconds=0]
  [#if !seconds?has_content]
   [#return ""/]
  [/#if]
  [#if seconds < 120]
    [#return seconds + " " + function.message((seconds > 1)?then("SECONDS", "SECOND"))/]/]
  [#elseif seconds <= 5400] [#-- less than or equal to 90 minutes --]
    [#local minutes = (seconds / (60))?string("##0")/]
    [#return (seconds % (60) != 0)?then("~", "") + minutes + " " + function.message(((seconds / 60) > 1)?then("MINUTES", "MINUTE"))/]
  [#elseif seconds < 172800] [#-- less than to 48 hours --]
    [#local hours = (seconds / (60 * 60))?string("##0")/]
    [#return (seconds % (60 * 60) != 0)?then("~", "") + hours + " " + function.message(((seconds / (60 * 60)) > 1)?then("HOURS", "HOUR"))/]
  [#else]
    [#local days = (seconds / (24 * 60 * 60))?string("##0")/]
    [#return (seconds % (24 * 60 * 60) != 0)?then("~", "") + days + " " + function.message(((seconds / (24 * 60 * 60)) > 1)?then("DAYS", "DAY"))/]
  [/#if]
[/#function]

[#function approximateFromMilliSeconds milliseconds]
  [#if milliseconds < 1000]
    [#return milliseconds + " " + function.message((milliseconds > 1)?then("MILLISECONDS", "MILLISECOND"))/]/]
  [#else]
    [#local seconds = (milliseconds / (1000))?string("##0")/]
    [#return (milliseconds % (1000) != 0)?then("~", "") + seconds + " " + function.message(((milliseconds / 1000) > 1)?then("SECONDS", "SECOND"))/]
  [/#if]
[/#function]

[#function applicationName applications applicationId]
  [#list applications as application]
    [#if application.id == applicationId]
      [#return application.name/]
    [/#if]
  [/#list]
  [#return ""]
[/#function]

[#function tenantName tenantId]
  [#return tenants(tenantId).name/]
[/#function]

[#function tenantById tenantId]
  [#return tenants(tenantId)/]
[/#function]

[#macro errors field]
[#if fieldMessages[field]?has_content]
<span class="error">[#list fieldMessages[field] as message]${message?no_esc}[#if message_has_next], [/#if][/#list]</span>
[/#if]
[/#macro]

[#function isFieldReadOnly field action editingYourself]
  [#local key = field.key/]
  [#local readOnly = false/]
  [#--
      Unless you have 'admin' or 'user_manager' - there are restrictions for email, username, password registration roles.
       - User edit: Cannot modify username, email or password, unless editing yourself.
       - Registration Add : Cannot add roles, you only get "default" roles assigned to the application.
       - Registration Edit : Cannot modify roles.
   --]
  [#if ((key == "user.username" || key == "user.email" || key == "user.password") && action == "edit") || key == "registration.roles"]
    [#local readOnly = !(fusionAuth.has_one_role("admin", "user_manager")) /]
  [/#if]

  [#-- You can always edit your own email or username --]
  [#if (key == "user.username" || key == "user.email") && action == "edit" && editingYourself]
    [#local readOnly = false/]
  [/#if]

  [#return readOnly/]
[/#function]

[#macro customField field confirm=false autofocus=false readOnly=false action=""]
  [@customFieldDetail field field.key autofocus readOnly action/]
  [#if field.confirm]
    [@customFieldDetail field "confirm.${field.key}" false readOnly action/]
  [/#if]
[/#macro]

[#macro customFieldDetail field key autofocus=false readOnly=false action="" placeholder=""]
  [#local fieldId = field.key?replace(".", "_") /]
  [#local placeholderKey = "{placeholder}${key}" /]
  [#local placeholder = theme.optionalMessage(placeholderKey) /]
  [#if placeholderKey == placeholder]
    [#local placeholder = "" /]
  [/#if]
  [#local tooltipKey = "{tooltip}${key}" /]
  [#local tooltip = theme.optionalMessage(tooltipKey) /]
  [#if tooltipKey == tooltip]
    [#local tooltip = "" /]
  [/#if]
  [#if readOnly]
    [#local tooltip = theme.optionalMessage("{tooltip}readOnly")/]
  [/#if]

  [#local leftAddon = field.data.leftAddon!'info' /]
  [#if field.control == "checkbox"]
    [#if key == "registration.roles"]
      [@roles field key tooltip/]
    [#-- checkbox type must have options as enforced by the API   --]
    [#elseif field.options?has_content && field.options?size > 1]
      [#if field.type == "bool"]
        [#-- When bool, we will have at most, two value [true & false]. 'true' will always be checked and 'false' will always be unchecked.  --]
        [@control.checkbox id="${fieldId}" name="${key}" value="true" uncheckedValue="false" required=field.required autofocus=autofocus labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
      [#else]
        [@control.checkbox_list id="${fieldId}" name="${key}" required=field.required autofocus=autofocus items=fusionAuth.convert_themed_field_options(field, theme) labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
      [/#if]
    [#else]
      [#-- Checkbox with only 1 option--]
      [@control.checkbox id="${fieldId}" name="${key}" value=field.options.get(0) required=field.required autofocus=autofocus labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
    [/#if]
  [#elseif field.control == "number"]
    [@control.number id="${fieldId}" name="${key}" required=field.required autofocus=autofocus placeholder=placeholder labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
  [#elseif field.control == "password"]
    [@control.password id="${fieldId}" type="password" name="${key}" autocomplete="new-password" autofocus=autofocus labelValue="${theme.optionalMessage(key)}" placeholder=placeholder tooltip="${tooltip}"/]
  [#elseif field.control == "radio"]
    [@control.radio_list id="${fieldId}" name="${key}" required=field.required autofocus=autofocus items=fusionAuth.convert_themed_field_options(field, theme) labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
  [#elseif field.control == "select"]
    [#if key == "user.preferredLanguages" || key == "registration.preferredLanguages"]
      [@control.locale_select multiple=true name="${key}" labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
    [#elseif key == "user.timezone" || key == "registration.timezone"]
      [@control.select items=timezones name="${key}" headerValue="" headerL10n="no-timezone-selected" labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
    [#else]
      [@control.select id="${fieldId}" name="${key}" required=field.required autofocus=autofocus items=fusionAuth.convert_themed_field_options(field, theme) labelValue="${theme.optionalMessage(key)}" tooltip="${tooltip}"/]
    [/#if]
  [#elseif field.control == "textarea"]
    [@control.textarea id="${fieldId}" name="${key}" required=field.required autofocus=autofocus labelValue="${theme.optionalMessage(key)}" placeholder=placeholder tooltip="${tooltip}" class="textarea resize vertical"/]
  [#elseif field.control == "text"]
    [#if field.type == "date"]
      [@control.text id="${fieldId}" type="text" name="${key}" required=field.required autofocus=autofocus class="date-picker" _dateTimeFormat="[M/d/yyyy][MM/dd/yyyy][M/dd/yyyy][MM/d/yyyy]" data_date_only=true labelValue="${theme.optionalMessage(key)}" placeholder=placeholder tooltip="${tooltip}"/]
    [#else]
       [#-- Add autocomplete="username|email" to username or email controls. --]
       [#if key == "user.username" || key == "user.email" || key == "registration.username"]
         [#local autCompleteValue = key?substring((key?index_of(".") + 1)) /]
         [@control.text id="${fieldId}" type="text" name="${key}" required=field.required autofocus=autofocus labelValue="${theme.optionalMessage(key)}" placeholder=placeholder tooltip="${tooltip}" disabled=readOnly autocomplete="${autCompleteValue}"/]
       [#else]
         [@control.text id="${fieldId}" type="text" name="${key}" required=field.required autofocus=autofocus labelValue="${theme.optionalMessage(key)}" placeholder=placeholder tooltip="${tooltip}" disabled=readOnly /]
       [/#if]
    [/#if]
  [/#if]
[/#macro]

[#macro roles field key tooltip]
  <div id="application-roles" class="form-row" data-disabled="${(!canEditRoles)?c}">
  [#if field.options?has_content]
    <label for="registration_roles">
      ${theme.optionalMessage(key)}
      [#if tooltip?? && tooltip?has_content]
      <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>
      [/#if]
    </label>
   [#-- Full height checkbox list --]
    <div id="registration_roles" class="checkbox-list" style="max-height: 100%;">
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
  </div>
[/#macro]

[#macro tableHeader property class="" sortType="string"]
[#if (s.orderBy!"")?contains(property)]
[#local direction = (s.orderBy!"")?contains(" desc")?then('sort-down', 'sort-up') /]
[/#if]
<th class="sortable ${direction!''} ${class!''}">[#rt/]
  <a href="?s.orderBy=${property}[#if (s.orderBy!"")?contains(property + " desc")]+asc[#else]+desc[/#if]" data-sort-type="${sortType}">[@message.print key=property/]</a>[#t/]
</th>[#rt/]
[/#macro]