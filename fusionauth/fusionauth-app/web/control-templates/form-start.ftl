[#ftl/]
[#import "_macros.ftl" as macros/]
<form [@macros.append_attributes/] [#if attributes['ajax']?? && attributes['ajax']]data-ajax="true"[/#if] [#if attributes['ajaxSuccessURI']?? && attributes['ajaxSuccessURI'] != '']data-ajax-success-uri="${attributes['ajaxSuccessURI']}"[/#if] [#if attributes['searchResults']??]data-search-results="${attributes['searchResults']}"[/#if]>
[#if csrfToken?? && attributes['method']?? && attributes['method']?lower_case == "post"]
  <input type="hidden" name="primeCSRFToken" value="${csrfToken}">
[/#if]