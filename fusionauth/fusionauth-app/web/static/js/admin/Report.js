/*
 * Copyright (c) 2018-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Creates a new Report.
 *
 * @constructor
 * @param {Prime.Document.Element|PrimeElement} element the container element of the report form
 */
FusionAuth.Admin.Report = function(element, name) {
  Prime.Utils.bindAll(this);

  this.element = element;
  this.name = name;
  this.date = new Date(); // Default to now
  this.form = this.element.queryFirst('form');

  this.intervalSelect = this.form.queryFirst('select[name=interval]');
  this.intervalHidden = this.form.queryFirst('input[name=interval]');
  this.applicationSelect = Prime.Document.queryById('applicationId').addEventListener('change', this._handleChangeEvent);

  this.searchWidget = null;
  this.search = this.form.queryFirst('input[name="q"]');
  this.userIdInput = this.form.queryFirst('input[name="userId"]');
  if (this.search !== null) {
    this.searchWidget = new FusionAuth.Admin.AJAXSearchWidget(this.search, this.userIdInput)
        .withRenderer(FusionAuth.Admin.AJAXSearchForm.UserIdSearchRenderer)
        .withResultProvider(function(json) {
          return json['users'];
        })
        .withSearchURI('/ajax/user/search.json')
        .withSelectCallback(this.refresh)
        .initialize();
  }

  if (this.intervalSelect !== null) {
    this.intervalSelect.addEventListener('change', this._handleChangeEvent);
  }

  this.prevAnchor = Prime.Document.queryFirst('.report-controls a:first-of-type').addEventListener('click', this._handleClickEvent);
  Prime.Document.queryFirst('.report-controls a:last-of-type').addEventListener('click', this._handleClickEvent);
  this.dateSpan = Prime.Document.queryFirst('.report-controls span');

  this.chart = null;

  this._setInitialOptions();
};

FusionAuth.Admin.Report.prototype = {

  initialize: function() {
    this.refresh();
  },

  refresh: function() {
    var data = {
      'applicationId': this.applicationSelect.getSelectedValues()[0],
      'interval': (this.intervalSelect !== null ? this.intervalSelect.getSelectedValues()[0] : this.intervalHidden.getValue()),
      'instant': this.date.getTime()
    };

    if (this.searchWidget !== null) {
      var currentValue = this.searchWidget.getValue();
      if (currentValue !== null) {
        data.userId = currentValue;
      }
    }

    new Prime.Ajax.Request(this.form.getAttribute('action'), 'GET')
        .withData(data)
        .withSuccessHandler(this._handleRefreshSuccess)
        .withErrorHandler(this._handleError)
        .go()
  },

  withLocalStoragePrefix: function(prefix) {
    this.options['localStorageKeyPrefix'] = prefix;
    return this;
  },

  _handleChangeEvent: function(event) {
    this.refresh();
    Prime.Utils.stopEvent(event);
  },

  _handleClickEvent: function(event) {
    var forward = this.prevAnchor.domElement !== event.currentTarget;
    var interval = this.intervalSelect !== null ? this.intervalSelect.getSelectedValues()[0] : this.intervalHidden.getValue();
    if (interval === 'Hourly') {
      Prime.Date.plusDays(this.date, (forward ? 1 : -1));
    } else if (interval === 'Daily') {
      Prime.Date.plusMonths(this.date, (forward ? 1 : -1));
    } else if (interval === 'Monthly') {
      Prime.Date.plusYears(this.date, (forward ? 1 : -1));
    } else if (interval === 'Yearly') {
      Prime.Date.plusYears(this.date, (forward ? 1 : -1));
    }

    this.refresh();
    Prime.Utils.stopEvent(event);
  },

  _handleError: function(xhr) {
    if (xhr.status === 401) {
      location.reload();
    } else {
      alert('Unexpected error. Try refreshing the page');
    }
  },

  _handleRefreshSuccess: function(xhr) {
    var reportData = JSON.parse(xhr.responseText);
    this.dateSpan.setHTML(reportData.dateDisplay);

    var chartData = {
      type: 'bar',
      data: {
        labels: reportData.labels,
        datasets: [
          {
            label: this.name,
            data: reportData.data,
            backgroundColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 0.2),
            borderColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 1),
            borderWidth: 1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
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

    if (this.chart !== null) {
      this.chart.destroy();
    }

    this.chart = new FusionAuth.UI.Chart(this.element)
        .withLocalStorageKey(this.options['localStoragePrefix'] + 'type')
        .withConfiguration(chartData)
        .initialize();
  },

  _setInitialOptions: function() {
    // Defaults
    this.options = {
      'localStoragePrefix': '_report_'
    };

    var userOptions = Prime.Utils.dataSetToOptions(this.form);
    for (var option in userOptions) {
      if (userOptions.hasOwnProperty(option)) {
        this.options[option] = userOptions[option];
      }
    }
  }
};