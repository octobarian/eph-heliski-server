[#ftl/]
[#import "_macros.ftl" as macros/]
[#assign classList = macros.class('checkbox')/]
[#assign ifr = true/]
[#if attributes['includeFormRow']??]
  [#assign ifr = attributes['includeFormRow']/]
[/#if]
[#if ifr]
<div id="${attributes['id']}-form-row" class="form-row">
[/#if]
  [@macros.dynamic_attributes/]
  [@macros.control_label/]
  <input type="hidden" name="__cb_${attributes['name']}" value="${uncheckedValue}"/>
  <label class="toggle"><input type="checkbox" [@macros.append_attributes/]/><span class="rail"></span><span class="pin"></span></label>
  [@macros.errors/]
[#if ifr]
</div>
[/#if]
