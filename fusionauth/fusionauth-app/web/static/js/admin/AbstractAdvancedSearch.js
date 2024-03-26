/*
 * Copyright (c) 2023, FusionAuth, All Rights Reserved
 */
'use strict';

/**
* Abstract implementation of Advanced search to be extended for each page with extended search needs
*/
class AbstractAdvancedSearch {
  #storageKey;
  #nextResultsMapping;

  constructor(form, queryString, storageKey, nextResultsMapping, defaultSearchCriteria) {

    this.#storageKey = storageKey;
    this.#nextResultsMapping = nextResultsMapping;

    // until we rewrite AJAXSearchForm these need to be Prime elements
    const resultDiv = Prime.Document.queryById('advanced-search-results');
    const container = resultDiv.queryUp('.panel');
    this.ajaxSearch = new FusionAuth.Admin.AJAXSearchForm()
        .withContainer(container)
        .withDefaultSearchCriteria(defaultSearchCriteria)
        .withForm(form)
        .withPostSuccessCallback(this.#handleSearchSuccess.bind(this))
        .withResultDiv(resultDiv)
        .withStorageKey(this.#storageKey)
        .withFormResetCallback(this.#handleSearchReset.bind(this))
        .initialize(queryString);

    if (!this.#getNextResultsMapping()) {
      this.#saveNextResultsMapping({});
    }

    form.query('a[name="reset"]').addEventListener('click', this.#handleSearchReset.bind(this));
  }

  #handleSearchSuccess() {
    const mapping = this.#getNextResultsMapping();

    document.querySelectorAll('a[data-prev-result-page]').forEach(prevPageElem => {
      const value = Number(prevPageElem.dataset.prevResultPage);
      if (mapping[value]) {
        prevPageElem.classList.remove('hidden');
      }
      prevPageElem.addEventListener('click', this.#callPreviousResults.bind(this))
    });

    document.querySelectorAll('[data-next-result-page]')
            .forEach(saElem => saElem.addEventListener('click', this.#callNextResults.bind(this)));

    const currentPage = this.#getCurrentPage();
    document.querySelectorAll("[data-furthest-results-ref]").forEach(furthestRef => {
      const lastPageVisited = Object.keys(mapping).sort().pop();
      if (lastPageVisited && lastPageVisited > currentPage + 3) {
        furthestRef.classList.remove('hidden');
        furthestRef.dataset.prevResultPage = lastPageVisited;
        furthestRef.href = `?currentPage=${lastPageVisited}`;
        furthestRef.addEventListener('click', this.#callPreviousResults.bind(this));
        document.querySelectorAll('[data-furthest-page-ref]')
                .forEach(furthestPageRef => furthestPageRef.classList.add('hidden'));
      }
    });
  };

  #callNextResults(event) {
    event.preventDefault();

    const nextElem = document.querySelector('[data-next-result-page]');
    const nextPage = Number(nextElem.dataset.nextResultPage);

    this.ajaxSearch.searchCriteria['currentPage'] = nextPage - 1;

    const nextResultsElem = document.querySelector('input[name="nextResults"]');
    if (nextResultsElem) {
      const nextResults = nextResultsElem.value;
      this.#saveNextSearch(nextPage, nextResults);
      this.#addNextResultsToSearchCriteria(nextResults);
      this.ajaxSearch.saveCriteria();
      this.ajaxSearch.search();
    }
  }

  #callPreviousResults(event) {
    event.preventDefault();

    const currentPage = Number(event.currentTarget.dataset.prevResultPage);

    this.ajaxSearch.searchCriteria['currentPage'] = currentPage - 1;

    const prev = this.#getNextResultsMapping()[currentPage];
    if (prev) {
      this.#addNextResultsToSearchCriteria(prev);
    }

    this.ajaxSearch.saveCriteria();
    this.ajaxSearch.search();
  };

  #saveNextSearch(currentPage, nextResults) {
    if (nextResults) {
      const mapping = this.#getNextResultsMapping();
      mapping[currentPage] = nextResults;
      this.#saveNextResultsMapping(mapping);
    }
  };

  #addNextResultsToSearchCriteria(nextResults) {
    this.ajaxSearch.searchCriteria['s.nextResults'] = nextResults;
    this.ajaxSearch.searchCriteria['s.startRow']="0";
  }

  #getCurrentPage() {
    const currentElem = document.querySelector("a[class=current]");
    if (currentElem) {
      return Number(currentElem.innerText);
    }
  }

  #getNextResultsMapping() {
    const mapping = sessionStorage.getItem(this.#nextResultsMapping);
    return mapping ? JSON.parse(mapping) : {};
  }

  #saveNextResultsMapping(mapping) {
    sessionStorage.setItem(this.#nextResultsMapping, JSON.stringify(mapping))
  }

  #handleSearchReset() {
    delete this.ajaxSearch.searchCriteria['s.nextResults'];
    this.#saveNextResultsMapping({})
  }
}
