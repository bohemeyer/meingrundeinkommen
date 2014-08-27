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


]