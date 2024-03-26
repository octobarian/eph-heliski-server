[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/search.ftl" as search/]
[#import "_macros.ftl" as consentMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      const form = Prime.Document.queryById('consent-form');
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.consents.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true titleKey="page-title" breadcrumbs={"": "settings", "/admin/consent/": "page-title"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="consent-form" action="${request.contextPath}/admin/consent/" method="GET" class="labels-above full push-bottom" searchResults="consent-content"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.name" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('search-placeholder')}"/]
              </div>
            </div>
          </div>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="/admin/consent/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="consent-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@consentMacros.consentsTable/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
