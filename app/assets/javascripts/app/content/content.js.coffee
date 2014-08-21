angular.module("content", ['ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/info",
      templateUrl: "/assets/info.html"
      label: "So funktioniert's"
    .when "/support",
      templateUrl: "/assets/support.html"
      label: "Unterstützen"

]