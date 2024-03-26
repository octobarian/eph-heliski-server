[#ftl/]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]

[#import "../../../_utils/search.ftl" as search/]
[#import "_macros.ftl" as emailTemplateMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.EmailTemplateListing();
      const form = Prime.Document.queryById('email-template-form')
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.email.templates.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true  breadcrumbs={"": "customizations", "/admin/email/template/": "email-templates"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="email-template-form" action="${request.contextPath}/admin/email/template/" method="GET" class="labels-above full push-bottom" searchResults="email-template-content"]
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
              [@button.iconLinkWithText href="/admin/email/template/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="email-template-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@emailTemplateMacros.emailTemplatesTable/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
