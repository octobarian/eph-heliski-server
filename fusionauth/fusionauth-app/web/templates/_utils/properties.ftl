[#ftl/]

[#import "message.ftl" as message/]

[#-- Macros --]

[#--
  Properties Table Row - Adds a single row to the properties table.
     -- This only handles strings so you should call either rowEval or display to get the value that is passed in here
 --]
[#macro row nameKey value classes="" id=""]
<tr>
  <td class="top">
    [@message.print key=nameKey/]
    [@message.print key="propertySeparator"/]
  </td>
  <td class="${classes}" id="${id}">
    ${value}
  </td>
</tr>
[/#macro]

[#--
  Properties Table Row (with eval) - Adds a single row to the properties table.
     -- Handles String, int, long, ZonedDateTime, Collections
     -- Handles nested properties that may be null.
 --]
[#macro rowEval nameKey object propertyName="" booleanAsCheckmark=true booleanFalseAsX=false classes=""]
  [@row nameKey=nameKey value=display(object, propertyName, "\x2013", booleanAsCheckmark, booleanFalseAsX) classes=classes/]
[/#macro]

[#--
  Properties Table Row with raw values (no message lookup or eval) - Adds a single row to the properties table.
 --]
[#macro rowRaw name value classes=""]
<tr>
  <td class="top">
    ${name}[@message.print key="propertySeparator"/]
  </td>
  <td class="${classes}">
    ${value}
  </td>
</tr>
[/#macro]

[#macro rowNestedValue nameKey classes=""]
<tr>
  <td class="top">
    [@message.print key=nameKey/]
    [@message.print key="propertySeparator"/]
  </td>
  <td class="${classes}">
  [#nested]
  </td>
</tr>
[/#macro]

[#-- Properties Tables --]
[#macro table classes="properties"]
<table class="${classes}">
  <tbody>
    [#nested/]
  </tbody>
</table>
[/#macro]


[#-- Functions --]

[#--
  Safely display an object property, handling HTML escaping, and handling null and empty by displaying a dash character unless otherwise specified.
     -- Handles HTML Escaping
     -- Substitues null or empty values w/ a dash (or other default value if specified)
     -- Handles Strings, numbers, boolean and collection object types.
 --]
[#function display object propertyName default="\x2013" booleanAsCheckmark=true booleanFalseAsX=false]
  [#assign value=("((object." + propertyName + ")!'')")?eval/]
  [#-- ?has_content is false for boolean types, check it first --]
  [#if value?? && value?is_boolean]
    [#if booleanAsCheckmark]
      [#assign ret]
        [#noautoesc][@displayCheck value=value booleanFalseAsX=booleanFalseAsX/][/#noautoesc]
      [/#assign]
      [#return ret]
    [#else]
      [#return function.message(value?then('yes', 'no'))]
    [/#if]
  [#elseif value?has_content]
    [#if value.class?string?ends_with("java.time.ZonedDateTime")]
      [#-- FreeMarker doesn't have a good way to detect this type, so we're hacking it up nicely. --]
      [#return function.format_zoned_date_time(value, function.message('date-time-format'), zoneId)]
    [#elseif value?has_content && value.class?string?ends_with("java.time.LocalDate")]
      [#return function.format_local_date(value, function.message('date-format'))]
    [#elseif value?is_sequence || value?is_collection]
      [#-- Freemarker complains but Tyler says it is ok --]
      [#return value?join(function.message("listSeparator"), default?is_markup_output?then(default?markup_string, default))]
    [#elseif value?is_number]
      [#return value?string('#,###')]
    [#elseif value?? && value.class.isEnum() ]
      [#-- Translate it if  possible, fall back to the enum name --]
      [#local message = fusionAuth.optionalMessage(value)/]
      [#return (message == "")?then(value, message)/]
    [#else]
      [#-- Freemarker complains but Tyler says it is ok --]
      [#return (value == default?is_markup_output?then(default?markup_string, default))?then(value, value?string)]
    [/#if]
  [#else]
    [#return default]
  [/#if]
[/#function]

[#function displayNumber object propertyName default="\x2013" zeroAsDfeault=false]
  [#assign value=("((object." + propertyName + ")!'')")?eval/]
  [#if value?has_content && value?is_number]
      [#if value == 0 && zeroAsDfeault]
        [#return default]
      [#else]
        [#return value?string('#,###')]
      [/#if]
 [#elseif value?has_content && (value?is_collection || value?is_sequence)]
    [#if value?size == 0 && zeroAsDfeault]
      [#return default]
    [#else]
      [#return value?size?string('#,###') /]
    [/#if]
  [#else]
    [#return default]
  [/#if]
[/#function]

[#function displayBoolean object propertyName booleanAsCheckmark=true]
  [#return display(object propertyName "\x2013" booleanAsCheckmark)]
[/#function]

[#function displayZonedDateTime object propertyName zonedDateTimeFormat="date-time-format" markExpired=false]
  [#assign value=("((object." + propertyName + ")!'')")?eval/]
  [#if value?has_content]
    [#if markExpired && function.is_zoned_date_time_before_now(value)]
      [#return "<span class=\"red-text\">${function.format_zoned_date_time(value, function.message(zonedDateTimeFormat), zoneId)}</span>"?no_esc /]
    [#else]
      [#return function.format_zoned_date_time(value, function.message(zonedDateTimeFormat), zoneId)]
    [/#if]
  [#else]
    [#return "\x2013"]
  [/#if]
[/#function]

[#function expiration value]
  [#if function.is_zoned_date_time_before_now(value)]
   [#return "<span class=\"red-text\">${function.format_zoned_date_time(value, function.message('date-time-format'), zoneId)}</span>"?no_esc /]
  [#else]
   [#return function.format_zoned_date_time(value, function.message('date-time-format'), zoneId)]
  [/#if]
[/#function]

[#macro displayCheck value booleanFalseAsX=false]
  [#-- @ftlvariable name="value" type="boolean" --]
  [#if value]
    <i class="fa fa-check green-text"></i>
  [#elseif booleanFalseAsX]
    <i class="fa fa-times red-text"></i>
  [/#if]
[/#macro]

[#-- Safely display a value from a map, handling HTML escaping, and handling null and empty by displaying a dash character unless otherwise specified.  --]
[#function displayMapValue object key default="\x2013"]
  [#if object?has_content]
    [#return (object[key])!"${default}"]
  [#else]
    [#return default]
  [/#if]
[/#function]

[#-- Safely display an object, most likely a string, handling HTML escaping, and handling null and empty by displaying a dash character unless otherwise specified.  --]
[#function displayObject object default="\x2013"]
  [#if object?has_content]
    [#return (object)]
  [#else]
    [#return default]
  [/#if]
[/#function]

[#function phoneNumber value]
  [#if value == "\x2013"]
    [#return value]
  [#else]
    [#return "<a href=tel:${fusionAuth.phone_parser(value)}>${value}</a>"?no_esc]
  [/#if]
[/#function]

[#-- Truncate the object property at the max length and add a title tag if the length is exceeded. Handles HTML escaping, null or empty values. --]
[#macro truncate object property maxLength default="\x2013"]
  [#assign value=("((object." + property + ")!'')")?eval/]
  [#if value?has_content]
    [#if value?length lte maxLength]
      ${value}
    [#else]
      <span title="${value}">${value?substring(0, maxLength - 1)}&hellip;</span>
    [/#if]
  [#else]
    ${default}
  [/#if]
[/#macro]

[#-- Truncate the object property at the max length and add a title tag if the length is exceeded. Handles HTML escaping, null or empty values. --]
[#function truncateNoTitle object property maxLength default="\x2013"]
  [#assign value=("((object." + property + ")!'')")?eval/]
  [#if value?has_content]
    [#if value?length lte maxLength]
      [#return value]
    [#else]
      [#return value?substring(0, maxLength - 1) + '\x2026']
    [/#if]
  [#else]
    [#return default]
  [/#if]
[/#function]

[#macro definitionList key value translateKey=true translateToolTipKey=true tooltipKey="" horizontal=false icon="" iconToolTipKey="" iconColor="green"]
<dl class="${horizontal?then('horizontal', '')}">
  <dt>
    [#if translateKey]
      [@message.print key="${key}"/]
    [#else]
      ${key}
    [/#if]
  </dt>
  <dd>
    [#if icon != ""]
      <i [#if iconToolTipKey?has_content]data-tooltip="${function.message(iconToolTipKey)}"[/#if] class="${iconColor}-text md-text fa fa-${icon}"></i>&nbsp;
    [/#if]
    [#if tooltipKey?has_content]
      <span [#if tooltipKey?has_content] title="${translateToolTipKey?then(function.message(tooltipKey), tooltipKey)}" data-tooltip="${translateToolTipKey?then(function.message(tooltipKey), tooltipKey)}"[/#if]>${value?has_content?then(value, '\x2013')}</span>
    [#else]
     [#if value?is_markup_output]
       ${value}
     [#elseif value?has_content]
       ${value?string}
     [#else]
        &ndash;
     [/#if]
    [/#if]
  </dd>
</dl>
[/#macro]

[#--Join a collection of items into a string delimited by the separator, a dash will be displayed if the collection is empty. --]
[#function join collection translate=false]
  [#if translate]
    [#local result = ""/]
    [#list collection as v]
      [#if !v?is_first]
        [#local result = result + function.message("listSeparator") + function.message(v)]
      [#else]
        [#local result = result + function.message(v)/]
      [/#if]
    [/#list]
    [#return result?has_content?then(result, "\x2013")]
  [#else]
    [#return collection?join(function.message("listSeparator"), "\x2013")]
  [/#if]
[/#function]