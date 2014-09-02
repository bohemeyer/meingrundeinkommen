window.App = angular.module('grundeinkommen', ['ui.bootstrap','rails','ngRoute','ng-breadcrumbs','Devise','sticky','ngCookies','login','reset_password','home','register','profile','wishpage','content','smoothScroll'])

.config [
  "$routeProvider"
  "$locationProvider"
  ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode true
    $routeProvider
    .otherwise
      redirectTo: "/start"
]


.config (RailsResourceProvider) ->
  RailsResourceProvider.rootWrapping(false)


#################################################

.controller "AppCtrl", [
  "$scope"
  "Security"
  "breadcrumbs"
  "Home"
  ($scope, Security, breadcrumbs, Home) ->
    $scope.currentUser = Security.currentUser
    $scope.breadcrumbs = breadcrumbs

    $scope.browser = {}
    isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    $scope.browser.isFirefox = typeof InstallTrigger isnt "undefined" # Firefox 1.0+
    $scope.browser.isChrome = !!window.chrome and not isOpera # Chrome 1+

    Home.query().then (home) ->
      $scope.home = home

      $scope.home.financedIncomes = []

      $scope.percentage = home.percentage

      for fi in [1..home.totallyFinancedIncomes]
        $scope.home.financedIncomes.push "#{fi}. Grundeinkommen mit 12.000€ per Crowdfunding finanziert!"

    CurrentDate = new Date()
    Verlosung = new Date("September, 18, 2014")
    DayCount = (Verlosung - CurrentDate) / (1000 * 60 * 60 * 24)
    $scope.daysLeft = Math.round(DayCount)

    return
]

.controller "HeaderCtrl", [
  "$scope"
  "Security"
  "$location"
  ($scope,Security,$location) ->
    $scope.security = Security
    $scope.getStatus = (path) ->
      if $location.path() == path
        "current"
      else
        ""
]

#################################################

.run [
  "Security"
  (Security) ->
    Security.requestCurrentUser()
]










# angular.module("grundeinkommen").controller "HeaderCtrl", [
#   "$scope"
#   "$location"
#   "$route"
#   "security"
#   "breadcrumbs"
#   "notifications"
#   "httpRequestTracker"
#   ($scope, $location, $route, security, breadcrumbs, notifications, httpRequestTracker) ->
#     $scope.location = $location
#     $scope.breadcrumbs = breadcrumbs
#     $scope.isAuthenticated = security.isAuthenticated
#     $scope.isAdmin = security.isAdmin
#     $scope.home = ->
#       if security.isAuthenticated()
#         $location.path "/dashboard"
#       else
#         $location.path "/projectsinfo"
#       return

#     $scope.isNavbarActive = (navBarPath) ->
#       navBarPath is breadcrumbs.getFirst().name

#     $scope.hasPendingRequests = ->
#       httpRequestTracker.hasPendingRequests()
# ]
