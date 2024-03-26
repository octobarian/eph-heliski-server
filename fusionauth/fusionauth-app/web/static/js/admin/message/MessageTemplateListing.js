/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.MessageTemplateListing = function() {
  Prime.Utils.bindAll(this);

  var table = Prime.Document.queryFirst('table');
  new FusionAuth.UI.Listing(table)
      .withAJAXCallback(this._handleViewClick)
      .initialize();
};

FusionAuth.Admin.MessageTemplateListing.constructor = FusionAuth.Admin.MessageTemplateListing;
FusionAuth.Admin.MessageTemplateListing.prototype = {
  _handleViewClick: function() {
    var htmlSource = Prime.Document.queryById('html-source');
    if (htmlSource !== null) {
      var html = FusionAuth.Util.unescapeHTML(htmlSource.getHTML());
      var htmlIframe = htmlSource.getParent().queryFirst('iframe').domElement.contentWindow.document;
      htmlIframe.open();
      htmlIframe.write(html);
      htmlIframe.close();
    }
  }
};

