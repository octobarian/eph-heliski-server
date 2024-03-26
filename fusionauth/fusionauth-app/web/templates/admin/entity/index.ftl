[#ftl/]
[#-- @ftlvariable name="entities" type="java.util.List<io.fusionauth.domain.Entity>"--]
[#-- @ftlvariable name="entityTypes" type="java.util.List<io.fusionauth.domain.EntityType>"--]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Entity>" --]
[#-- @ftlvariable name="fullQuery" type="java.lang.String" --]
[#-- @ftlvariable name="s" type="io.fusionauth.app.service.search.SearchFrontendService.FrontendEntitySearchCriteria" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script src="${request.contextPath}/js/admin/AbstractAdvancedSearch.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/entity/AdvancedEntitySearch.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/entity/EntitySearch.js?version=${version}"></script>
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.EntitySearch();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    <div id="entity-search-container">
    [@layout.pageHeader includeAdd=true titleKey="page-title" breadcrumbs={"": "entity-management", "/admin/entity/": "entities"}/]
      [@layout.main]
        [@panel.full]
          [@control.form action="${request.contextPath}/ajax/entity/search" method="GET" class="full" id="entity-search-form"]
            <div class="row">
               <div class="col-xs-12 col-md-12 tight-left">
                 <div class="form-row">
                    [@control.text name="s.queryString" labelKey="empty" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus" placeholder="${function.message('{placeholder}queryString')}"/]
                 </div>
               </div>
             </div>

            [#-- Advanced Search Controls --]
            <div id="advanced-search-controls" class="slide-open">
              <div class="row">
                [#if tenants?size > 1]
                  <div class="col-xs-12 col-md-6 tight-left">
                    [@control.select name="s.typeId" labelKey="type" items=entityTypes textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
                  </div>
                  <div class="col-xs-12 col-md-6 tight-left">
                    [@control.select name="s.tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
                  </div>
                [#else]
                  <div class="col-xs-12 col-md-12 tight-left">
                    [@control.select name="s.typeId" labelKey="type" items=entityTypes textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
                  </div>
                [/#if]
              </div>

              <div class="row">
                <div class="col-xs-12 col-md-12 tight-left">
                  <div class="form-row">
                    <label for="show-raw-query">[@message.print key="show-elastic-query"/]</label>
                    <label class="toggle">
                      <input type="checkbox" id="show-raw-query" data-slide-open="raw-query">
                      <span class="rail"></span>
                      <span class="pin"></span>
                    </label>
                    <div id="raw-query" class="slide-open">
                      <label data-label-json="${message.inline('raw-query-label')}" data-label-string="${message.inline('raw-queryString-label')}"></label>
                      <pre class="code pre-wrap">

                      </pre>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <a href="#" class="[#if searchEngineType == 'elasticsearch']slide-open-toggle[#else]hidden[/#if]" data-expand-open="advanced-search-controls">
              <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
            </a>

            <div class="row push-lesser-top push-bottom">
              <div class="col-xs tight-left">
                [@button.formIcon color="blue" icon="search" textKey="search"/]
                [@button.iconLinkWithText href="#" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
              </div>
            </div>
          [/@control.form]

          <div id="advanced-search-results"></div>

          <div id="error-dialog" class="prime-dialog hidden">
            [@dialog.basic titleKey="error" includeFooter=true]
              <p>
                [@message.print key="[AJAXError]"/]
              </p>
            [/@dialog.basic]
          </div>
        [/@panel.full]
      [/@layout.main]
     </div>
  [/@layout.body]
[/@layout.html]
