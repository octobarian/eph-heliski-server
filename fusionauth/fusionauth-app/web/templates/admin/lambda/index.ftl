[#ftl/]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="types" type="io.fusionauth.domain.LambdaType[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]
[#import "_macros.ftl" as lambdaMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      const form = Prime.Document.queryById('lambda-form')
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.lambdas.advancedControls');
      new FusionAuth.UI.TextEditor(form.queryFirst('textarea[name="s.body"]'))
           .render()
           .setHeight(100);
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "customizations", "/admin/lambda/": "lambdas"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="lambda-form" action="${request.contextPath}/admin/lambda/" method="GET" class="labels-above full push-bottom" searchResults="lambda-content"]
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
          <div id="advanced-search-controls" class="slide-open">
            <div class="row">
              <div class="col-xs-12 col-md-12 tight-left">
                [@control.select items=types name="s.type" headerL10n="any" headerValue=""/]
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12 col-md-12 tight-left">
                [@control.textarea name="s.body" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" /]
              </div>
            </div>
          </div>

          <a href="#" class="slide-open-toggle" data-expand-open="advanced-search-controls">
            <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
          </a>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="/admin/lambda/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="lambda-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@lambdaMacros.lambdasTable/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
