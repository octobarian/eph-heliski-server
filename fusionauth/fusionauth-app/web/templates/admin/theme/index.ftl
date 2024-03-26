[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]
[#import "_macros.ftl" as themeMacros/]

[@layout.html]
    [@layout.head]
      <script>
        Prime.Document.onReady(function() {
          const form = Prime.Document.queryById('theme-form');
          new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.themes.advancedControls');
        });
      </script>
    [/@layout.head]
    [@layout.body]
      [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true  breadcrumbs={"": "customizations", "/admin/theme/": "themes"}/]
      [@layout.main]
        [@panel.full]
        [@control.form id="theme-form" action="${request.contextPath}/admin/theme/" method="GET" class="labels-above full push-bottom" searchResults="theme-content"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.name" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('{placeholder}s.name')}"/]
              </div>
            </div>
          </div>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="/admin/theme/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="theme-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@themeMacros.themesTable/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
        [/@panel.full]
      [/@layout.main]
    [/@layout.body]
[/@layout.html]
