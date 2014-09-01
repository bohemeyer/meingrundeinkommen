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


]