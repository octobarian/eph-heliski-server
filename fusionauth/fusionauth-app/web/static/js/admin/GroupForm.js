/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles AJAX loading of application roles on the Group Forms
 * @constructor
 */
FusionAuth.Admin.GroupForm = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('group-form').addEventListener('click', this._handleRoleCheckboxClick);
  this.tenantSelect = this.form.queryFirst('select[name="tenantId"]');
  this.tenantHidden = this.form.queryFirst('input[name="tenantId"]');
  if (this.tenantSelect !== null) {
    this.tenantSelect.addEventListener('change', this._handleTenantChange);

    // Disable the roles if necessary
    this._toggleApplicationRoles(this.tenantSelect.getSelectedValues()[0]);
  } else {
    this._toggleApplicationRoles(this.tenantHidden.getValue());
  }
};

FusionAuth.Admin.GroupForm.constructor = FusionAuth.Admin.GroupForm;
FusionAuth.Admin.GroupForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  /**
   * Handles a roles change event.
   * @param event {MouseEvent} The Click Event.
   * @private
   */
  _handleRoleCheckboxClick: function(event) {
    var checkbox = new Prime.Document.Element(event.target);
    if (!checkbox.is('input[type="checkbox"]')) {
      return;
    }

    var checked = checkbox.isChecked();
    var superRole = checkbox.getDataAttribute('superRole') === 'true';
    if (superRole && checked) {
      this.rolesDiv.query('input[data-super-role=false]').each(function(checkbox) {
        checkbox.setChecked(false)
            .setDisabled(true);
      });
    } else if (superRole && !checked) {
      this.rolesDiv.query('input[data-super-role=false]').each(function(checkbox) {
        checkbox.setDisabled(false);
      });
    }
  },

  _handleTenantChange: function() {
    var tenantId = this.tenantSelect.getSelectedValues()[0];
    this._toggleApplicationRoles(tenantId);
  },

  _toggleApplicationRoles: function(tenantId) {
    // Disable all roles
    this.form.query('[data-tenant-id]').hide();
    this.form.query('input[name="roleIds"]').setDisabled(true);

    // Enable roles that belong to this tenant
    if (tenantId !== "") {
      var applicationRoles = this.form.query('[data-tenant-id="' + tenantId + '"]');
      if (applicationRoles.length === 0) {
        Prime.Document.queryById('no-application-roles').show();
      } else {
        Prime.Document.queryById('no-application-roles').hide();
        this.form.query('[data-tenant-id="' + tenantId + '"] input[name="roleIds"]')
            .setDisabled(false);
        applicationRoles.show();
      }
    }
  }
};
