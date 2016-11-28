function Cookie(site) {
  'use strict';

  return {
    exists: exists,
    save: save
  };

  function exists() {
    return Cookies.get(site);
  }

  function save() {
    var ONE_HUNDRED_YEARS = 100 * 365;
    Cookies.set(site, true, { expires: ONE_HUNDRED_YEARS });
  }
}