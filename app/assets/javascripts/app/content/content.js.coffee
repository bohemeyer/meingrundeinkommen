angular.module("content", ['ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/info",
      templateUrl: "/assets/info.html"
      label: "So funktioniert's"
    .when "/crowdbar",
      templateUrl: "/assets/crowdbar.html"
      label: "Die CrowdBar"
    .when "/boost",
       redirectTo: "/crowdbar"
    .when "/support",
      redirectTo: "/crowdbar"



]