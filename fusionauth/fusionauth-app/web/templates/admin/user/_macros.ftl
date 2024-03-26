[#ftl/]
[#setting url_escaping_charset="UTF-8"]
[#-- @ftlvariable name="applications" type="java.util.Map<UUID, io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="availableTwoFactorMethods" type="java.util.List<java.lang.String>" --]
[#-- @ftlvariable name="consentsAvailable" type="boolean" --]
[#-- @ftlvariable name="editPasswordOption" type="io.fusionauth.app.service.user.CustomFormFrontendService.EditPasswordOption" --]
[#-- @ftlvariable name="families" type="java.util.List<io.fusionauth.domain.Family>" --]
[#-- @ftlvariable name="fields" type="java.util.Map<java.lang.Integer, java.util.List<io.fusionauth.domain.form.FormField>>" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="identityProviderLinks" type="java.util.List<io.fusionauth.domain.IdentityProviderLink>" --]
[#-- @ftlvariable name="identityProviders" type="java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider<?>>" --]
[#-- @ftlvariable name="managedFields" type="java.util.List<String>" --]
[#-- @ftlvariable name="membershipsAvailable" type="boolean" --]
[#-- @ftlvariable name="refreshTokens" type="java.util.List<io.fusionauth.domain.jwt.RefreshToken>" --]
[#-- @ftlvariable name="registrationsAvailable" type="boolean" --]
[#-- @ftlvariable name="sendSetPasswordEmail" type="boolean" --]
[#-- @ftlvariable name="systemConfiguration" type="io.fusionauth.domain.SystemConfiguration" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="thisSession" type="java.lang.String" --]
[#-- @ftlvariable name="thisSSOSessionId" type="java.lang.String" --]
[#-- @ftlvariable name="timezones" type="java.util.SortedSet<java.lang.String>" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="userConsents" type="java.util.List<io.fusionauth.domain.UserConsent>" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#-- @ftlvariable name="users" type="java.util.Map<java.util.UUID, io.fusionauth.domain.User>" --]
[#-- @ftlvariable name="webAuthnCredentials" type="java.util.List<io.fusionauth.domain.WebAuthnCredential>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/passwords.ftl" as passwords/]
[#import "../../_utils/properties.ftl" as properties/]

[#assign canVerifyEmail = fusionAuth.has_one_role("admin", "user_manager")/]

[#macro passwordFields isOpen tenantId]
  [#-- See recommended autocomplete values:  https://www.chromium.org/developers/design-documents/form-styles-that-chromium-understands --]
  [#nested]
  <div id="password-fields" class="slide-open [#if isOpen]open[/#if]">
    [@helpers.customFormRow labelKey="empty"]
      [@passwords.rules tenants(tenantId).passwordValidationRules tenantId/]
    [/@helpers.customFormRow]

    [#-- Setting autocomplete to "new-password" because we never want these fields auto-completed by the browser or password manager--]
    [@control.password name="user.password" required=true autocomplete="new-password"/]
    [@control.password name="confirm.user.password" required=true autocomplete="new-password"/]
  </div>
[/#macro]

[#macro data]
  [#if user.hasUserData()]
    [#--User Data--]
    [#if user.data?has_content]
    <fieldset>
      [@fusionAuth.flatten_data data=user.data; name, value]
        [@properties.definitionList key=name value=value horizontal=true translateKey=false/]
      [/@fusionAuth.flatten_data]
    </fieldset>
    [/#if]

    [#--Registration Custom Data--]
    [#list user.registrations as registration]
      [#if registration.data?has_content]
      <fieldset>
        <legend>${applications(registration.applicationId).name}</legend>
        <div>
          [@fusionAuth.flatten_data data=registration.data; name, value]
            [@properties.definitionList key=name value=value horizontal=true translateKey=false/]
          [/@fusionAuth.flatten_data]
        </div>
      </fieldset>
      [/#if]
    [/#list]

  [#else]
    [@message.print key="no-user-data"/]
  [/#if]
[/#macro]

[#function generateSectionLabel sectionNumber tenantId]
  [#--  Tenant specific, not tenant specific, then default --]
  [#local sectionLabel = theme.optionalMessage("[${tenantId}]{user-form-section}${sectionNumber}")/]
  [#local resolvedLabel = sectionLabel != "[${tenantId}]{user-form-section}${sectionNumber}"/]
  [#if !resolvedLabel]
    [#local sectionLabel = theme.optionalMessage("{user-form-section}${sectionNumber}")/]
    [#local resolvedLabel = sectionLabel != "{user-form-section}${sectionNumber}"/]
  [/#if]
  [#if !resolvedLabel]
    [#if sectionNumber > 1]
      [#return '${message.inline("user-form-section")} ${sectionNumber}'/]
    [#else]
      [#return ""/]
    [/#if]
  [#else]
    [#return sectionLabel /]
  [/#if]
[/#function]

[#macro userFormFields action]
  [#local openFieldSet = true/]
  <fieldset>
    [#if action == "edit"]
      [@control.hidden name="userId"/]

      [#-- Tenant --]
      [@control.hidden name="tenantId" value=user.tenantId/]
      [#if tenants?size > 1]
        [#-- Use an empty name so we don't end up with duplicate Ids in the DOM --]
        [@control.text name="" labelKey="tenant" value=helpers.tenantName(user.tenantId) autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
      [/#if]
    [/#if]

    [#-- If you do not have the option to add and email address, don't show the toggle to send the user a setup password email. --]
    [#local showSetupPasswordToggle = false]
    [#if action == "add" ]
      [#list fields?values as fieldValues]
        [#list fieldValues as fieldValue]
          [#if fieldValue.key == "user.email"]
            [#local showSetupPasswordToggle = true]
            [#break]
          [/#if]
        [/#list]
      [/#list]
    [/#if]

    [#if fields?has_content]
      [#list fields as fieldKey, fieldValues]

        [#local sectionNumber = fieldKey + 1/]
        [#local sectionLabel = generateSectionLabel(sectionNumber, tenantId) /]
        [#if openFieldSet && tenants?size > 1]
          </fieldset>
          [#local openFieldSet = false/]
        [/#if]

        [#if !openFieldSet]
        <fieldset>
        [/#if]
        [#-- Close the field set for sure by the time we get here --]
        [#local openFieldSet = false/]

        [#-- If you're editing yourself provide a description of how the language and timezone can be used in the FusionAuth UI --]
        [#local showLocalEditInfo = false]
        [#if action == "edit" && ftlCurrentUser.id == userId]
          [#list fieldValues as fieldValue]
            [#if fieldValue.key == "user.timezone" || fieldValue.key == "user.preferredLanguages"]
              [#local showLocalEditInfo = true]
              [#break]
            [/#if]
          [/#list]
        [/#if]

        [#if sectionLabel?has_content]
        <legend> ${sectionLabel} </legend>
          [#if showLocalEditInfo]
            <p><em>[@message.print key="{description}fusionauth-user"/]</em></p>
          [/#if]
        [/#if]


        [#list fieldValues as fieldValue]
          [#local setAutoFocus = fieldKey?is_first && fieldValue?is_first/]
          [#local fieldIsReadOnly = helpers.isFieldReadOnly(fieldValue, action, (ftlCurrentUser.id == userId!''))/]
          [#-- If a managed field that has additional properties/configuration not supported by the generic helpers.customField macro, specify here--]
          [#if managedFields.contains(fieldValue.key)]
            [#if fieldValue.key == "user.password"]
              [@passwordField action=action tenantId=tenantId readOnly=fieldIsReadOnly showSetupPasswordToggle=showSetupPasswordToggle/]
            [#elseif fieldValue.key == "user.twoFactorEnabled"]
              [#-- Field is deprecated, if it shows up - do nothing, nothing to show. --]
            [#elseif fieldValue.key == "user.email"]
              [@emailField fieldValue setAutoFocus fieldIsReadOnly action /]
            [#else]
              [@helpers.customField fieldValue fieldValue.confirm setAutoFocus fieldIsReadOnly action/]
            [/#if]
          [#else]
            [#if fieldValue.key == "user.twoFactorEnabled"]
              [#-- Field is deprecated, if it shows up - do nothing, nothing to show. --]
            [#else]
              [@helpers.customField fieldValue fieldValue.confirm setAutoFocus fieldIsReadOnly action/]
            [/#if]
          [/#if]
        [/#list]
       </fieldset>
      [/#list]
    [/#if]
[/#macro]

[#macro passwordField action tenantId readOnly showSetupPasswordToggle]
  [#-- Always show the password stuff, we'll validate it based upon the tenant selected during an add --]
  [#local isOpen = (action == "add" && (!sendSetPasswordEmail || !showSetupPasswordToggle)) || (action == "edit" && editPasswordOption == "update")/]
  <fieldset>
    [@passwordFields isOpen tenantId]
      [#if action == "add"]
        [#if showSetupPasswordToggle]
          [@control.checkbox name="sendSetPasswordEmail" value="true" uncheckedValue="false" data_slide_open="password-fields" data_slide_open_inverted=true/]
        [#else]
          [@control.hidden name="sendSetPasswordEmail" value="false"/]
        [/#if]
      [#elseif action == "edit"]
        [#if ftlCurrentUser.id == userId]
          [#-- Editing yourself --]
          [@control.checkbox name="editPasswordOption" value="update" uncheckedValue="useExisting" data_slide_open="password-fields"/]
        [#else]
          [#-- Editing another user --]
          [#if readOnly]
            [@control.select items=editPasswordOptionsSupportManager name="editPasswordOption"/]
          [#else]
            [@control.select items=editPasswordOptions name="editPasswordOption"/]
          [/#if]
        [/#if]
      [/#if]
    [/@passwordFields]
  </fieldset>
[/#macro]

[#macro emailField fieldValue setAutoFocus fieldIsReadOnly action]
  [#local verifyEnabledForAction = (action == "add" && tenants(tenantId).emailConfiguration.verifyEmail) || (action == "edit" && tenants(tenantId).emailConfiguration.verifyEmailWhenChanged) /]
  [#if verifyEnabledForAction]
    [#if canVerifyEmail]
      [#-- If the user has permission to verify email, let them decide whether to skip verification --]
      [@control.checkbox name="skipEmailVerification" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}skipEmailVerification')/]
    [#else]
      [#-- If user does not have permission to verify email, then require verification when enabled --]
      [@control.hidden name="skipEmailVerification" value="false"/]
    [/#if]
  [#else]
    [#-- If email verification is disabled for the current action, or email has not changed, do not require verification --]
    [@control.hidden name="skipEmailVerification" value="true"/]
  [/#if]
  [@helpers.customField fieldValue fieldValue.confirm setAutoFocus fieldIsReadOnly action/]
[/#macro]

[#macro details readOnly=false]
<div class="row push-bottom user-details">
  <div class="col-xs-12 col-md-5 col-lg-3 tight-left tight-right">
    <div class="avatar">
      <div>[@helpers.avatar user/]</div>
      <div>
        [#if user.name??]
          ${user.name}
        [#elseif user.uniqueUsername??]
          ${user.uniqueUsername}
        [/#if]
      </div>
    </div>
  </div>
  <div class="col-xs-12 col-md-7 col-lg-9 tight-left">

    <div class="row">
      <div class="col-xs-12 col-md-12">
        [#local verified = user.verified/]
        [#-- If user has no email hide the verification icon --]
        [#if user.lookupEmail()??]
          [@properties.definitionList key="email" value="${user.lookupEmail()!''}" horizontal=true iconToolTipKey="email-verified-${verified?string}" icon="${verified?then('check', 'question-circle-o')}" iconColor="${verified?then('green', 'orange')}"/]
        [#else]
          [@properties.definitionList key="email" value="" horizontal=true/]
        [/#if]
        [@properties.definitionList key="user-id" value="${user.id}" horizontal=true /]
        [#if tenants?size > 1]
          [@properties.definitionList key="tenant" value="${helpers.tenantName(user.tenantId)}" horizontal=true /]
        [/#if]
      </div>
    </div>

    <div class="row">

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="mobilePhone" value="${properties.phoneNumber(properties.display(user, 'mobilePhone'))}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [#if user.birthDate??]
          [@properties.definitionList key="birth-date" value="${function.format_local_date(user.birthDate, function.message('date-format'))} (${user.age})"/]
        [#else]
          [@properties.definitionList key="birth-date" value=""/]
        [/#if]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="username" value=properties.display(user, "uniqueUsername") /]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="preferred-languages" value="${fusionAuth.display_locale_names((user.preferredLanguages)![])}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="created" value="${function.format_zoned_date_time(user.insertInstant, function.message('date-time-format'), zoneId)}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="last-login" value="${(user.lastLoginInstant??)?then(function.format_zoned_date_time(user.lastLoginInstant, function.message('date-time-format'), zoneId), '')}" /]
      </div>

      [#if user.breachedPasswordStatus?? && user.breachedPasswordStatus != "None"]
        <div class="col-xs-12 col-md-4">
          [@properties.definitionList key="breach-detected" value=properties.display(user, "breachedPasswordLastCheckedInstant") /]
        </div>
      [/#if]

    </div>
  </div>
  <div class="panel-actions">
    <div class="status">
      [#if readOnly]
        [#-- Read only, show icon only --]
        [#if user.active]
        <a class="icon green disabled" disabled data-tooltip="${message.inline('account-unlocked-read-only')}"><i class="fa fa-unlock-alt"></i></a>
        [#else]
        <a class="icon red disabled" disabled data-tooltip="${message.inline('account-locked-read-only')}"><i class="fa fa-lock"></i></a>
        [/#if]
      [#else]
        [#if user.active]
          [#if user.id != ftlCurrentUser.id]
            [@button.ajaxLink href="/ajax/user/deactivate/${user.id}" color="green" icon="unlock-alt" tooltipKey="account-unlocked" additionalClass="icon" ajaxForm=true/]
          [#else]
            <a class="icon green" data-tooltip="${message.inline('account-unlocked-current-user')}"><i class="fa fa-unlock-alt"></i></a>
          [/#if]
        [#else]
          [@button.ajaxLink href="/ajax/user/reactivate/${user.id}" color="red" icon="lock" tooltipKey="account-locked" additionalClass="icon" ajaxForm=true/]
        [/#if]
      [/#if]
    </div>
  </div>
</div>
[/#macro]

[#macro currentActionsTable]
<table class="hover">
  <thead class="light-header">
    <tr>
      <th>[@message.print key="action"/]</th>
      <th class="hide-on-mobile">[@message.print key="comment"/]</th>
      <th class="instant">[@message.print key="start"/]</th>
      <th class="instant">[@message.print key="expiration"/]</th>
      <th class="hide-on-mobile">[@message.print key="actioning-user"/]</th>
      <th class="hide-on-mobile">[@message.print key="actioning-user-id"/]</th>
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
    [#if actions?? && actions?size > 0]
      [#assign active_count = 0/]
      [#list actions as action]
        [#if action.active]
          [#assign active_count = active_count + 1]
        <tr>
          <td>
            ${properties.display(action, 'name')}
            [#if action.localizedReason??]
              [${properties.display(action, 'localizedReason')}]
            [#elseif action.reason??]
              [${properties.display(action, 'reason')}]
            [/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(action, 'comment')}</td>
          <td class="instant">${function.format_zoned_date_time(action.insertInstant, function.message('date-time-format'), zoneId)}</td>
          <td class="instant">
            [#if action.expiry??]
              [#if function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)?contains('+292278994')]
                [@message.print key="indefinite"/]
              [#else]
              ${function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)}
              [/#if]
            [#else]
              &ndash;
            [/#if]
          </td>
          <td class="hide-on-mobile">
            [#if users(action.actionerUserId)??]
              ${users(action.actionerUserId).login}
            [#else]
              [#-- An action without an actioner was initiated by FusionAuth --]
              ${action.actionerUserId!"\x2013"}
            [/#if]
          </td>
          <td class="hide-on-mobile">
            [#if users(action.actionerUserId)??]
              ${users(action.actionerUserId).id}
            [#else]
              [#-- An action without an actioner was initiated by FusionAuth --]
              ${action.actionerUserId!"\x2013"}
            [/#if]
          </td>
          <td class="action">
            [@button.action href="/ajax/user/modify-action/${action.id}" icon="edit" key="modify-action" ajaxForm=true ajaxWideDialog=true/]
            [@button.action href="/ajax/user/cancel-action/${action.id}" color="red" icon="times" key="cancel-action" ajaxForm=true /]
          </td>
        [/#if]
      </tr>
      [/#list]
      [#if active_count < 1]
      <tr>
        <td colspan="7">[@message.print key="no-current-actions"/]</td>
      </tr>
      [/#if]
    [#else]
    <tr>
      <td colspan="7">[@message.print key="no-current-actions"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro entityTable readOnly]
[@control.form action="${request.contextPath}/ajax/entity/grant/search" method="GET" class="full pt-4" id="entity-search-form"]
  [@control.text name="s.name" labelKey="empty" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" placeholder="${function.message('{placeholder}queryString')}" includeFormRow=true/]
  <div class="form-row">
    [@button.formIcon color="blue" icon="search" textKey="search"/]
    [@button.iconLinkWithText href="#" color="blue" icon="undo" textKey="reset" class="reset-button" name="reset"/]
    [#if !readOnly]
      [@button.iconLinkWithText href="/admin/entity/grant/upsert?grant.userId=${user.id}&tenantId=${user.tenantId}" color="green" icon="plus" textKey="add" class="add-button float-right" name="add"/]
    [/#if]
  </div>
[/@control.form]

<div id="entity-search-results">
</div>
[/#macro]

[#macro historyTable]
<table class="hover">
  <thead class="light-header">
    <tr>
      <th>[@message.print key="action"/]</th>
      <th class="hide-on-mobile">[@message.print key="comment"/]</th>
      <th class="instant">[@message.print key="start"/]</th>
      <th class="instant">[@message.print key="expiration"/]</th>
      <th class="hide-on-mobile">[@message.print key="actioning-user"/]</th>
      <th class="hide-on-mobile">[@message.print key="actioning-user-id"/]</th>
    </tr>
  </thead>
  <tbody>
    [#if actions?? && actions?size > 0]
    [#--Don't show current actions on this table--]
      [#list actions as action]
        [#if !action.active]
        <tr>
          <td>
            [#if action.name??]
              ${properties.display(action, 'name')}
              [#if action.localizedReason??]
                [${properties.display(action, 'localizedReason')}]
              [#elseif action.reason??]
                [${properties.display(action, 'reason')}]
              [/#if]
            [#else]
              [@message.print key="comment"/]
            [/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(action, 'comment')}</td>
          <td class="instant">${function.format_zoned_date_time(action.insertInstant, function.message('date-time-format'), zoneId)}</td>
          <td class="instant">
            [#if action.expiry??]
              [#if function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)?contains('+292278994')]
                [@message.print key="indefinite"/]
              [#else]
              ${function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)}
              [/#if]
            [#else]
              &ndash;
            [/#if]
          </td>
          <td class="hide-on-mobile">
            [#if users(action.actionerUserId)??]
              ${users(action.actionerUserId).login}
            [#else]
              [#-- An action without an actioner was initiated by FusionAuth --]
              ${action.actionerUserId!"\x2013"}
            [/#if]
          </td>
          <td class="hide-on-mobile">
            [#if users(action.actionerUserId)??]
              ${users(action.actionerUserId).id}
            [#else]
              [#-- An action without an actioner was initiated by FusionAuth --]
              ${action.actionerUserId!"\x2013"}
            [/#if]
          </td>
        </tr>
        [/#if]
      [/#list]
    [#else]
    <tr>
      <td colspan="6">[@message.print key="no-history"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro registrationsTable readOnly=false]
<table class="hover">
  <thead class="light-header">
    <tr>
      <th>[@message.print key="application"/]</th>
      <th class="hide-on-mobile">[@message.print key="username"/]</th>
      <th>[@message.print key="roles"/]</th>
      <th class="hide-on-mobile">[@message.print key="insertInstant"/]</th>
      <th class="hide-on-mobile">[@message.print key="lastUpdateInstant"/]</th>
      <th class="hide-on-mobile">[@message.print key="last-login"/]</th>
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
    [#if user.registrations?? && user.registrations?size gt 0]
      [#list user.registrations as registration]
        [#assign application = applications(registration.applicationId)/]
        <tr>
          <td>
            ${properties.display(application, "name")}
            [#if !application.active]<span class="small blue stamp"><i class="fa fa-moon-o"></i> [@message.print key="inactive"/]</span>[/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(registration, "username")}</td>
          <td>${properties.display(registration, "roles")}</td>
          <td class="hide-on-mobile">${properties.display(registration, "insertInstant")}</td>
          <td class="hide-on-mobile">${properties.display(registration, "lastUpdateInstant")}</td>
          <td class="hide-on-mobile">${properties.display(registration, "lastLoginInstant")}</td>
          <td class="action">
            [#if application.active && !readOnly]
              [#--You cannot currently edit a user registration for an inactive application. Seems like we could change this - but until we do - don't allow edit.--]
              [@button.action href="/admin/user/registration/edit/${user.id}/${registration.applicationId}?tenantId=${user.tenantId}" icon="edit" key="edit-registration" color="blue"/]
            [/#if]
            [@button.action href="/ajax/user/registration/view/${user.id}/${registration.applicationId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
            [#if !readOnly]
              [#if ftlCurrentUser.id != user.id || registration.applicationId != fusionAuthId]
                [@button.action href="/ajax/user/registration/delete/${user.id}/${registration.applicationId}" icon="trash" key="delete-registration" color="red" ajaxForm=true/]
                [#if application.verifyRegistration && !registration.verified && user.email??]
                  [@button.action href="/ajax/user/registration/resend-verification/${user.id}/${registration.applicationId}?tenantId=${user.tenantId}" icon="envelope" key="resend-verification" color="orange" ajaxForm=true/]
                [/#if]
              [/#if]
            [/#if]
          </td>
        </tr>
      [/#list]
    [#else]
    <tr>
      <td colspan="5">[@message.print key="no-registrations"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
  [#if !readOnly]
    [#if registrationsAvailable]
      [#-- Add the tenantId so that we can easily retrieve the correct applications for this User's tenant --]
      [@button.iconLinkWithText href="/admin/user/registration/add/${user.id}?tenantId=${user.tenantId}" icon="plus" color="blue" textKey="add-registration"/]
    [#elseif user.registrations?? && user.registrations?size gt 0]
      <p><em>[@message.print key="no-registrations-available"/]</em></p>
    [#else]
      <p><em>[@message.print key="no-registrations-available-no-applications"/]</em></p>
    [/#if]
  [/#if]
[/#macro]

[#macro userLinksTable]
<table class="hover">
  <thead class="light-header">
    <tr>
      <th>[@message.print key="displayName"/]</th>
      <th>[@message.print key="identityProvider"/]</th>
      <th class="hide-on-mobile">[@message.print key="insertInstant"/]</th>
      <th class="hide-on-mobile">[@message.print key="lastLoginInstant"/]</th>
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
      [#list identityProviderLinks![] as idpLink]
      <tr>
        <td>${properties.display(idpLink, "displayName")}</td>
        <td>${properties.display(identityProviders(idpLink.identityProviderId), "name")}</td>
        <td class="hide-on-mobile">${properties.display(idpLink, "insertInstant")}</td>
        <td class="hide-on-mobile">${properties.display(idpLink, "lastLoginInstant")}</td>
        <td class="action">
          [@button.action href="/ajax/identity-provider/link/view?userId=${user.id}&identityProviderId=${idpLink.identityProviderId}&identityProviderUserId=${idpLink.identityProviderUserId?url}&tenantId=${user.tenantId}" icon="search" key="view" color="green" ajaxView=true ajaxForm=false ajaxWideDialog=true/]
          [@button.action href="/ajax/identity-provider/link/delete?userId=${user.id}&identityProviderId=${idpLink.identityProviderId}&identityProviderUserId=${idpLink.identityProviderUserId?url}&tenantId=${user.tenantId}" icon="trash" key="remove-user-link" color="red" ajaxForm=true ajaxWideDialog=false/]
        </td>
      </tr>
    [#else]
    <tr>
      <td colspan="7">[@message.print key="no-user-links"/]</td>
    </tr>
    [/#list]
  </tbody>
</table>
[/#macro]

[#macro membershipsTable]
<table class="hover">
  <thead class="light-header">
    <tr>
      <th>[@message.print key="group"/]</th>
      <th class="hide-on-mobile">[@message.print key="member-id"/]</th>
      <th class="hide-on-mobile">[@message.print key="created"/]</th>
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
    [#if user.memberships?? && user.memberships?size gt 0]
      [#list user.memberships as membership]
      <tr>
        [#--noinspection FtlReferencesInspection--]
        <td>${properties.display(groups(membership.groupId), "name")}</td>
        <td class="hide-on-mobile">${properties.display(membership, "id")}</td>
        <td class="hide-on-mobile">${properties.display(membership, "insertInstant")}</td>
        <td class="action">
          [@button.action href="/ajax/group/member/view?userId=${user.id}&groupId=${membership.groupId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
          [@button.action href="/ajax/group/member/remove?userId=${user.id}&groupId=${membership.groupId}&bulkManagement=false" icon="trash" key="remove-membership" color="red" ajaxForm=true ajaxWideDialog=true/]
        </td>
      </tr>
      [/#list]
    [#else]
    <tr>
      <td colspan="4">[@message.print key="no-groups"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
  [#if groups?has_content]
    [#if membershipsAvailable]
      [@button.iconLinkWithText href="/ajax/group/member/add?userId=${user.id}&tenantId=${user.tenantId}&bulkManagement=false" icon="plus" color="blue" textKey="add-membership" ajaxForm=true ajaxWideDialog=true/]
    [#else]
    <p><em>[@message.print key="no-memberships-available"/]</em></p>
    [/#if]
  [/#if]
[/#macro]

[#macro multiFactorTable readOnly]
  <table class="hover">
    <thead class="light-header">
      <tr>
        <th>[@message.print key="method"/]</th>
        <th class="hide-on-mobile">[@message.print key="transport"/]</th>
        <th class="hide-on-mobile">[@message.print key="identifier"/]</th>
        <th class="hide-on-mobile">[@message.print key="last-used"/]</th>
        <th data-sortable="false" class="action">[@message.print key="action"/]</th>
      </tr>
    </thead>
    <tbody>
        [#list user.twoFactor.methods![] as method]
        <tr>
          <td>${message.inlineOptional("two-factor-${method.method}", method.method)}</td>
          <td class="hide-on-mobile">
          [#if method.method == "email"] ${properties.display(method, "email")} [#elseif method.method == "sms"] ${properties.display(method, "mobilePhone")} [#else] &ndash; [/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(method, "id")}</td>
          <td class="hide-on-mobile">[#if method.lastUsed?? && method.lastUsed]<i class="fa fa-check green-text"></i>[/#if]</td>
          <td class="action">
            [#if !readOnly]
            [@button.action href="/ajax/user/two-factor/disable?methodId=${method.id?url}&userId=${user.id}" icon="trash" color="red" key="disable-two-factor" ajaxForm=true ajaxWideDialog=true/]
            [/#if]
          </td>
        </tr>
        [#else]
          <tr>
            <td colspan="4">[@message.print key="no-two-factor-methods"/]</td>
          </tr>
        [/#list]
    </tbody>
  </table>
   [#--  You can enable Two Factor for yourself --]
   [#if ftlCurrentUser.id == user.id && availableTwoFactorMethods?has_content]
    [@button.iconLinkWithText href="/ajax/user/two-factor/enable" icon="plus" color="blue" textKey="add-two-factor" ajaxForm=true ajaxWideDialog=true/]
   [/#if]
[/#macro]

[#macro webauthnTable readOnly]
  <table class="hover">
    <thead class="light-header">
      <tr>
        <th>[@message.print key="displayName"/]</th>
        <th>[@message.print key="name"/]<i class="fa fa-info-circle" data-tooltip="${message.inline('{tooltip}webauthn-name')}"></i></th>
        <th>[@message.print key="id"/]</th>
        <th class="hide-on-mobile">[@message.print key="created"/]</th>
        <th class="hide-on-mobile">[@message.print key="last-used"/]</th>
        <th data-sortable="false" class="action">[@message.print key="action"/]</th>
      </tr>
    </thead>
    <tbody>
        [#list webAuthnCredentials![] as cred]
        <tr>
          <td>${properties.display(cred, "displayName")}</td>
          <td>${properties.display(cred, "name")}</td>
          <td>${properties.display(cred, "id")}</td>
          <td class="hide-on-mobile">${properties.display(cred, "insertInstant")}</td>
          <td class="hide-on-mobile">${properties.display(cred, "lastUseInstant")}</td>
          <td class="action">
            [@button.action href="/ajax/user/webauthn/view/${cred.id}?tenantId=${cred.tenantId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
            [#if !readOnly]
            [@button.action href="/ajax/user/webauthn/delete/${cred.id}?userId=${cred.userId}&tenantId=${cred.tenantId}" icon="trash" color="red" key="delete-webauthn-passkey" ajaxForm=true ajaxWideDialog=true/]
            [/#if]
          </td>
        </tr>
        [#else]
          <tr>
            <td colspan="4">[@message.print key="no-webauthn-passkeys"/]</td>
          </tr>
        [/#list]
    </tbody>
  </table>
   [#--  You can add WebAuthn credential for yourself --]
   [#if ftlCurrentUser.id == user.id && tenant.webAuthnConfiguration.enabled]
    [@button.iconLinkWithText href="/ajax/user/webauthn/add?userId=${user.id}&tenantId=${user.tenantId}" icon="plus" color="blue" textKey="add-webauthn-passkey" ajaxForm=true/]
   [/#if]
[/#macro]

[#macro session readOnly]
[#if refreshTokens?has_content]
<div class="table-actions row">
  <div class="col-xs tight-right">
    <div class="text-right">
      [@button.iconLinkWithText href="/ajax/user/refresh-token/delete?userId=${user.id}&tenantId=${user.tenantId}" icon="trash" textKey="delete-all-sessions" color="red" ajaxForm=true/]
    </div>
  </div>
</div>
[/#if]
<table>
  <thead class="light-header">
    <tr>
      <th>[@message.print key="name"/]</th>
      <th class="hide-on-mobile">[@message.print key="type"/]</th>
      <th>[@message.print key="ip-address"/]</th>
      <th>[@message.print key="application"/]</th>
      <th class="hide-on-mobile">[@message.print key="created"/]</th>
      <th class="hide-on-mobile">[@message.print key="last-access-instant"/]</th>
      <th>[@message.print key="expiration"/]</th>
      [#if !readOnly]
      <th data-sortable="false" class="action">[@message.print key="action"/]</th>
      [/#if]
    </tr>
  </thead>
  <tbody>
    [#if refreshTokens?has_content]
      [#list refreshTokens![] as refreshToken]
      <tr>
        <td>${properties.display(refreshToken.metaData.device, "name")} [#if (thisSession?has_content && thisSession == refreshToken.token) || (thisSSOSessionId!'') == refreshToken.id]<span data-toolip="${message.inline("your-computer")}" title="${message.inline("your-computer")}"> &nbsp; <i class="fa fa-laptop green-text"></i></span>[/#if] </td>
        <td class="hide-on-mobile">${message.inlineOptional('device-type-' + (refreshToken.metaData.device.type!''), refreshToken.metaData.device.type!'\x2013')}</td>
        <td>${properties.display(refreshToken.metaData.device, "lastAccessedAddress")}</td>
        [#-- Application may be null, so use the key application.name to protected against NPE --]
        <td>${properties.display((applications(refreshToken.applicationId))!{}, "name", message.inline("single-sign-on"))}</td>
        <td class="hide-on-mobile">${properties.display(refreshToken, "startInstant")}</td>
        <td class="hide-on-mobile">${properties.displayZonedDateTime(refreshToken.metaData.device, "lastAccessedInstant", "date-time-seconds-format", false)}</td>
        <td>
          [#-- The Refresh Token TTL can be set in the application as well --]
           [#if refreshToken.applicationId??]
             [#-- This will cover most Refresh Tokens, including FusionAuth sessions --]
             [#local refreshTokenTimeToLiveInMinutes = tenants(user.tenantId).lookupJWTConfiguration(applications(refreshToken.applicationId)).refreshTokenTimeToLiveInMinutes /]
             ${properties.expiration(refreshToken.startInstant.plusMinutes(refreshTokenTimeToLiveInMinutes))}
           [#else]
             [#-- SSO Tokens do not have an applicationId, this is in seconds. --]
            ${properties.expiration(refreshToken.startInstant.plusSeconds(tenants(user.tenantId).httpSessionMaxInactiveInterval))}
           [/#if]
        </td>
        [#if !readOnly]
        <td class="action">
          [@button.action href="/ajax/user/refresh-token/delete/${refreshToken.id}?tenantId=${user.tenantId}" icon="trash" key="delete-session" color="red" ajaxForm=true/]
        </td>
        [/#if]
      </tr>
      [/#list]
    [#else]
    <td colspan="99">[@message.print key="no-refresh-tokens"/]</td>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro familiesTable]
<table class="hover">
  <thead class="light-header">
    <tr>
      <th>[@message.print key="name"/]</th>
      <th>[@message.print key="role"/]</th>
      <th>[@message.print key="age"/]</th>
      <th>[@message.print key="family"/]</th>
      <th>[@message.print key="added-on"/]</th>
      <th class="action">[@message.print key="action"/]</th>
    </tr>
  </thead>
  <tbody>
    [#if families?size > 0]
      [#list families![] as family]
        [#list family.members as member]
          [#assign memberUser = users(member.userId)/]
          <tr>
            <td class="icon"><a href="${memberUser.id}?tenantId=${memberUser.tenantId}">[@helpers.avatar memberUser/] ${properties.display(memberUser, 'name')}</a></td>
            <td>${properties.display(member, 'role')}</td>
            <td>${properties.display(memberUser, 'age')}</td>
            <td>${properties.display(family, 'id')}</td>
            <td>${properties.display(member, 'insertInstant')}</td>
            <td class="action">[@button.action href="${memberUser.id}?tenantId=${memberUser.tenantId}" icon="address-card-o" key="manage" color="purple"/]</td>
          </tr>
        [/#list]
      [/#list]
    [#else]
      <tr>
        <td colspan="99">[@message.print key="no-families"/]</td>
      </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro consentTable]
  <table>
    <thead class="light-header">
      <tr>
        <th>[@message.print key="name"/]</th>
        <th>[@message.print key="values"/]</th>
        <th>[@message.print key="status"/]</th>
        <th>[@message.print key="given-on"/]</th>
        <th>[@message.print key="given-by"/]</th>
        <th class="action">[@message.print key="action"/]</th>
      </tr>
    </thead>
    <tbody>
    [#list userConsents![] as userConsent]
      <tr>
        <td>${properties.display(userConsent, 'consent.name')}</td>
        <td>${properties.display(userConsent, 'values')}</td>
        <td>${properties.display(userConsent, 'status')}</td>
        <td>${properties.display(userConsent, 'insertInstant')}</td>
        <td>
          [#if userConsent.userId == userConsent.giverUserId]
            [@message.print key='self'/]
          [#else]
            [#assign giver = users(userConsent.giverUserId)/]
            <a href="${giver.id}?tenantId=${giver.tenantId}">${properties.display(giver, 'name')}</a>
          [/#if]
        </td>
        <td class="action">
          [#if userConsent.status == 'Active']
            [#if userConsent.consent.values?has_content]
              [#-- You only edit a consent that has values since that is the only thing you can change --]
              [@button.action href="/ajax/user/consent/edit/${userConsent.id}" icon="edit" key="edit-consent" color="blue" ajaxView=false ajaxForm=true/]
            [/#if]
            [@button.action href="/ajax/user/consent/revoke/${userConsent.id}" icon="minus-circle" key="revoke" color="red" ajaxView=false ajaxForm=true/]
          [#else]
            [@button.action href="/ajax/user/consent/unrevoke/${userConsent.id}" icon="undo" key="unrevoke" color="green" ajaxView=false ajaxForm=true/]
          [/#if]
        </td>
      </tr>
    [#else]
      <tr>
        <td colspan="99">[@message.print key="no-consents"/]</td>
      </tr>
    [/#list]
    </tbody>
  </table>
  [#if consentsAvailable]
    [@button.iconLinkWithText href="/ajax/user/consent/add?userId=${user.id}&tenantId=${user.tenantId}" icon="plus" color="blue" textKey="add-consent" ajaxForm=true /]
  [#else]
    <p><em>[@message.print key="no-consents-available"/]</em></p>
  [/#if]
[/#macro]
