[#ftl/]
[#import "_macros.ftl" as macros/]
[#assign classList = macros.class('radio-list')/]
<div id="${attributes['id']}-form-row" class="form-row">
  [@macros.dynamic_attributes/]
  [@macros.control_label includeFor=false/]
  [#list options?keys as key]
  <label class="radio"><input type="radio" name="${attributes['name']}" id="${attributes['id']}-${key}" value="${key}" [#if options[key].selected]checked[/#if] [@macros.append_attributes ["id"]/]/><span class="box"></span><span class="label">${options[key].text}</span></label>
  [/#list]
  <input type="hidden" name="__rb_${attributes['name']}" value="${uncheckedValue}"/>
  [@macros.errors/]
</div>