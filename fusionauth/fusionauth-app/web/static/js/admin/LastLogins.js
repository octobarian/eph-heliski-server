/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles AJAX loading of a user's logins
 *
 * @param userId the user's id
 * @constructor
 */
FusionAuth.Admin.LastLogins = function(userId) {
  Prime.Utils.bindAll(this);

  this.userId = userId;
  this.loginOffset = 0;

  this.lastLogins = Prime.Document.queryById('user-last-logins');
  this.update();
};

FusionAuth.Admin.LastLogins.prototype = {
  update: function() {
    new Prime.Ajax.Request('/ajax/user/recent-logins?userId=' + this.userId + '&offset=' + this.loginOffset, 'GET')
        .withSuccessHandler(this._handleAjaxSuccess)
        .withErrorHandler(this._handleAjaxError)
        .go();
  },

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAjaxSuccess: function(xhr) {
    // clear out any tooltips before we trash this part of the dom, otherwise they don't ever get removed.
    this.lastLogins.query('[data-tooltip]').each(function(e) {
      if (e.domElement.tooltips) {
        e.domElement.tooltips.forEach(function(t) {
          t.removeFromDOM();
        });
      }
    });

    this.lastLogins.setHTML(xhr.responseText);

    // plug in the prev and next buttons
    var previousButton = this.lastLogins.query('a.previous');
    if (this.loginOffset === 0) {
      previousButton.addClass('disabled');
    } else {
      previousButton.addEventListener('click', this._handlePreviousClick);
    }

    this.lastLogins.query('a.next').addEventListener('click', this._handleNextClick);
  },

  _handleAjaxError: function(xhr) {
    console.error(xhr.status);
    alert('An unexpected error occurred. Please contact FusionAuth support for assistance');
  },

  _handleNextClick: function(event) {
    Prime.Utils.stopEvent(event);
    this.loginOffset += 10;
    this.update();
  },

  _handlePreviousClick: function(event) {
    Prime.Utils.stopEvent(event);
    this.loginOffset = Math.max(this.loginOffset - 10, 0);
    this.update();
  }
};