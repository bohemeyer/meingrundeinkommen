window.App = angular.module('grundeinkommen', ['ui.bootstrap','rails','ngRoute','ng-breadcrumbs','Security','ngCookies','login','reset_password','home','register','profile','wishpage','content','smoothScroll','faq','draw','drawfrontend', 'Support','djds4rce.angular-socialshare','admin','blog','boarding','Crowdbar','Crowdcard'])

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


.controller "AppCtrl", [
  "$scope"
  "Security"
  "breadcrumbs"
  "Home"
  "Crowdbar"
  "$location"

  ($scope, Security, breadcrumbs, Home, Crowdbar, $location) ->

    $scope.current = Security

    $scope.breadcrumbs = breadcrumbs

    $scope.getStatus = (path) ->
      if $location.path().indexOf(path) == 0
        "current"
      else
        ""

    $scope.browser = {}
    ua = navigator.userAgent.match(/chrome|firefox|safari|opera|msie|trident|iPad|iPhone|iPod/i)[0].toLowerCase()
    isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    $scope.browser.isFirefox = typeof InstallTrigger isnt "undefined" # Firefox 1.0+
    $scope.browser.isChrome = !!window.chrome and not isOpera && !(ua == "ipad" || ua == "iphone" || ua == "ipod") # Chrome 1+
    $scope.browser.isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0 && !(ua == "ipad" || ua == "iphone" || ua == "ipod")
    $scope.browser.ua = ua

    $scope.participation = {}

    Crowdbar.verify().then (has_crowdbar) ->
      $scope.participation.has_crowdbar = has_crowdbar
      $scope.current.setFlag('hasCrowdbar',has_crowdbar)
      $scope.participation.participates = if $scope.current.user and $scope.current.user.chances.length > 0 then true else false


    #STATS
    Home.query().then (home) ->
      $scope.home = home

      $scope.home.financedIncomes = []

      $scope.percentage = home.percentage

      for fi in [1..home.totallyFinancedIncomes]
        $scope.home.financedIncomes.push "#{fi}. Grundeinkommen mit 12.000€ per Crowdfunding finanziert!"

    # CurrentDate = new Date()
    # Verlosung = new Date("September, 19, 2014")
    # DayCount = (Verlosung - CurrentDate) / (1000 * 60 * 60 * 24)
    # $scope.daysLeft = Math.round(DayCount)

    return
]

#################################################

.run [
  "Security"
  "$FB"
  (Security, $FB) ->
    Security.requestCurrentUser()
    $FB.init('1410947652520230')
]