[#ftl/]
[#-- @ftlvariable name="fusionAuthId" type="java.util.UUID" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Webhook>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      const form = Prime.Document.queryById('webhook-form');
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.webhooks.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/webhook/": "webhooks"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="webhook-form" action="${request.contextPath}/admin/webhook/" method="GET" class="labels-above full push-bottom" searchResults="webhook-content"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.url" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('{placeholder}s.url')}"/]
              </div>
            </div>
          </div>

          [#-- Advanced Search Controls --]
          [#if tenants?size > 1]
            <div id="advanced-search-controls" class="slide-open">
              <div class="row">
                <div class="col-xs-12 col-md-6 tight-left">
                  [@control.select name="s.tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
                </div>
                <div class="col-xs-12 col-md-6">
                  [@control.text name="s.description" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" /]
                </div>
              </div>
            </div>

            <a href="#" class="slide-open-toggle" data-expand-open="advanced-search-controls">
              <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
            </a>
          [/#if]

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="/admin/webhook/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="webhook-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="hover listing" data-sortable="false">
              <thead>
              <tr>
                [@helpers.tableHeader "url"/]
                [@helpers.tableHeader "id" "hide-on-mobile"/]
                <th data-sortable="false" class="hide-on-mobile">[@message.print key="tenants"/]</th>
                [@helpers.tableHeader "description" "hide-on-mobile"/]
                <th data-sortable="false" class="action">[@message.print key="action"/]</th>
              </tr>
              </thead>
              <tbody>
                [#list results![] as webhook]
                  <tr>
                    <td>${webhook.url}</td>
                    <td class="hide-on-mobile">${properties.display(webhook, "id")}</td>
                    <td class="hide-on-mobile">
                      [#if webhook.global]
                        [@message.print key="all-tenants"/]
                      [#elseif webhook.tenantIds?size > 0]
                        [#assign tenantNames = ""/]
                        [#list webhook.tenantIds as tenantId]
                          [#assign tenantNames = tenantNames + helpers.tenantName(tenantId)/]
                          [#if !tenantId?is_last] [#assign tenantNames = tenantNames + ', '/][/#if]
                        [/#list]
                        [@helpers.truncate string=tenantNames maxLength=50/]
                      [#else]
                        ${"\x2013"}
                      [/#if]
                    </td>
                    <td class="hide-on-mobile">[@properties.truncate webhook, "description", 80/]</td>
                    <td class="action">
                      [@button.action href="edit/${webhook.id}" icon="edit" key="edit" color="blue"/]
                      [@button.action href="test/${webhook.id}" icon="exchange" key="test" color="purple"/]
                      [@button.action href="/ajax/webhook/view/${webhook.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
                      [@button.action href="/ajax/webhook/delete/${webhook.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                    </td>
                  </tr>
                [#else]
                  <tr>
                    <td colspan="5">[@message.print key="no-results"/]</td>
                  </tr>
                [/#list]
              </tbody>
            </table>
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
