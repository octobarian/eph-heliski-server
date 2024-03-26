[#ftl/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="deactivate" method="POST" class="full" includeSave=true saveColor="red" saveIcon="minus-circle" saveKey="deactivate" includeCancel=true cancelURI="/admin/reactor" breadcrumbs={"/admin/reactor": "reactor"}]
      [@message.print key="warning"/]
      <fieldset>
         [@properties.table]
          [@properties.rowEval nameKey="instanceId" object=instance propertyName="id"/]
         [/@properties.table]
      </fieldset>
      <fieldset>
        [@control.text name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]f