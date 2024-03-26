[#ftl/]
[#-- @ftlvariable name="consent" type="io.fusionauth.domain.Consent" --]
[#-- @ftlvariable name="consentId" type="java.util.UUID" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as consentMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.ConsentForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${consentId}" method="POST" includeSave=true includeCancel=true cancelURI="/admin/consent/" breadcrumbs={"": "settings", "/admin/consent/": "consents", "/admin/consent/edit/${consentId}": "edit"}]
      [@consentMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]