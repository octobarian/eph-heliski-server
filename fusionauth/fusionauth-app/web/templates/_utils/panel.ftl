[#ftl/]

[#import "button.ftl" as button/]
[#import "helpers.ftl" as helpers/]
[#import "message.ftl" as message/]

[#macro full titleKey="" titleValues=[] rowClass="row" columnClass="col-xs" panelClass="panel" mainClass="" displayTotal=0 displayTotalItemsKey="page-title"]
<div class="${rowClass}">
  <div class="${columnClass}">
    <div class="${panelClass}">
      [#if titleKey != ""]
        <h2>[@message.print key=titleKey values=titleValues/]</h2>
      [/#if]
      <main class="${mainClass}">
        [#nested/]
        [@totalItems displayTotal displayTotalItemsKey/]
      </main>
    </div>
  </div>
</div>
[/#macro]

[#macro customFull titleKey="" titleValues=[] rowClass="row" columnClass="col-xs" panelClass="panel" mainClass=""]
<div class="${rowClass}">
  <div class="${columnClass}">
    <div class="${panelClass}">
      [#nested/]
    </div>
  </div>
</div>
[/#macro]

[#macro simple titleKey="page-title" class="panel"]
<div class="${class}">
  <h2>[@message.print key=titleKey/]</h2>
  <main>
    [#nested/]
  </main>
</div>
[/#macro]

[#macro totalItems total itemKey="page-title"]
[#-- Show this total after 5 items. Up until a handful, you can visually count quite easily. --]
[#if total gt 5]
<div class="row">
  <div class="col-xs tight-left pt-4">
    [#--
       Not sure why, but the default grouping separator should be a comma - but it is showing up as a space unless I explictly extend the decimal formatter and specify the groupingSeparator.
       See the same usage in totals.ftl and it works fine without having to specify the groupingSeparator. WTF?
     --]
    <span style="font-weight: 500;">${total?string[",##0;; groupingSeparator=','"]}</span>
    <span style="text-transform: lowercase">[@message.print key=itemKey /]</span>
  </div>
</div>
[/#if]
[/#macro]

