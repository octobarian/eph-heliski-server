[#ftl/]
[#setting url_escaping_charset='UTF-8'/]
[#-- @ftlvariable name="actions" type="java.util.List<io.fusionauth.domain.UserActionLog>" --]
[#-- @ftlvariable name="actionsAvailable" type="boolean" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="availableTwoFactorMethods" type="java.util.List<java.lang.String>" --]
[#-- @ftlvariable name="families" type="java.util.List<io.fusionauth.domain.Family>" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="multiFactorAvailable" type="boolean" --]
[#-- @ftlvariable name="refreshTokens" type="java.util.List<io.fusionauth.domain.jwt.RefreshToken>" --]
[#-- @ftlvariable name="registrationsAvailable" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as userMacros/]

[#assign canDelete = fusionAuth.has_one_role("admin", "user_deleter")/]
[#assign canVerifyEmail = fusionAuth.has_one_role("admin", "user_manager")/]
[#assign readOnly = !(fusionAuth.has_one_role("admin", "user_manager", "user_support_manager"))/]

[@layout.html]
  [@layout.head]
  <script src="${request.contextPath}/js/qrcode-min-1.0.js"></script>
  <script src="${request.contextPath}/js/WebAuthnHelper.js?version=${version}"></script>
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const userId = '${user.id}';
      new FusionAuth.Admin.ManageUser(userId);
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${user.id}?tenantId=${user.tenantId}": "manage"}]
      [#if !readOnly]
        <div class="split-button" data-local-storage-key="user-manage-split-button">
          <a class="gray button item" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
          <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
            <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
          </button>
          <div class="menu">
            <a id="edit-user" class="item default" href="${request.contextPath}/admin/user/edit/${user.id}?tenantId=${user.tenantId}"><i class="fa fa-edit"></i>
              <span>[#if user.id == ftlCurrentUser.id][@message.print key="edit-profile"/][#else][@message.print key="edit"/][/#if]</span>
            </a>
            <a id="add-user-comment" class="item" href="${request.contextPath}/ajax/user/comment/${user.id}" data-ajax-form="true"><i class="fa fa-comment-o"></i> <span>[@message.print key="comment-user"/]</span></a>
            [#if actionsAvailable]
              <a id="add-user-action" class="item" href="${request.contextPath}/ajax/user/action/${user.id}" data-ajax-form="true" data-ajax-wide-dialog="true"><i class="fa fa-gavel"></i> <span>[@message.print key="action-user"/]</span></a>
            [/#if]
            [#if user.id != ftlCurrentUser.id && canDelete]
              <a id="delete-user" class="item" href="${request.contextPath}/admin/user/delete/${user.id}?tenantId=${user.tenantId}"><i class="fa fa-trash"></i> <span>[@message.print key="delete"/]</span></a>
            [/#if]
            [#if user.active]
              [#if user.id != ftlCurrentUser.id]
                <a id="deactivate-user" class="item" href="${request.contextPath}/ajax/user/deactivate/${user.id}" data-ajax-form="true"><i class="fa fa-lock"></i> <span>[@message.print key="lock-account"/]</span></a>
              [/#if]
            [#else]
              <a id="reactivate-user" class="item" href="${request.contextPath}/ajax/user/reactivate/${user.id}" data-ajax-form="true"><i class="fa fa-unlock-alt"></i> <span>[@message.print key="unlock-account"/]</span></a>
            [/#if]
            [#if tenant.emailConfiguration.forgotPasswordEmailTemplateId?? && user.email??]
              <a id="send-password-reset" class="item" href="${request.contextPath}/ajax/user/send-password-reset/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-envelope"></i> <span>[@message.print key="send-password-reset"/]</span></a>
            [/#if]
            [#if tenant.emailConfiguration.verifyEmail && !user.verified && user.email??]
              <a id="resend-email-verification" class="item" href="${request.contextPath}/ajax/user/resend-email-verification/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-envelope"></i> <span>[@message.print key="resend-email-verification"/]</span></a>
              [#if canVerifyEmail]
                <a id="verify-email" class="item" href="${request.contextPath}/ajax/user/verify-email/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-check"></i> <span>[@message.print key="verify-email"/]</span></a>
              [/#if]
            [/#if]
            <a id="require-password-change" class="item" href="${request.contextPath}/ajax/user/require-password-change/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-lock"></i> <span>[@message.print key="require-password-change"/]</span></a>
            [#if refreshTokens?has_content]
              <a id="delete-all-sessions" class="item" href="${request.contextPath}/ajax/user/refresh-token/delete?userId=${user.id}&tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-trash"></i> <span>[@message.print key="delete-all-sessions"/]</span></a>
            [/#if]
          </div>
        </div>
      [/#if]
    [/@layout.pageHeader]

    [@layout.main]
      [#if user.breachedPasswordStatus?? && user.breachedPasswordStatus != "None"]
      <div class="row">
        <div class="col-xs">
          [@message.alert message=message.inline('[Breached' + user.breachedPasswordStatus + ']') type="warning" icon="exclamation-triangle" includeDismissButton=false/]
        </div>
      </div>
      [/#if]

      [#assign panelColor = user.active?then('blue', 'red')/]
      [#if user.breachedPasswordStatus?? && user.breachedPasswordStatus != "None"]
        [#assign panelColor = 'orange'/]
      [/#if]

      [@panel.full panelClass="panel ${panelColor}"]
        [@userMacros.details readOnly/]

        <ul class="tabs">
          <li><a href="#registrations">[@message.print key="registrations"/]</a></li>
          <li><a href="#multi-factor">[@message.print key="multi-factor"/]</a></li>
          <li><a href="#webauthn">[@message.print key="passkeys"/]</a></li>
          <li><a href="#families">[@message.print key="families"/]</a></li>
          <li><a href="#user-links">[@message.print key="user-links"/]</a></li>
          <li><a href="#memberships">[@message.print key="groups"/]</a></li>
          <li><a href="#entities">[@message.print key="entity-grants"/]</a></li>
          <li><a href="#recent-logins">[@message.print key="recent-logins"/]</a></li>
          <li><a href="#consent">[@message.print key="consent"/]</a></li>
          <li><a href="#sessions">[@message.print key="sessions"/]</a></li>
          <li><a href="#user-actions">[@message.print key="current-actions"/]</a></li>
          <li><a href="#user-history">[@message.print key="user-history"/]</a></li>
          <li><a href="#user-data">[@message.print key="user-data"/]</a></li>
          <li><a href="#raw-user">[@message.print key="raw-user"/]</a></li>
        </ul>

        <div id="registrations" class="hidden">
          [@userMacros.registrationsTable readOnly/]
        </div>

        <div id="multi-factor" class="hidden">
          [@userMacros.multiFactorTable readOnly/]
        </div>

        <div id="webauthn" class="hidden">
          [@userMacros.webauthnTable readOnly/]
        </div>

        <div id="families" class="hidden">
          [@userMacros.familiesTable/]
        </div>

        <div id="user-links" class="hidden">
          [@userMacros.userLinksTable/]
        </div>

        <div id="memberships" class="hidden">
          [@userMacros.membershipsTable/]
        </div>

        <div id="entities" class="table-actions">
          [@userMacros.entityTable readOnly/]
        </div>

        <div id="recent-logins" class="table-actions">
          <div id="user-last-logins">
            [#include "*/ajax/user/recent-logins.ftl"/]
          </div>
        </div>

        <div id="consent" class="hidden">
          [@userMacros.consentTable/]
        </div>

        <div id="sessions" [#if refreshTokens?has_content]class="table-actions"[/#if]>
          [@userMacros.session readOnly/]
        </div>

        <div id="user-actions">
          [@userMacros.currentActionsTable/]
        </div>

        <div id="user-history">
          [@userMacros.historyTable/]
        </div>

        <div id="user-data">
          [@userMacros.data/]
        </div>

        <div id="raw-user">
          <fieldset>
            <pre class="code scrollable horizontal mt-0">${fusionAuth.stringify(user)}</pre>
            <p><em>[@message.print key="{description}raw-user"/]</em></p>
          </fieldset>
        </div>
      [/@panel.full]

      <div id="error-dialog" class="prime-dialog hidden">
        [@dialog.basic titleKey="error" includeFooter=true]
          <p>
            [@message.print key="[AJAXError]"/]
          </p>
        [/@dialog.basic]
      </div>
    [/@layout.main]
  [/@layout.body]
[/@layout.html]

