[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as messengerMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
            .initialize();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "settings", "/admin/messenger/": "messengers"}]
      <div id="messenger-actions" class="split-button" data-local-storage-key="messengers-split-button">
        <a class="gray button item" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
        <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
        </button>
        <div class="menu">
          [#list ["Generic",  "Kafka",  "Twilio"] as messenger]
            <a id="add-${messenger?lower_case}" class="item" href="/admin/messenger/add/${messenger}">
              <i class="green-text fa fa-plus"></i> <span>[@message.print key="add-${messenger?lower_case}"/]</span>
            </a>
          [/#list]
        </div>
      </div>
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full]
        [@messengerMacros.messengersTable/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]