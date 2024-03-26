/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the dashboard.
 *
 * @constructor
 */
FusionAuth.Admin.Dashboard = function(labels, data, displayMap) {
  Prime.Utils.bindAll(this);

  this.element = document.getElementById('login-chart');

  this.loginChartData = {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        label: '# of Logins',
        data: data,
        backgroundColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 0.2),
        borderColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 1),
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true,
            callback: function(label) {
              return Intl.NumberFormat(FusionAuth.LanguageTag, {}).format(label);
            }
          }
        }]
      }
      // I'd like to format the value in the tooltip as well. To do this well, we would have to create a
      // template.
      // See https://www.chartjs.org/docs/latest/configuration/tooltip.html#tooltip-callbacks
      //     https://stackoverflow.com/questions/28568773/javascript-chart-js-custom-data-formatting-to-display-on-tooltip
    }
  };

  var panel = Prime.Document.queryById('hourly-logins');
  this.loginChart = new FusionAuth.UI.Chart(panel)
      .withLocalStorageKey('dashboard.login-chart')
      .withConfiguration(this.loginChartData)
      .initialize();

  // Setup the proxy report callback
  this.proxyReportPanel = Prime.Document.queryById('proxy-report-result');
  this.expectedNonce = this.proxyReportPanel.getDataAttribute('nonce');
  Prime.Window.addEventListener('message', this._handleProxyReportResult);

  // We could store limit and offset in local storage and let people paginate perhaps?
  if (displayMap) {
    var vector = new ol.layer.Heatmap({
      blur: 15,
      radius: 12,
      source: new ol.source.Cluster({
        distance: 40,
        source: new ol.source.Vector({
          format: new ol.format.GeoJSON(),
          url: '/ajax/report/login-locations?limit=100',
        })
      })
    });

    var raster = new ol.layer.Tile({
      source: new ol.source.OSM(),
    });

    // Note, all kinds of cools stuff we could do here.
    // 1. On zoom adjust, center position, etc, drop local storage.
    // 2. Different marker for current user.
    // 3. Add row action or something to click on a recent login to jump to position on th map

    var heatMap = Prime.Document.queryById('login-heat-map');
    var longitude = parseInt(heatMap.getDataAttribute('initialLongitude') || '-104.9847');
    var latitude = parseInt(heatMap.getDataAttribute('initialLatitude') || '39.73915');

    this.map = new ol.Map({
      target: 'login-heat-map',
      layers: [raster, vector],
      view: new ol.View({
        center: ol.proj.fromLonLat([longitude, latitude]),
        zoom: 3.5
      })
    });
  }
};

FusionAuth.Admin.Dashboard.constructor = FusionAuth.Admin.Dashboard;
FusionAuth.Admin.Dashboard.prototype = {
  _handleProxyReportResult: function(event) {
    if (event.data.nonce === this.expectedNonce) {
      this.proxyReportPanel.setHTML(event.data.html);
    }
  }
};
