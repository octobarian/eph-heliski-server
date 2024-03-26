[#ftl/]
[#import "_macros.ftl" as macros/]
[#assign ifr = true/]
[#if attributes['includeFormRow']??]
  [#assign ifr = attributes['includeFormRow']/]
[/#if]
[#if ifr]
<div id="${attributes['id']}-form-row" class="form-row[#if attributes['additionalFormRowClasses']??] ${attributes['additionalFormRowClasses']}[/#if]">
[/#if]
  [@macros.dynamic_attributes/]
  [@macros.control_label/]
  [#if attributes['leftAddon']?has_content || attributes['rightAddon']?has_content || attributes['leftAddonText']?has_content || attributes['rightAddonText']?has_content || attributes['rightAddonButton']?has_content ||  attributes['rightAddonRaw']?has_content ]
  <div class="input-addon-group">
    [#if attributes['leftAddon']?has_content]
    <span class="icon"><i class="fa fa-${attributes['leftAddon']}"></i></span>
    [/#if]
    [#if attributes['leftAddonText']?has_content]
    <span class="text">${attributes['leftAddonText']}</span>
    [/#if]
  [/#if]
  <input type="number" class="${macros.class('number')}" [@macros.append_attributes ["leftAddon", "leftAddonText", "rightAddon", "rightAddonText", "rightAddonButton", "rightAddonRaw"]/]/>[#t/]
  [#if attributes['leftAddon']?has_content || attributes['rightAddon']?has_content || attributes['leftAddonText']?has_content || attributes['rightAddonText']?has_content || attributes['rightAddonButton']?has_content || attributes['rightAddonRaw']?has_content ]
    [#if attributes['rightAddon']?has_content]
      <span class="icon"><i class="fa fa-${attributes['rightAddon']}"></i></span>
    [/#if]
    [#if attributes['rightAddonText']?has_content]
      <span class="text">${attributes['rightAddonText']}</span>[#t/]
    [/#if]
    [#if attributes['rightAddonButton']?has_content]
      <a class="button blue">${attributes['rightAddonButton']}</a>[#t/]
    [/#if]
    [#if attributes['rightAddonRaw']?has_content]
      ${attributes['rightAddonRaw']}
    [/#if]
  </div>
  [/#if]
  [@macros.errors/]
[#if ifr]
</div>
[/#if]