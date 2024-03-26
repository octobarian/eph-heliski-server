[#ftl/]

[#-- @ftlvariable name="messengerId" type="java.util.UUID" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.messenger.MessengerType" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as messengerMacros/]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/vkbeautify-0.9.00.beta.js"></script>
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.MessengerForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit" method="POST" id="messenger-form" pageTitleKey="edit-${type}" includeSave=true includeCancel=true cancelURI="/admin/messenger/" breadcrumbs={"": "settings", "/admin/messenger/": "messengers", "/admin/messenger/edit/${type}/${messengerId}": "edit"}]
      [@messengerMacros.messengerFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]