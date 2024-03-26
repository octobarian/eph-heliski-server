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
      var element = Prime.Document.queryById('registration-report');
      new FusionAuth.Admin.Report(element, '${message.inline('page-title')}')
          .withLocalStoragePrefix('reg_report_')
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=false breadcrumbs={"": "reports", "/admin/report/registration": "registration"}/]
    [@layout.main]
      [@panel.full]
        [@report.chart "registration"/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]