/*
 * Copyright (c) 2022, FusionAuth, All Rights Reserved
 */

class FusionAuthMaintenanceMode {
  constructor() {
    document.addEventListener('change', () => this._handleRadioChange());
    this.warningDiv = document.getElementById('mysql-warning');
    this._handleRadioChange();
  }

  _handleRadioChange() {
    const value = document.querySelector('input[name="database.dbType"]:checked').value;
    this.warningDiv.style.display = (value === 'postgresql' ? 'none' : 'block');
  }
}

document.addEventListener('readystatechange', () => new FusionAuthMaintenanceMode());