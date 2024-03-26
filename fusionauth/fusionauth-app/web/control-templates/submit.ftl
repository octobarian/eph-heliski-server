[#ftl/]
[#import "_macros.ftl" as macros/]
[@macros.dynamic_attributes/]
<input type="hidden" name="__a_${attributes['name']}" value="${(actionURI!'')}"/>
<input type="submit" class="blue button" [@macros.append_attributes/]/>
