/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

/**
 * Handles advanced AJAX user search tab.
 *
 */
class AdvancedUserSearch extends AbstractAdvancedSearch {
  static STORAGE_KEY = 'io.fusionauth.advancedUserSearch';
  static NEXT_RESULTS_MAPPING_KEY = 'io.fusionauth.advancedUserSearch.nextResultsMapping';
  static DEFAULT_SEARCH_CRITERIA = {
    's.sortFields[0].name': 'login',
    's.sortFields[0].order': 'asc',
    's.sortFields[1].name': 'fullName',
    's.sortFields[1].order': 'asc'
  };

  constructor(form, queryString) {
    super(form, queryString, AdvancedUserSearch.STORAGE_KEY, AdvancedUserSearch.NEXT_RESULTS_MAPPING_KEY,
          AdvancedUserSearch.DEFAULT_SEARCH_CRITERIA);

    this.tenantSelect = form.queryFirst('select[name="tenantId"]');
    if (this.tenantSelect !== null) {
      this.tenantSelect.addEventListener('change', this.#handleTenantChange.bind(this));
    }

    this.applicationSelect = form.queryFirst('select[name="applicationId"]');
    this.applicationSelect.addEventListener('change', this.#handleApplicationChange.bind(this));
    this.anyApplicationOption = this.applicationSelect.queryFirst('option').getOuterHTML();

    this.roleSelect = form.queryFirst('select[name="role"]');
    this.anyRoleOption = this.roleSelect.queryFirst('option').getOuterHTML();

    this.groupSelect = form.queryFirst('select[name="groupId"]');
    if (this.groupSelect !== null) {
      this.anyGroupOption = this.groupSelect.queryFirst('option').getOuterHTML();
    }

    this.selectedRole = null;

    // See #handleRolesRequestSuccess, set the role so we know it should be selected after we
    // retrieve the applications
    if (this.ajaxSearch.searchCriteria['role']) {
      this.selectedRole = this.ajaxSearch.searchCriteria['role'];
    }
    if (this.ajaxSearch.searchCriteria['applicationId']) {
      this.#handleApplicationChange();
    }

    this.ajaxSearch.search();
  }

  async #handleApplicationChange() {
    const applicationId = this.applicationSelect.getValue();
    if (applicationId === '') {
      this.roleSelect.setHTML(this.anyRoleOption);
      return;
    }

    const params = new URLSearchParams({render: 'options'});

    const resp = await fetch(`/ajax/application/roles/${applicationId}?${params}`);
    if (resp.status === 200) {
      await this.#handleRolesRequestSuccess(resp);
    } else {
      this.ajaxSearch._handleAJAXError({status: resp.status, responseText: await resp.text()});
    }
  }

  async #handleApplicationRequestSuccess(resp) {
    // Attempt to preserve the selected application if it still exists in the AJAX response
    this.selectedApplication = this.applicationSelect.getSelectedValues()[0];
    this.applicationSelect.setHTML(this.anyApplicationOption + await resp.text());
    if (this.selectedApplication !== "") {
      const selected = this.applicationSelect.queryFirst('option[value="' + this.selectedApplication + '"]');
      if (selected != null) {
        selected.setAttribute('selected', 'selected');
      }
    }

    this.applicationSelect.fireEvent('change');
  }

  async #handleGroupRequestSuccess(resp) {
    // Attempt to preserve the selected groupGroupAction.java if it still exists in the response
    this.selectedGroup = this.groupSelect.getSelectedValues()[0];
    this.groupSelect.setHTML(this.anyGroupOption + await resp.text());
    if (this.selectedGroup !== "") {
      const selected = this.groupSelect.queryFirst('option[value="' + this.selectedGroup + '"]');
      if (selected != null) {
        selected.setAttribute('selected', 'selected');
      }
    }
  }

  async #handleRolesRequestSuccess(resp) {
    // Attempt to preserve the selected application role if it still exists in the AJAX response
    this.selectedRole = this.roleSelect.getSelectedValues()[0] || this.selectedRole;
    this.roleSelect.setHTML(this.anyRoleOption + await resp.text());
    if (this.selectedRole !== "") {
      const selected = this.roleSelect.queryFirst('option[value="' + this.selectedRole + '"]');
      if (selected !== null) {
        selected.setAttribute('selected', 'selected');
      }
    }
  }

  /**
   * When the tenant selector changes, retrieve applications for that tenant.
   * @private
   */
  async #handleTenantChange() {
    const tenantId = this.tenantSelect.getValue();
    const params = new URLSearchParams({tenantId});

    const applicationResp = await fetch(`/ajax/application?${params}`);
    if (applicationResp.status === 200) {
      await this.#handleApplicationRequestSuccess(applicationResp);
    } else {
      this.ajaxSearch._handleAJAXError({status: applicationResp.status, responseText: await applicationResp.text()});
    }

    const groupResp = await fetch(`/ajax/group?${params}`);
    if (applicationResp.status === 200) {
      await this.#handleGroupRequestSuccess(groupResp);
    } else {
      this.ajaxSearch._handleAJAXError({status: groupResp.status, responseText: await groupResp.text()});
    }

  }
}
