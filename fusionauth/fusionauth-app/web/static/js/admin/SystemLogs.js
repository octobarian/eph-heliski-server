/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 *
 * @constructor
 */
FusionAuth.Admin.SystemLogs = function() {
  Prime.Utils.bindAll(this);
  new Prime.Widgets.Tabs(Prime.Document.queryById('node-tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey('settings.system.logs.node.tabs')
      .withAJAXCallback(this._handleAJAXCallback)
      .initialize();
};

FusionAuth.Admin.SystemLogs.constructor = FusionAuth.Admin.Logs;
FusionAuth.Admin.SystemLogs.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAJAXCallback: function(tabContent) {
    var nodeTabs =  tabContent.queryFirst('.tabs');
    if (nodeTabs != null && !nodeTabs.domElement.tabs) {
      nodeTabs.domElement.tabs = new Prime.Widgets.Tabs(nodeTabs)
          .withErrorClassHandling('error')
          .withLocalStorageKey('settings.system.logs.files.tabs')
          .withSelectCallback(this._handleLogTabSelect)
          .initialize();
    }
  },

  _handleLogTabSelect: function(tab, tabContent) {
    var pre = tabContent.queryFirst('.log-content');
    pre.scrollToBottom();
  }
};
