[#ftl/]

[#-- Macros --]

[#macro alert message type icon includeDismissButton=true]
<div class="alert ${type}">
  <i class="fa fa-${icon}"></i>
  <p>
    [#noautoesc]${message}[/#noautoesc]
  </p>
  [#if includeDismissButton]
    <a href="#" class="dismiss-button"><i class="fa fa-times-circle"></i></a>
  [/#if]
</div>
[/#macro]

[#macro alertColumn message type icon includeDismissButton=true columnClass=""]
<div class="row center-xs">
  [#-- columnClass may be in scope from another macro --]
  <div class="${columnClass?has_content?then(columnClass, "col-xs")}">
    [@alert message type icon includeDismissButton/]
  </div>
</div>
[/#macro]

[#macro print key values=[]]
  [#local escapedValues = [] /]
  [#list values as value]
    [#local escapedValues += [value?is_string?then(value?esc?markup_string, value)] /]
  [/#list]
  [#noautoesc][@control.message key=key values=escapedValues/][/#noautoesc][#t]
[/#macro]

[#macro printErrorAlerts columnClass=""]
  [#if errorMessages?size > 0]
    [#list errorMessages as m]
      [@alertColumn message=m type="error" icon="exclamation-circle" columnClass=columnClass/]
    [/#list]
  [/#if]
[/#macro]

[#macro printInfoAlerts columnClass=""]
  [#if infoMessages?size > 0]
    [#list infoMessages as m]
      [@alertColumn message=m type="info" icon="info-circle" columnClass=columnClass/]
    [/#list]
  [/#if]
[/#macro]

[#macro printWarningAlerts columnClass=""]
  [#if warningMessages?size > 0]
    [#list warningMessages as m]
      [@alertColumn message=m type="warning" icon="exclamation-triangle" columnClass=columnClass/]
    [/#list]
  [/#if]
[/#macro]


[#-- Functions --]

[#function inline key values=[]]
  [#return function.message(key, values)?no_esc/]
[/#function]

[#-- If the key cannot be resolved, return the defaultValue --]
[#function inlineOptional key defaultValue]
  [#local message = fusionAuth.optionalMessage(key)?no_esc/]
  [#return message?has_content?then(message, defaultValue)/]
[/#function]

[#macro showFieldErrors fieldName]
[#if fieldMessages[fieldName]?has_content]
 <div class="form-row">
   <span class="error">
     [#list fieldMessages[fieldName] as e]
       ${e.message}[#if e_has_next], [/#if]
     [/#list]
   </span>
 </div>
[/#if]
[/#macro]

[#macro showAPIErrorRespones storageKey=""]
[#if request.getAttribute("apiErrorResponse")??]
<div id="api-error-response" class="slide-open">
  <pre class="code scrollable horizontal">${fusionAuth.stringify(request.getAttribute("apiErrorResponse"))}</pre>
</div>
<a href="#" class="slide-open-toggle" style="margin-bottom: 1.5rem !important; margin-top: 1rem;" data-spoiler="api-error-response" data-spoiler-storage-key="${storageKey}">
  <span>[@print key="{tell-me-more}api-error-response"/] <i class="fa fa-angle-down"></i></span>
</a>
[/#if]
[/#macro]