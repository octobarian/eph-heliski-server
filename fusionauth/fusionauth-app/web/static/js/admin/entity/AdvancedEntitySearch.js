/*
 * Copyright (c) 2021-2023, FusionAuth, All Rights Reserved
 */
'use strict';

/**
 * Handles advanced AJAX entity search tab.
 *
 */
class AdvancedEntitySearch extends AbstractAdvancedSearch {
  static STORAGE_KEY = 'io.fusionauth.entity.advancedSearch';
  static NEXT_RESULTS_MAPPING_KEY = 'io.fusionauth.entity.advancedSearch.nextResultsMapping';
  static DEFAULT_SEARCH_CRITERIA = {
    's.sortFields[0].name': 'name',
    's.sortFields[0].order': 'asc',
    's.sortFields[1].name': 'typeId',
    's.sortFields[1].order': 'asc'
  };

  constructor(form, queryString) {
    super(form, queryString, AdvancedEntitySearch.STORAGE_KEY, AdvancedEntitySearch.NEXT_RESULTS_MAPPING_KEY,
          AdvancedEntitySearch.DEFAULT_SEARCH_CRITERIA);

    this.tenantSelect = form.queryFirst('select[name="s.tenantId"]');

    this.entityTypeSelect = form.queryFirst('select[name="s.typeId"]');
    this.anyEntitTypeOption = this.entityTypeSelect.queryFirst('option').getOuterHTML();

    if (this.ajaxSearch.searchCriteria['s.typeId']) {
      this.entityTypeSelect.setSelectedValues(this.ajaxSearch.searchCriteria['s.typeId']);
    }
    if (this.ajaxSearch.searchCriteria['s.tenantId']) {
      this.tenantSelect.setSelectedValues(this.ajaxSearch.searchCriteria['s.tenantId']);
    }

    this.ajaxSearch.search();
  }

}
