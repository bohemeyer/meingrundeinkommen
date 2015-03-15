angular.module("content", ['ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider

      # Routes
      ###################################

      .when "/info",
        templateUrl: "/assets/info.html"
        label: "So funktioniert's"

      .when "/crowdapp",
        controller: "CrowdbarController"
        templateUrl: "/assets/crowdapp_install.html"

      .when "/info/impressum",
        templateUrl: "/assets/impressum.html"
        label: "Impressum"

      .when "/info/nutzungsbedingungen",
        templateUrl: "/assets/nutzungsbedingungen.html"
        label: "Nutzungsbedingungen"

      .when "/info/datenschutz",
        templateUrl: "/assets/datenschutz.html"
        label: "Datenschutz"

      .when "/gewinnspielbedingungen",
        templateUrl: "/assets/gewinnspielbedingungen.html"

      # Redirects
      ###################################
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
        redirectTo: "/support/donate"

      .when "/crowdcard",
        redirectTo: "/support/crowdcard"

      .when "/wo",
        redirectTo: "/crowdcard/partnerinnen"
      .when "/100",
        redirectTo: "/support/donate"

      .when "/support",
        redirectTo: "/support/donate"

      .when "/nutzungsbedingungen",
        redirectTo: "/info/nutzungsbedingungen"

      .when "/impressum",
        redirectTo: "/info/impressum"

      .when "/datenschutz",
        redirectTo: "/info/datenschutz"

      .when "/live",
        redirectTo: "/auslosung"

      # Forwards
      #####################################
      .when "/crowdcard/partnerinnen",
        templateUrl: "/assets/info.html"
        controller: ->
          window.location.href = "https://www.payback.de/pb/partner/id/16380/"

]