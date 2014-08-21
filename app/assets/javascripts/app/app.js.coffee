window.App = angular.module('grundeinkommen', ['ui.bootstrap','rails','ngRoute','ng-breadcrumbs','Devise','sticky','ngCookies','login','reset_password','register','profile','wishpage','content','smoothScroll'])

.config [
  "$routeProvider"
  "$locationProvider"
  ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode true
    $routeProvider
    .when "/",
      templateUrl: "/assets/home.html"
      controller: "HomeController"
      label: "Startseite"
    .otherwise
      redirectTo: "/"
]


.config (RailsResourceProvider) ->
  RailsResourceProvider.rootWrapping(false)


#################################################

.controller "AppCtrl", [
  "$scope"
  "Security"
  "breadcrumbs"
  ($scope, Security, breadcrumbs) ->
    $scope.currentUser = Security.currentUser
    $scope.breadcrumbs = breadcrumbs
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
