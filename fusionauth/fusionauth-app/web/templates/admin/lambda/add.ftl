[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as lambdaMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.LambdaForm(Prime.Document.queryById('lambda-form'));
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="lambda-form" panelTitleKey="" cancelURI="/admin/lambda/" breadcrumbs={"": "customizations", "/admin/lambda/": "lambdas", "/admin/lambda/add": "add"}]
      [@lambdaMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]