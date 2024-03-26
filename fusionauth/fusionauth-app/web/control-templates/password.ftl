[#ftl/]
[#import "_macros.ftl" as macros/]
<div id="${attributes['id']}-form-row" class="form-row">
  [@macros.dynamic_attributes/]
  [@macros.control_label/]
  [#if attributes['leftAddon']?? || attributes['rightAddon']??]
  <div class="input-addon-group">
    [#if attributes['leftAddon']??]
      <span class="icon"><i class="fa fa-${attributes['leftAddon']}"></i></span>
    [/#if]
  [/#if]
  <input type="password" class="${macros.class('password')}" [@macros.append_attributes/]/>
  [#if attributes['leftAddon']?? || attributes['rightAddon']??]
    [#if attributes['rightAddon']??]
      <span class="icon"><i class="fa fa-${attributes['rightAddon']}"></i></span>
    [/#if]
  </div>
  [/#if]
  [@macros.errors/]
</div>