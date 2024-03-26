[#ftl/]
[#-- @ftlvariable name="firstResult" type="int" --]
[#-- @ftlvariable name="lastResult" type="int" --]
[#-- @ftlvariable name="totalCount" type="int" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.AuditLog>" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.AuditLogSearchCriteria" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/properties.ftl" as propeties/]
[#import "../../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      var form = Prime.Document.queryById('audit-log-form');
      new FusionAuth.Admin.AuditLogSearch(form);

      var auditLog = Prime.Document.queryById('system-audit-content');
      new FusionAuth.UI.Listing(auditLog.queryFirst('table.listing'))
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "system", "/admin/system/audit-log/": "audit-log"}]
        [@button.iconLink href="/admin/system/audit-log/download" color="purple" icon="download" tooltipKey="download"/]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full]
        [@control.form id="audit-log-form" action="${request.contextPath}/admin/system/audit-log/" method="GET" class="labels-above full push-bottom"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.message" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('{placeholder}s.message')}"/]
              </div>
            </div>
          </div>

         [#-- Advanced Search Controls --]
          <div id="advanced-search-controls" class="slide-open">
           <div class="row">
              <div class="col-xs-12 col-md-4 tight-left">
                [@control.text name="s.reason" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" /]
              </div>
              <div class="col-xs-12 col-md-4 tight-left">
                [@control.text name="s.oldValue" /]
              </div>
              <div class="col-xs-12 col-md-4 tight-left">
                [@control.text name="s.newValue" /]
              </div>
            </div>
            <div class="row">
              <div class="col-xs-12 col-md-4 tight-left">
                [@control.text name="q" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" placeholder=message.inline("{placeholder}q")/]
                [@control.hidden name="s.user" /]
              </div>
              <div class="col-xs-12 col-md-4 tight-left">
                [@control.text name="s.start" class="date-time-picker" _dateTimeFormat="yyyy-MM-dd'T'HH:mm:ss.SSSX"/]
              </div>
              <div class="col-xs-12 col-md-4 tight-left">
                [@control.text name="s.end" class="date-time-picker" _dateTimeFormat="yyyy-MM-dd'T'HH:mm:ss.SSSX"/]
              </div>
            </div>
          </div>

          <a href="#" class="slide-open-toggle" data-expand-open="advanced-search-controls">
            <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
          </a>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon icon="search" color="blue" textKey="search"/]
              [@button.iconLinkWithText textKey="reset" icon="undo" href="/admin/system/audit-log/?clear=true"/]
            </div>
          </div>

        [/@control.form]

        <div id="system-audit-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="hover listing" data-sortable="false">
              <thead>
              <tr>
                [@helpers.tableHeader "message"/]
                [@helpers.tableHeader "insertUser" "hide-on-mobile"/]
                [@helpers.tableHeader "insertInstant"/]
                <th data-sortable="false" class="action">[@message.print key="action"/]</th>
              </tr>
              </thead>
              <tbody>
              [#list results![] as log]
                <tr>
                  <td class="overflow-ellipsis pr-4">${propeties.display(log, "message")}</td>
                  <td class="tight pr-4 hide-on-mobile">${propeties.display(log, "insertUser")}</td>
                  <td class="overflow-ellipsis-on-mobile tight pr-4">${function.format_zoned_date_time(log.insertInstant, function.message('date-time-seconds-format'), zoneId)}[#t/]</td>
                  <td class="action">
                    [@button.action icon="search" color="green" href="/ajax/system/audit-log/view/${log.id}" key="view-audit-log" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
                  </td>
                </tr>
                [#else]
                <tr>
                  <td colspan="4">
                    [@message.print key="no-results"/]
                  </td>
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
