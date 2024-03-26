/*
 * Copyright (c) 2020-2023, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

FusionAuth.UI.Main = {
  initialize: function() {
    // Delegate tooltip initialization, we could also move all of this into the ToolTip widget.
    Prime.Document.addDelegatedEventListener('mouseover', '[data-tooltip]', function(event, target) {
      if (typeof (target.toolTipObject) === 'undefined') {
        target.toolTipObject = new Prime.Widgets.Tooltip(target).withClassName('tooltip').initialize();
      }
    });

    // Debounce all toggles to keep them from going cray-cray.
    Prime.Document.addDelegatedEventListener('click', 'label.toggle', function(e, target) {
      var toggle = new Prime.Document.Element(target);

      // Debounce the switch yo!
      toggle.setStyle('pointer-events', 'none');
        setTimeout(function() {
          toggle.setStyle('pointer-events', null);
        }, 700);
    });

    Prime.Document.query('[data-slide-open]').each(function(e) {
      e.addEventListener('change', function() {
        var dataSet = e.getDataSet();
        var element = Prime.Document.queryById(dataSet.slideOpen);
        if (typeof (element.slideOpenObject) === 'undefined') {
          element.slideOpenObject = new Prime.Effects.SlideOpen(element);
        }

        // Use isDefined, even a string with an empty value is ok, this means we are using an un-selected value.
        if (Prime.Utils.isDefined(dataSet.slideOpenValue)) {
          if (e.is('[type=checkbox], [type=radio]')) {
            if (e.getValue() === dataSet.slideOpenValue) {
              if (e.isChecked()) {
                element.slideOpenObject.open();
              } else {
                element.slideOpenObject.close();
              }
            }
          } else {
            if (e.getValue() === dataSet.slideOpenValue) {
              element.slideOpenObject.open();
            } else {
              element.slideOpenObject.close();
            }
          }
        } else {
          // Optionally invert the behavior with a slide-closed-value
          if (Prime.Utils.isDefined(dataSet.slideClosedValue)) {
             if (e.getValue() === dataSet.slideClosedValue) {
                element.slideOpenObject.close();
              } else {
                element.slideOpenObject.open();
              }
          } else {
            element.slideOpenObject.toggle();
          }
        }

        // Allow two separate sections, one to be opened, and the other to be closed in unison
        if (dataSet.slideClosed) {
          var slideClosed = Prime.Document.queryById(dataSet.slideClosed);
          if (typeof (element.slideClosedObject) === 'undefined') {
            element.slideClosedObject = new Prime.Effects.SlideOpen(slideClosed);
          }

          element.slideClosedObject.toggle();
        }
      });
    });

    Prime.Document.query('.multiple-select').each(function(e) {
      new Prime.Widgets.MultipleSelect(e)
          .withCustomAddEnabled(true)
          .withErrorClassHandling('error')
          .withRemoveIcon('')
          .initialize();
    });

    Prime.Document.query('.alert').each(function(e) {
      var dismissButton = e.queryFirst('a.dismiss-button');
      if (dismissButton !== null) {
        new Prime.Widgets.Dismissable(e, dismissButton).initialize();
      }
    });

    var sideBar = Prime.Document.queryFirst('.app-sidebar-toggle');
    if (sideBar !== null) {
      new FusionAuth.Admin.UserSearchBar();
      new Prime.Widgets.SideMenu(Prime.Document.queryFirst('.app-sidebar-toggle'), Prime.Document.queryFirst('.app-sidebar'))
          .withOptions({
            'closedClass': 'app-sidebar-closed',
            'openClass': 'app-sidebar-open'
          })
          .initialize();

      new Prime.Widgets.TreeView(Prime.Document.queryFirst('.treeview')).withFolderToggleClassName('folder-toggle').initialize();
    }

    // Handle the focus for widgets
    Prime.Document.query('input').each(function(input) {
      input.addEventListener('focus', function(event) {
        new Prime.Document.Element(event.target).getParent().addClass('focus');
      }).addEventListener('blur', function(event) {
        new Prime.Document.Element(event.target).getParent().removeClass('focus');
      });
    });

    // Handle vertical scroll so that we can preserve the page header, especially on long moderation queues
    var header = Prime.Document.queryFirst('header.page-header');

    function _handlePageScroll() {
      if (window.pageYOffset >= stickyHeight) {
        header.addClass('sticky');
      } else {
        header.removeClass('sticky');
      }
    }

    if (header !== null) {
      window.onscroll = _handlePageScroll;
      // app header height is 45
      var stickyHeight = header.getOffsetTop() - 45;
    }

    // Wire up SplitButtons
    Prime.Document.query('.split-button').each(function(sb) {
      new Prime.Widgets.SplitButton(sb).initialize();
    });

    // Wire up spoilers.
    Prime.Document.query('a[data-spoiler]').each(function(element) {
        element.domElement.spoilerObject = new FusionAuth.UI.Spoiler(element, element.getDataAttribute('spoilerStorageKey')).initialize();
    });

    // Handle the temporary pause of the runtime mode warning
    var pauseRuntimeNotice = Prime.Document.queryById('pause-runtime-notice');
    var runtimeModeCookie = ('; ' + document.cookie).split('; fusionauth.runtimeMode=').pop().split(';').shift();
    if (runtimeModeCookie === '') {
      Prime.Document.query('.runtime-mode-notice').show();
      if (pauseRuntimeNotice !== null) {

        pauseRuntimeNotice.addEventListener('click', function() {
          Prime.Document.query('.runtime-mode-notice').hide();

          // Hide for 60 minutes
          document.cookie = 'fusionauth.runtimeMode=hidden; path=/; Max-Age=3600;'
        });
      }
    }
  }
};

Prime.Document.onReady(FusionAuth.UI.Main.initialize);

// Maintain nav scroll position. Use native JS, we could also just capture the scrollTop position on a scroll end
// event instead of using onbeforeunload.
document.addEventListener("DOMContentLoaded", function() {
  const nav = document.querySelector('.app-sidebar nav .treeview');
  if (nav) {
    var scrollTop = localStorage.getItem('nav.scrollTop');
    if (scrollTop) {
      nav.scrollTo(0, parseInt(scrollTop));
    }
  }
});

window.onbeforeunload = function(e) {
  const nav = document.querySelector('.app-sidebar nav .treeview');
  localStorage.setItem('nav.scrollTop', nav.scrollTop);
};
