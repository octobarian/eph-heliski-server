[#ftl/]

[#import "message.ftl" as message/]
[#import "helpers.ftl" as helpers/]

[#-- Macros --]

[#macro action href icon key color="blue" additionalClass="" ajaxView=false ajaxWideDialog=false ajaxForm=false resizeDialog=false id="" attributes...]
<a [#if id?has_content]id="${id}"[/#if] href="${href?starts_with('/')?then(request.contextPath, '')}${href}" [#t/]
   data-tooltip="${function.message(key)}" title="${function.message(key)}" class="small-square button ${color} ${additionalClass}"[#t/]
   [#if ajaxView]data-ajax-view="true"[/#if][#t/]
   [#if ajaxWideDialog]data-ajax-wide-dialog="true"[/#if][#t/]
   [#if ajaxForm]data-ajax-form="true"[/#if][#t/]
   [#if resizeDialog]data-resize-dialog="true"[/#if][#t/]
${helpers.hashToAttributes(attributes)}><i class="fa fa-${icon}"></i></a>
[/#macro]

[#macro ajaxLink href="#" icon="" color="" id="" additionalClass="" tooltipKey="" ajaxView=false ajaxWideDialog=false ajaxForm=false attributes...]
<a [#if id?has_content]id="${id}"[/#if] href="${href?starts_with('/')?then(request.contextPath, '')}${href}" [#t/]
  [#if tooltipKey?has_content]title="${function.message(tooltipKey)}" data-tooltip="${function.message(tooltipKey)}"[/#if] class="${color} ${additionalClass}"[#t/]
  [#if ajaxView]data-ajax-view="true"[/#if][#t/]
  [#if ajaxWideDialog]data-ajax-wide-dialog="true"[/#if][#t/]
  [#if ajaxForm]data-ajax-form="true"[/#if][#t/]
${helpers.hashToAttributes(attributes)}><i class="fa fa-${icon}"></i></a>
[/#macro]

[#macro iconLink href id="" class="square" icon="arrow-right" color="blue" tooltipKey=""]
<a href="${href?starts_with('/')?then(request.contextPath, '')}${href}" class="${color} button ${class}" [#if id?has_content]id="${id}"[/#if][#if tooltipKey?has_content] title="${function.message(tooltipKey)}" data-tooltip="${function.message(tooltipKey)}"[/#if]><i class="fa fa-${icon}"></i></a>
[/#macro]

[#macro iconLinkWithText href id="" class="" icon="arrow-right" color="blue" textKey="submit" tooltipKey="" ajaxView=false ajaxWideDialog=false ajaxForm=false attributes...]
<a href="${href?starts_with('/')?then(request.contextPath, '')}${href}" [#t/]
   class="${color} button ${class}" [#t/]
   [#if id?has_content]id="${id}"[/#if]
   [#if tooltipKey?has_content] title="${function.message(tooltipKey)}" data-tooltip="${function.message(tooltipKey)}"[/#if] [#t/]
   [#if ajaxView]data-ajax-view="true"[/#if][#t/]
   [#if ajaxWideDialog]data-ajax-wide-dialog="true"[/#if][#t/]
   [#if ajaxForm]data-ajax-form="true"[/#if][#t/]
${helpers.hashToAttributes(attributes)}><i class="fa fa-${icon}"></i> [@message.print key=textKey/]</a>
[/#macro]

[#macro formIcon icon="arrow-right" color="blue" textKey="submit" disabled=false autofocus=false name="" value=""]
<button class="${color} button${disabled?then(' disabled', '')}"[#if disabled] disabled="disabled"[/#if][#if autofocus] autofocus="autofocus"[/#if][#if name??]name="${name}"[/#if][#if value??]value="${value}"[/#if]><i class="fa fa-${icon}"></i> [@message.print key=textKey/]</button>
[/#macro]

[#macro iconButton id="" color="blue" tooltipKey="" icon="save" class="square"]
<button class="${color} button ${class}" [#t/]
  [#if tooltipKey?has_content]title="${function.message(tooltipKey)}" data-tooltip="${function.message(tooltipKey)}"[/#if] [#t/]
  [#if id?has_content]id="${id}"[/#if]><i class="fa fa-${icon}"></i></button>
[/#macro]

[#macro iconButtonWithText id="" color="blue" tooltipKey="" textKey="reset" icon="save" class="square"]
<button [#if id?has_content]id="${id}"[/#if] [#t/]
        class="${color} button ${class}" [#t/]
[#if tooltipKey?has_content] title="${function.message(tooltipKey)}" data-tooltip="${function.message(tooltipKey)}"[/#if]><i class="fa fa-${icon}"></i> [@message.print key=textKey/]</button>
[/#macro]
