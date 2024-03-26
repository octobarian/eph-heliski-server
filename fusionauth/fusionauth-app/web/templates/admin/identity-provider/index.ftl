[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="availableTypes" type="io.fusionauth.domain.provider.IdentityProviderType[]" --]
[#-- @ftlvariable name="requiredCORSConfiguration" type="java.util.Map<String, io.fusionauth.domain.CORSConfiguration>" --]
[#-- @ftlvariable name="types" type="io.fusionauth.domain.provider.IdentityProviderType[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]
[#import "_macros.ftl" as identityProviderMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        const form = Prime.Document.queryById('identity-providers-form');
        new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.idp.advancedControls');
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "settings", "/admin/identity-provider/": "identity-providers"}]
      <div id="identity-provider-actions" class="split-button" data-local-storage-key="idp-split-button">
        <a class="gray button item" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
        <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
        </button>
        <style>
        </style>
        <div class="menu">
         [#list availableTypes as type]
         <a id="add-${type}" class="item" href="add/${type}" >
           <img src="${request.contextPath}/images/identityProviders/${type?lower_case}.svg" alt="${message.inline(type?string)}">
           <span>Add [@message.print key="${type?string}"/]</span>
         </a>
         [/#list]
        </div>
      </div>
    [/@layout.pageHeader]
    [@layout.main]

      [#if requiredCORSConfiguration?has_content]
        [@panel.full titleKey="cors-configuration-warning" panelClass="panel orange"]
        <p>[@message.print key="{description}cors-configuration-warning"/]</p>
        [#assign link = "<a href=\"/admin/system-configuration/edit#cors-settings\">CORS filter</a>" /]
        [#-- Use control.message so we can control the escaping of the link --]
        <p>[@control.message key="cors-link" values=[link]/] </p>
        [#list requiredCORSConfiguration as name, cors]
          <fieldset class="mt-4">
          <legend>${name}</legend>
          [@properties.table]
            [#if cors.allowedHeaders?has_content]
               [@properties.row "corsConfiguration.allowedHeaders" cors.allowedHeaders?join(", ")/]
            [/#if]
            [#if cors.allowedMethods?has_content]
              [@properties.row "corsConfiguration.allowedMethods" cors.allowedMethods?join(", ")/]
            [/#if]
            [#if cors.allowedOrigins?has_content]
              [@properties.row "corsConfiguration.allowedOrigins" cors.allowedOrigins?join(", ")/]
            [/#if]
          [/@properties.table]
          </fieldset>
        [/#list]
        [/@panel.full]
      [/#if]

      [@panel.full]
        [@control.form id="identity-providers-form" action="${request.contextPath}/admin/identity-provider/" method="GET" class="labels-above full push-bottom" searchResults="identity-providers-content"]
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
          [#if applications?size > 1]
            <div id="advanced-search-controls" class="slide-open">
              <div class="row">
                <div class="col-xs-12 col-md-6 tight-left">
                  [@control.select name="s.applicationId" labelKey="application" items=applications textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
                </div>
                <div class="col-xs-12 col-md-6">
                  [@control.select name="s.type" labelKey="type" items=types headerL10n="any" headerValue="" /]
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
              [@button.iconLinkWithText href="/admin/identity-provider/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="identity-providers-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            [@identityProviderMacros.identityProvidersTable/]
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
