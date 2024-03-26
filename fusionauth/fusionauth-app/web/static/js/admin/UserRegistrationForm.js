/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles add and edit for the User Registration form.
 *
 * @param currentRoles {Array} The current list of roles that the user has.
 * @param orderedPreferredLanguages {Array} The current ordered list of preferred languages the user has.
 * @constructor
 */
FusionAuth.Admin.UserRegistrationForm = function(currentRoles, orderedPreferredLanguages) {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('registration-form');
  this.currentRoles = currentRoles;
  this.rolesDiv = Prime.Document.queryById('application-roles');

  if (this.rolesDiv !== null) {
    this.rolesDiv.addEventListener('click', this._handleRoleCheckboxClick);
    this.initRoles();
  }

  this.applicationIdSelect = this.form.queryFirst('select[name="registration.applicationId"]');
  if (this.applicationIdSelect !== null) {
    this.applicationIdSelect.addEventListener('change', this._handleApplicationIdChange);

    // On page load, remove the applicationId if it is not selected.
    if (this.applicationIdSelect.getValue() === '') {
      var url = new URL(window.location.href);
      url.searchParams.delete('applicationId');
      window.history.pushState({},'', url);
    }
  }

  this.preferredLanguages = this.form.queryFirst('select[name="registration.preferredLanguages"]');
  if (this.preferredLanguages !== null) {
    new Prime.Widgets.MultipleSelect(this.preferredLanguages)
        .withInitialSelectedOrder(orderedPreferredLanguages)
        .withPreserveDisplayedSelectionOrder(true)
        .withRemoveIcon('')
        .withCustomAddEnabled(false)
        .withPlaceholder('')
        .initialize();
  }
};

FusionAuth.Admin.UserRegistrationForm.prototype = {
  initRoles: function() {
    for (var i = 0; i < this.currentRoles.length; i++) {
      var role = this.currentRoles[i];
      var checkbox = this.rolesDiv.queryFirst('input[value="' + role + '"]');
      // Assuming if this is a super user role it is the only role they have assigned
      if (checkbox.is('[data-super-role="true"]')) {
        checkbox.fireEvent('click');
      } else {
        checkbox.setChecked(true);
      }
    }

    // Disable if requested
    if (this.rolesDiv.getDataAttribute('disabled') === 'true') {
      this.rolesDiv.query('input').setDisabled(true)
    }
  },

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  /**
   * Handles an Application change event.
   * @private
   */
  _handleApplicationIdChange: function() {
    var applicationId = this.applicationIdSelect.getValue();
    var userId = this.form.queryFirst('input[type=hidden][name="userId"]').getValue();
    var tenantId = this.form.queryFirst('input[type=hidden][name="tenantId"]').getValue();

    // Set, or replace the applicationId query parameter.
    // - Because we can POST this form and fail validation on the select element, we need to be able to rebuild
    //   the URL that contains the userId and tenantId.
    var url = new URL(window.location.href);

    // Assume that if the URL does not end with /add that it ends with a URL segment which is the userId
    if (window.location.href.endsWith('/add')) {
      if (userId !== '') {
        url = new URL(window.location.href + '/' + userId);
      }

      if (tenantId !== '') {
        url.searchParams.set('tenantId', tenantId);
      }
    }

    url.searchParams.set('applicationId', applicationId);
    window.location.href = url.toString();
  },

  /**
   * Handles a roles change event.
   * @param event {MouseEvent} The Click Event.
   * @private
   */
  _handleRoleCheckboxClick: function(event) {
    var checkbox = new Prime.Document.Element(event.target);
    var checked = checkbox.isChecked();
    var superRole = checkbox.getDataAttribute('superRole') === 'true';
    if (superRole && checked) {
      this.rolesDiv.query('input[data-super-role="false"]').each(function(checkbox) {
        checkbox.setChecked(false)
                .setDisabled(true);
      });
    } else if (superRole && !checked) {
      this.rolesDiv.query('input[data-super-role="false"]').each(function(checkbox) {
        checkbox.setDisabled(false);
      });
    }
  }
};