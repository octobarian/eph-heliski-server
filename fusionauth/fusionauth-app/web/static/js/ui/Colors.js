/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

FusionAuth.UI.Colors = {
  blueLight: '94, 180, 238',
  blueMedium: '57, 152, 219',
  blueDark: '21, 106, 163',

  yellowLight: '244, 242, 134',
  yellowMedium: '240, 219, 79',
  yellowDark: '231, 201, 1',

  greenLight: '40, 226, 189',
  greenMedium: '11, 183, 150',
  greenDark: '15, 139, 114',

  orangeLight: '255, 194, 135',
  orangeMedium: '255, 156, 61',
  orangeDark: '255, 106, 0',

  redLight: '255, 106, 125',
  redMedium: '238, 62, 84',
  redDark: '200, 27, 61',

  purpleLight: '87, 116, 148',
  purpleMedium: '52, 72, 94',
  purpleDark: '33, 50, 70',

  /**
   * Converts a color and alpha to a CSS rgba statement.
   *
   * @param {string} color The color.
   * @param {number} alpha The alpha value.
   * @returns {string} The result string for CSS.
   */
  toRGBA: function(color, alpha) {
    return 'rgba(' + color + ',' + alpha.toString() + ')';
  }
};