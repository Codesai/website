function Cookie(name) {
  'use strict';

  return {
    exists,
    value: exists,
    save,
    saveCookiesAccepted,
    saveCookiesRejected,
    isAValidCookiePolicyOption,
    isRejected
  };

  function exists() {
    return Cookies.get(name);
  }

  function isAValidCookiePolicyOption() {
    return ["accepted", "rejected"].includes(Cookies.get(name));
  }

  function isRejected() {
    return Cookies.get(name) !== "accepted";
  }

  function save() {
    const ONE_HUNDRED_YEARS = 100 * 365;
    Cookies.set(name, true, { expires: ONE_HUNDRED_YEARS });
  }

  function saveCookiesAccepted() {
    const ONE_HUNDRED_YEARS = 100 * 365;
    Cookies.set(name, "accepted", { expires: ONE_HUNDRED_YEARS });
  }

  function saveCookiesRejected() {
    const ONE_HUNDRED_YEARS = 100 * 365;
    Cookies.set(name, "rejected", { expires: ONE_HUNDRED_YEARS });
  }
}