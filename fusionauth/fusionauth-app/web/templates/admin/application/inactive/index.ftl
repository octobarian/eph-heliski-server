[#ftl/]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/search.ftl" as search/]
[#import "../_macros.ftl" as applicationMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      const form = Prime.Document.queryById('application-form');
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.applications.inactive.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeBack=true backURI="/admin/application/" includeAdd=false breadcrumbs={"": "settings", "/admin/application/": "applications", "/admin/application/inactive/": "inactive"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="application-form" action="${request.contextPath}/admin/application/inactive/" method="GET" class="labels-above full push-bottom" searchResults="application-content"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.name" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('{placeholder}s.name')}"/]
              </div>
            </div>
          </div>

          [#-- Advanced Search Controls --]
          [#if tenants?size > 1]
            <div id="advanced-search-controls" class="slide-open">
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
              [@button.iconLinkWithText href="/admin/application/inactive/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="application-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@applicationMacros.applicationsTable true/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
