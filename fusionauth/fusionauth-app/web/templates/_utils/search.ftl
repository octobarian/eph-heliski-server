[#ftl/]
[#-- @ftlvariable name="currentPage" type="int" --]
[#-- @ftlvariable name="defaultMaxHitCount" type="int" --]
[#-- @ftlvariable name="firstResult" type="int" --]
[#-- @ftlvariable name="lastResult" type="int" --]
[#-- @ftlvariable name="maxWindow" type="int" --]
[#-- @ftlvariable name="nextResults" type="java.lang.String" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.BaseSearchCriteria" --]
[#-- @ftlvariable name="total" type="int" --]
[#import "../_utils/message.ftl" as message/]

[#--
  Common Pagination Controls

  All text and rows per page may be overriden by user.
    @see messages/package.properties
--]
[#macro pagination]
<div class="row pagination middle-xs">
  <div class="number-controls col-lg-4 col-xs-12">
    [@message.print key="results-per-page"/]&nbsp;
    <label class="select">
      <select data-name="s.numberOfResults">
        [#list [25, 50, 100, 250, 500] as value]
          [#if s.numberOfResults == value]
            <option selected value="${value}">${value}</option>
          [#else]
            <option value="${value}">${value}</option>
          [/#if]
        [/#list]
      </select>
    </label>
  </div>

  <div class="info col-lg-4 col-xs-12">
    [#--
       Not sure why, but the default grouping separator should be a comma - but it is showing up as a space unless I explictly extend the decimal formatter and specify the groupingSeparator.
       See the same usage in totals.ftl and it works fine without having to specify the groupingSeparator. WTF?
     --]
    [#if total gt 0]
      [@message.print key="displaying-results" values=[firstResult?string[",##0;; groupingSeparator=','"], lastResult?string[",##0;; groupingSeparator=','"], total?string[",##0;; groupingSeparator=','"]] /]
    [#elseif total == -1]
      [@message.print key="displaying-results-unknown" values=[firstResult?string[",##0;; groupingSeparator=','"], lastResult?string[",##0;; groupingSeparator=','"]]/]
    [/#if]
  </div>

  <div class="page-controls col-lg-4 col-xs-12">
    [#--
        We are past the maxWindow of what elastic will return, but we can still navigate forward if we have a valid nextResults token that we can use
        to continue paging. In the javascript we will also be storing the tokens of any pages that we have visited so that we can navigate back to them.
        At this stage in rendering we don't know what the browser has saved in local storage, so for any of the backwards-facing page buttons that are
        outside the bounds of the normal pagination we should render the elements that will take you there but make them hidden. The javascript on the
        client side can then find and unhide these tags once it checks local storage.
    --]
    [#local pastMaxWindow = maxWindow?? && (currentPage * s.numberOfResults gt maxWindow)]
    [#if maxWindow?? && total gt maxWindow]
      [#local pageMax = maxWindow]
    [#else]
      [#local pageMax = s.numberOfResults * numberOfPages]
    [/#if]

    [#if numberOfPages gt 1]
      [#if currentPage gt 2]
        <a href="?s.startRow=0" data-tooltip="${function.message('first')}" title="${function.message('first')}"><i class="fa fa-angle-double-left"></i></a>
      [/#if]
      [#if pastMaxWindow]
          [#-- This is the back-one tag using a previously-reached nextResults token in local storage --]
          <a data-prev-result-page="${currentPage - 1}"
             href="?currentPage=${currentPage - 1}"
             data-tooltip="${function.message('previous')}"
             class="hidden"
             title="${function.message('previous')}">
                 <i class="fa fa-angle-left"></i>
          </a>
      [/#if]
      [#if currentPage gt 1 && firstResult lt total + s.numberOfResults && !pastMaxWindow]
        <a href="?s.startRow=${((currentPage - 2) * s.numberOfResults)?c}" data-tooltip="${function.message('previous')}" title="${function.message('previous')}"><i class="fa fa-angle-left"></i></a>
      [/#if]
      [#if pastMaxWindow ]
        [#list currentPage-3..currentPage-1 as page]
          [#if page * s.numberOfResults lte pageMax]
            [#-- these are pages that can still be reached with normal pagination calls via startRow  --]
            <a href="?s.startRow=${((page - 1) * s.numberOfResults)?c}">${page}</a>
          [#else]
            [#-- render the tags but hide them unless we have their token in local storage --]
            <a href="?currentPage=${page}" data-prev-result-page="${page}" class="hidden">${page}</a>
          [/#if]
        [/#list]
        <a class="current" href="#">${currentPage}</a>
      [#else]
        [#list currentPage-3..currentPage+3 as page]
          [#if numberOfPages gt 1 && page gt 0 && (page * s.numberOfResults) lte pageMax]
            [#if page == currentPage]
              <a class="current" href="#">${page}</a>
            [#else]
              <a href="?s.startRow=${((page - 1) * s.numberOfResults)?c}">${page}</a>
            [/#if]
          [/#if]
        [/#list]
      [/#if]
      [#-- render the forward tags but hide them unless we have their nextResults token in local storage--]
      [#list currentPage+1..currentPage+3 as page]
        [#if maxWindow?? && page * s.numberOfResults gt maxWindow]
          <a href="?currentPage=${page}" data-prev-result-page="${page}" class="hidden">${page}</a>
        [/#if]
      [/#list]
      [#-- forward pages that can be reached with startRow --]
      [#if currentPage * s.numberOfResults lt pageMax && !pastMaxWindow]
        <a href="?s.startRow=${(currentPage * s.numberOfResults)?c}" data-tooltip="${function.message('next')}" title="${function.message('next')}"><i class="fa fa-angle-right"></i></a>
      [/#if]

      [#-- The "next" page tag that can proceed past the maxWindow --]
      [#if maxWindow?? && currentPage * s.numberOfResults gte maxWindow && currentPage * s.numberOfResults lt total]
        <a data-next-result-page="${currentPage + 1}"
           href="?currentPage=${currentPage + 1}"
           data-tooltip="${function.message('next')}"
           title="${function.message('next')}">
               <i class="fa fa-angle-right"></i>
        </a>
      [/#if]

      [#-- This is the furthest page you can reach using startRow. After this we need to start collecting nextResults tokens. --]
      [#if currentPage * s.numberOfResults lt pageMax && !pastMaxWindow]
        <a data-furthest-page-ref href="?s.startRow=${(pageMax - s.numberOfResults)?c}" data-tooltip="${function.message('last')}" title="${function.message('last')}"><i class="fa fa-angle-double-right"></i></a>
      [/#if]

      [#-- This is the furthest nextResults token we have in local storage, will be unhidden by javascript --]
      [#if maxWindow?? && total gt maxWindow]
        <a class="hidden" data-furthest-results-ref data-tooltip="${function.message('last')}" title="${function.message('last')}"><i class="fa fa-angle-double-right"></i></a>
      [/#if]
    [#elseif total == -1]
      <a href="?s.startRow=0" data-tooltip="${function.message('first')}" title="${function.message('first')}" class=${(s.startRow > 0)?then("", "disabled")}><i class="fa fa-angle-double-left"></i></a>
      <a href="?s.startRow=${((currentPage - 2) * s.numberOfResults)?c}" data-tooltip="${function.message('previous')}" title="${function.message('previous')}" class=${(s.startRow > 0)?then("", "disabled")} ><i class="fa fa-angle-left"></i></a>
      <a href="#" class="disabled">&hellip;</a>
      <a href="?s.startRow=${(currentPage * s.numberOfResults)?c}" data-tooltip="${function.message('next')}" title="${function.message('next')}" class=${(firstResult > 0)?then("", "disabled")}><i class="fa fa-angle-right"></i></a>
    [/#if]
  </div>
</div>
[/#macro]
