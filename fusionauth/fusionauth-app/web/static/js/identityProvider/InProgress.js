/*
 * Copyright (c) 2021, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};
Prime.Document.onReady(function() {
  var panel = Prime.Document.queryFirst('.panel[data-in-progress]');
  if (panel === null) {
    panel = Prime.Document.queryFirst('.panel'); // Fallback for backwards compatibility
  }
  if (panel !== null) {
    FusionAuth = FusionAuth || {};
    FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};
    FusionAuth.IdentityProvider.InProgress = new Prime.Widgets.InProgress(panel);
  }
});
