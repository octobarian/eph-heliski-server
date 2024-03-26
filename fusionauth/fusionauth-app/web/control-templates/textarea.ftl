[#ftl/]
[#import "_macros.ftl" as macros/]
[#assign ifr = true/]
[#if attributes['includeFormRow']??]
  [#assign ifr = attributes['includeFormRow']/]
[/#if]
[#if ifr]
<div id="${attributes['id']}-form-row" class="form-row">
[/#if]
[@macros.dynamic_attributes/]
[@macros.control_label/]
<textarea class="${macros.class('textarea')}" [@macros.append_attributes ["value"]/]>${(attributes['value']!'')}</textarea>
[@macros.errors/]
[#if ifr]
</div>
[/#if]
