[#ftl/]
[#-- @ftlvariable name="attributes" type="java.util.Map<java.lang.String, java.lang.Object>" --]
[#-- @ftlvariable name="label" type="java.lang.String" --]
[#-- @ftlvariable name="fieldMessages" type="java.util.List<org.primeframework.mvc.message.FieldMessage>" --]

[#import "_macros.ftl" as macros/]

<div id="${attributes['id']}-form-row" class="form-row">
  [@macros.dynamic_attributes/]
  [@macros.control_label/]
  <div class="${macros.class('checkbox-list')}" id="${attributes['id']}">
  [#list options?keys as key]
    <div class="checkbox">
      <label class="checkbox"><input type="checkbox" id="${attributes['name']}-${key_index}" [#if options[key].selected]checked="checked"[/#if] value="${key}" [@macros.append_attributes ["id", "class", "includeFormRow"]/]/><span class="box"></span><span class="label">${options[key].text}</span></label>
    </div>
  [/#list]
  </div>
  [@macros.errors/]
</div>