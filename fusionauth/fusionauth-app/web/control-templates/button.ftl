[#ftl/]
[#import "_macros.ftl" as macros/]
[#assign classList = macros.class('button')/]
[@macros.dynamic_attributes/]
<input type="hidden" name="__a_${attributes['name']}" value="${(actionURI!'')}"/>
<input type="button" class="${classList}" [@macros.append_attributes/]/>
