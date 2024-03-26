/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.UserActionReasonForm = function() {
  new FusionAuth.Admin.LocalizationTable(Prime.Document.queryById('localized-texts'));
};
