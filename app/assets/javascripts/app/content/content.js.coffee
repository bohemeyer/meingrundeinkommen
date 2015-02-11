angular.module("content", ['ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/info",
      templateUrl: "/assets/info.html"
      label: "So funktioniert's"

    .when "/crowdapp",
      controller: "CrowdbarController"
      templateUrl: "/assets/crowdapp_install.html"

    .when "/crowdbar",
      redirectTo: "/support/crowdbar"

    .when "/cola",
      redirectTo: "/support/cola"

    .when "/cola-getrunken",
      redirectTo: "/support/colagetrunken"

    .when "/crowdbar/install",
      redirectTo: "/support/crowdbar"

    .when "/crowdfunding",
      redirectTo: "/support/crowdfund"

    .when "/crowdfund",
      redirectTo: "/support/crowdfund"

    .when "/crowdcard",
      redirectTo: "/support/crowdcard"

    .when "/wo",
      redirectTo: "/crowdcard/partnerinnen"

    .when "/crowdcard/partnerinnen",
      templateUrl: "/assets/info.html"
      controller: ->
        window.location.href = "https://www.payback.de/pb/partner/id/16380/"

    .when "/100",
      redirectTo: "/support/donate"

    .when "/support",
      redirectTo: "/support/crowdfund"

    .when "/support/:support_type",
      reloadOnSearch: false
      controller: "SupportController"
      templateUrl: "/assets/support.html"
      label: "Unterstützen"
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
    .when "/live",
      redirectTo: "/auslosung"
]