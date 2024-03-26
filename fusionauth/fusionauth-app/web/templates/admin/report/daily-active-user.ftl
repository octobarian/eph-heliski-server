[#ftl/]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/report.ftl" as report/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      var element = Prime.Document.queryById('daily-active-user-report');
      new FusionAuth.Admin.Report(element, '${message.inline('page-title')}')
          .withLocalStoragePrefix('dau_report_')
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=false breadcrumbs={"": "reports", "/admin/report/daily-active-user": "daily-active-user"}/]
    [@layout.main]
      [@panel.full]
        [@report.chart "daily-active-user"/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]