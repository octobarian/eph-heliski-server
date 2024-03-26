[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/search.ftl" as search/]
[#import "_macros.ftl" as apiMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.APIKeys();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/api-key/": "api-authentication-keys"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="api-key-form" action="${request.contextPath}/admin/api-key/" method="GET" class="labels-above full push-bottom" searchResults="api-key-content"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.description" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('{placeholder}s.description')}"/]
              </div>
            </div>
          </div>

          [#-- Advanced Search Controls --]
          [#if tenants?size > 1]
            <div id="advanced-search-controls" class="slide-open">
              <div class="row">
                <div class="col-xs-12 col-md-6 tight-left">
                  [@control.text name="s.key" labelKey="s.key" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"/]
                </div>
                <div class="col-xs-12 col-md-6">
                  [#assign keyManagerOptions = {"true": "${message.inline('yes')}", "false": "${message.inline('no')}"}]
                  [@control.select name="s.keyManager" labelKey="key-manager" items=keyManagerOptions headerL10n="dash" headerValue="" /]
                </div>
              </div>
              <div class="row">
                <div class="col-xs-12 col-md-12 tight-left">
                  [@control.select name="s.tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
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
              [@button.iconLinkWithText href="/admin/api-key/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="api-key-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@apiMacros.apiKeysTable/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
    [#-- Used for API key reveals --]
    [@control.form id="api-key-reveal-form" action="${request.contextPath}/ajax/api-key/reveal" method="POST" class="inline-block"]
      [@control.hidden name="apiKeyId"/]
    [/@control.form]
  [/@layout.body]
[/@layout.html]
