window.App = angular.module('grundeinkommen',
  [
    'app.support', 'app.core', 'app.data', 'app.helper', 'app.auth'
  ])

.config [
  "$routeProvider",
  "$locationProvider",
  "MetaProvider",
  "$translateProvider",
  ($routeProvider, $locationProvider, MetaProvider, $translateProvider) ->
    $locationProvider.html5Mode true
    $routeProvider
    .when '/register',
         redirectTo: () ->
           window.location = "/register"
    .when '/login',
         redirectTo: () ->
           window.location = "/login"
    .otherwise
        redirectTo: "/start"
    MetaProvider
    .when '/crowdapp',
      title: 'Crowdbar'
    .otherwise
        title: 'Mein Grundeinkommen'
]


.config (RailsResourceProvider) ->
  RailsResourceProvider.rootWrapping(false)


.controller "AppCtrl", [
  "$scope"
  "$rootScope"
  "Security"
  "breadcrumbs"
  "Home"
  "Crowdbar"
  "$location"
  "$cookies"
  "$modal"

  ($scope, $rootScope, Security, breadcrumbs, Home, Crowdbar, $location, $cookies, $modal) ->
    $scope.current = Security

    $scope.breadcrumbs = breadcrumbs

    $rootScope.$on '$routeChangeStart', ->
      $rootScope.show_spinner = true
    $rootScope.$on '$routeChangeSuccess', ->
      $rootScope.show_spinner = false


    if $location.search().mitdir || ($cookies["mitdir"] && $cookies["mitdir"]!=null)
      if $location.search().mitdir
        inviter_id = $location.search().mitdir
      else
        inviter_id = parseInt($cookies["mitdir"])
      $scope.current.getInviterDetails(inviter_id)
      .then (user) ->
        $cookies["mitdir"] = inviter_id
        $scope.current.inviter =
          name: user.name
          id: inviter_id
          avatar: user.avatar
          invitation_type: 'link'
          number_of_tandems: user.tandems.length
        if $location.search().mitdir
          $location.path("/tandem")


    $scope.getStatus = (path) ->
      if $location.path().indexOf(path) == 0
        "current"
      else
        ""

    Crowdbar.verify().then (has_crowdbar) ->
      $scope.current.setFlag('hasCrowdbar', has_crowdbar)
      $scope.current.setFlag('hasHadCrowdbar', true) if has_crowdbar

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

    $scope.bge_info = ->
      $modal.open
        templateUrl: "/assets/was_ist_grundeinkommen.html"
        size: 'lg'

    return
]

#################################################

.run [
  "$route"
  "$rootScope"
  "$location"
  "Security"
  "$FB"
  "Meta"
  ($route, $rootScope, $location, Security, $FB, Meta) ->
    Security.requestCurrentUser()
    Security.getSettings()
    Meta.init()
    $FB.init('1410947652520230')
    original = $location.path
    $location.path = (path, reload) ->
      if reload is false
        lastRoute = $route.current
        un = $rootScope.$on("$locationChangeSuccess", ->
          $route.current = lastRoute
          $rootScope.show_spinner = false
          un()
          return
        )
      original.apply $location, [path]
]
