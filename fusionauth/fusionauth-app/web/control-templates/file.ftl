[#ftl/]
[#import "_macros.ftl" as macros/]
<div class="form-row">
  [#assign classList = macros.class('file')/]
  [@macros.dynamic_attributes/]
  [@macros.control_label/]
  <input type="file" class="${classList}" [@macros.append_attributes/]/>
  [@macros.errors/]
</div>