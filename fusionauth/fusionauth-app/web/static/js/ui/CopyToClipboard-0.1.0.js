/*
 * Copyright (c) 2022, FusionAuth, All Rights Reserved
 */
'use strict';

class CopyToClipboard {
  constructor() {
    document.addEventListener('click', this._handleClick.bind(this));
  }

  _handleClick(event) {
    const copyButton = event.target.closest('[data-widget="copy-button"]');
    if (copyButton === null) {
      return;
    }

    const id = copyButton.dataset.copySource;
    const source = document.getElementById(id);
    if (source === null) {
      throw `Invalid copy-source [${id}]`;
    }

    // Example: <i class="fa fa-clone p-1" style="border: 1px solid transparent; border-radius: 3px; cursor: pointer; position: absolute; right: 7px; top: 7px;" data-widget="copy-button" data-copy-source="recovery-codes"></i>
    navigator.clipboard
             .writeText(source.innerText)
             .then(() => {
               copyButton.classList.remove('fa-clone');
               copyButton.classList.add('fa-check', 'green-text');
               copyButton.style['border-color'] = '#0f8b72';
               const tooltip = document.createElement('div');
               tooltip.classList.add('mb-1', 'p-1');
               tooltip.style['background-color'] = '#707070';
               tooltip.style['border-radius'] = '.25rem';
               tooltip.style['color'] = '#FFF';
               tooltip.style['z-index'] = 10;
               tooltip.innerHTML = 'Copied <div data-popper-arrow></div>';
               copyButton.parentNode.appendChild(tooltip);
               Popper.createPopper(copyButton, tooltip,
                   {
                     modifiers: [
                       {
                         name: 'offset',
                         options: {
                           offset: [0, 10],
                         },
                       },
                     ],
                     placement: 'top'
                   }
               );
               setTimeout(() => {
                 tooltip.remove();
                 copyButton.classList.remove('fa-check', 'green-text');
                 copyButton.classList.add('fa-clone');
                 copyButton.style['border-color'] = 'transparent';
               }, 1000);
             });
  }
}

document.addEventListener('DOMContentLoaded', () => new CopyToClipboard());