[#ftl/]
[#import "_macros.ftl" as macros/]
[@macros.dynamic_attributes/]
<input type="hidden" name="__a_${attributes['name']}" value="${(actionURI!'')}"/>
<input type="image" class="${macros.class('image')}" [@macros.append_attributes/]/>