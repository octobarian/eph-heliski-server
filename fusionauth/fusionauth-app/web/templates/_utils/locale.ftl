[#ftl/]
[#-- @ftlvariable name="locales" type="java.util.Locale[]" --]

[#macro select selectedLocale]
<label class="select">
  <select>
    [#list locales as locale]
      <option value="${locale}"[#if locale == selectedLocale] selected[/#if]>${locale.displayName}</option>
    [/#list]
  </select>
</label>
[/#macro]
