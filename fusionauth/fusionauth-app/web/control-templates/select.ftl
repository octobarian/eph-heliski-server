[#ftl/]
[#import "_macros.ftl" as macros/]
[#assign ifr = true/]
[#assign multiple = attributes['multiple']?? && attributes['multiple']/]
[#if attributes['includeFormRow']??]
  [#assign ifr = attributes['includeFormRow']/]
[/#if]
[#if ifr]
<div id="${attributes['id']}-form-row" class="form-row">
[/#if]
  [@macros.dynamic_attributes/]
  [@macros.control_label/]
  [#if !multiple]
  <label class="select">
  [/#if]
    [#if attributes['leftAddon']?? || attributes['rightAddon']??]
    <div class="input-addon-group">
      [#if attributes['leftAddon']??]
        <span class="icon"><i class="fa fa-${attributes['leftAddon']}"></i></span>
      [/#if]
    [/#if]
    <select class="${macros.class('select')}" [@macros.append_attributes ["dataProperties", "includeFormRow"]/]>
      [#list options?keys as key]
        [#assign selected=false/]

        [#-- The attribute on the macro selected="foo" takes precedence over an option with the selected property set to true --]
        [#if (attributes['selected']?? && attributes['selected'] == key) || options[key].selected]
          [#assign selected=true/]
        [/#if]
        <option [#if selected]selected="selected" [/#if]value="${key}"[@macros.append_data_properties options[key].object/]>${options[key].text}</option>
      [/#list]
    </select>
    [#if attributes['leftAddon']?? || attributes['rightAddon']??]
      [#if attributes['rightAddon']??]
        <span class="icon"><i class="fa fa-${attributes['rightAddon']}"></i></span>
      [/#if]
    </div>
    [/#if]
  [#if !multiple]
  </label>
  [/#if]
  [@macros.errors/]
[#if ifr]
</div>
[/#if]
