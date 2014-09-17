window.App = angular.module('grundeinkommen', ['ui.bootstrap','rails','ngRoute','ng-breadcrumbs','Devise','sticky','ngCookies','login','reset_password','home','register','profile','wishpage','content','smoothScroll','angulartics','angulartics.google.analytics','faq','draw'])

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


#TODO decorate selectDirective (see binding "change" for `Single()` and `Multiple()`)
.config([
  "$provide"
  ($provide) ->
    inputDecoration = [
      "$delegate"
      "inputsWatcher"
      ($delegate, inputsWatcher) ->
        linkDecoration = (scope, element, attrs, ngModel) ->
          handler = undefined
          if attrs.type is "checkbox"
            inputsWatcher.registerInput handler = ->
              value = element[0].checked
              ngModel.$setViewValue value  if value and ngModel.$viewValue isnt value
              return

          else if attrs.type is "radio"
            inputsWatcher.registerInput handler = ->
              value = attrs.value
              ngModel.$setViewValue value  if element[0].checked and ngModel.$viewValue isnt value
              return

          else
            inputsWatcher.registerInput handler = ->
              value = element.val()
              ngModel.$setViewValue value  if (ngModel.$viewValue isnt `undefined` or value isnt "") and ngModel.$viewValue isnt value
              return

          scope.$on "$destroy", ->
            inputsWatcher.unregisterInput handler
            return

          link.apply this, [].slice.call(arguments, 0)
          return
        directive = $delegate[0]
        link = directive.link
        directive.compile = compile = (element, attrs, transclude) ->
          linkDecoration

        delete directive.link

        return $delegate
    ]
    $provide.decorator "inputDirective", inputDecoration
    $provide.decorator "textareaDirective", inputDecoration
]).factory "inputsWatcher", [
  "$interval"
  "$rootScope"
  ($interval, $rootScope) ->
    execHandlers = ->
      i = 0
      l = handlers.length

      while i < l
        handlers[i]()
        i++
      return
    INTERVAL_MS = 500
    promise = undefined
    handlers = []
    return (
      registerInput: registerInput = (handler) ->
        promise = $interval(execHandlers, INTERVAL_MS)  if handlers.push(handler) is 1
        return

      unregisterInput: unregisterInput = (handler) ->
        handlers.splice handlers.indexOf(handler), 1
        $interval.cancel promise  if handlers.length is 0
        return
    )
]


#################################################

.controller "AppCtrl", [
  "$scope"
  "Security"
  "breadcrumbs"
  "Home"
  "$modal"
  ($scope, Security, breadcrumbs, Home, $modal) ->
    $scope.currentUser = Security.currentUser
    $scope.breadcrumbs = breadcrumbs

    $scope.browser = {}
    isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    $scope.browser.isFirefox = typeof InstallTrigger isnt "undefined" # Firefox 1.0+
    $scope.browser.isChrome = !!window.chrome and not isOpera # Chrome 1+

    $scope.bge_info = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/was_ist_grundeinkommen.html"
        size: 'md'
      )
      return

    Home.query().then (home) ->
      $scope.home = home

      $scope.home.financedIncomes = []

      $scope.percentage = home.percentage

      for fi in [1..home.totallyFinancedIncomes]
        $scope.home.financedIncomes.push "#{fi}. Grundeinkommen mit 12.000€ per Crowdfunding finanziert!"

    CurrentDate = new Date()
    Verlosung = new Date("September, 19, 2014")
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
