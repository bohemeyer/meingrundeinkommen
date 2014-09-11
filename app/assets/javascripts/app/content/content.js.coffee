angular.module("content", ['ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/info",
      templateUrl: "/assets/info.html"
      label: "So funktioniert's"
    .when "/crowdbar",
      redirectTo: "/support"
    .when "/crowdbar/install",
      templateUrl: "/assets/crowdbar.html"
      controller: "CrowdBarInstallController"
    .when "/crowdfunding",
      redirectTo: "/support"
    .when "/boost",
      redirectTo: "/support"
    .when "/support",
      templateUrl: "/assets/crowdbar.html"
      label: "Die CrowdBar"
    .when "/info/impressum",
      templateUrl: "/assets/impressum.html"
      label: "Impressum"
    .when "/impressum",
      redirectTo: "/info/impressum"
    .when "/info/nutzungsbedingungen",
      templateUrl: "/assets/nutzungsbedingungen.html"
      label: "Nutzungsbedingungen"
    .when "/nutzungsbedingungen",
      redirectTo: "/info/nutzungsbedingungen"
    .when "/info/datenschutz",
      templateUrl: "/assets/datenschutz.html"
      label: "Datenschutz"
    .when "/datenschutz",
      redirectTo: "/info/datenschutz"
    .when "/gewinnspielbedingungen",
      templateUrl: "/assets/gewinnspielbedingungen.html"


]

.controller "CrowdBarInstallController", [
  () ->
    isOpera = !!window.opera or navigator.userAgent.indexOf(" OPR/") >= 0
    # Opera 8.0+ (UA detection to detect Blink/v8-powered Opera)
    isFirefox = typeof InstallTrigger isnt "undefined" # Firefox 1.0+
    isSafari = Object::toString.call(window.HTMLElement).indexOf("Constructor") > 0
    # At least Safari 3+: "[object HTMLElementConstructor]"
    isChrome = !!window.chrome and not isOpera # Chrome 1+
    isIE = false or !!document.documentMode #@cc_on!@
    # At least IE6
    window.location.href = "https://bar.mein-grundeinkommen.de/extension/crowd_bar/crowd_bar.xpi"  if isFirefox
    window.location.href = "https://chrome.google.com/webstore/detail/crowdbar/lhinknkceoifkecnmmlgnelmdipmbcdn"  if isChrome
]