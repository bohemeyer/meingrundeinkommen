window.App = angular.module('grundeinkommen', ['ui.bootstrap','rails','ngRoute','ng-breadcrumbs','Devise','Security','ngCookies','login','reset_password','home','register','profile','wishpage','content','smoothScroll','angulartics','angulartics.google.analytics','faq','draw','drawfrontend', 'Support','djds4rce.angular-socialshare','admin','blog'])

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
  "$modal"
  "Support"
  "$timeout"
  "$interval"
  "$routeParams"
  "$location"
  "$http"

  ($scope, Security, breadcrumbs, Home, $modal, Support, $timeout, $interval, $routeParams, $location, $http) ->
    $scope.security = Security

    $scope.breadcrumbs = breadcrumbs

    $scope.browser = {}
    ua = navigator.userAgent.match(/chrome|firefox|safari|opera|msie|trident|iPad|iPhone|iPod/i)[0].toLowerCase()
    isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    $scope.browser.isFirefox = typeof InstallTrigger isnt "undefined" # Firefox 1.0+
    $scope.browser.isChrome = !!window.chrome and not isOpera && !(ua == "ipad" || ua == "iphone" || ua == "ipod") # Chrome 1+
    $scope.browser.isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0 && !(ua == "ipad" || ua == "iphone" || ua == "ipod")
    $scope.browser.ua = ua

    $scope.participation = {}

    if !angular.isDefined(periodical_crowdbar_test)
      periodical_crowdbar_test = $interval(->
        $scope.participation.has_crowdbar = $scope.participation.crowdbar_test()
        #console.log "test: #{$scope.participation.has_crowdbar}"
        if $scope.security.currentUser
          #console.log "db: #{$scope.security.currentUser.has_crowdbar}"
          input =
            user: $scope.security.currentUser
          input.user.has_crowdbar = $scope.participation.has_crowdbar
          $http.put("/users.json", input).then (r) ->
            $scope.participation.double_chances = if $scope.participation.participates and r.chances and !r.chances[0].ignore_double_chance then true else false
        return
      , 30000)


    $timeout ->
      $scope.participation.has_crowdbar = $scope.participation.crowdbar_test()
      $scope.participation.participates = if $scope.security.currentUser and $scope.security.currentUser.chances.length > 0 then true else false
      $scope.participation.double_chances = if $scope.participation.participates && $scope.security.currentUser.chances[0].crowdbar_verified && !$scope.security.currentUser.chances[0].ignoreDoubleChance then true else false
    ,
    1000

    $scope.participation.crowdbar_test = () ->
      return if window.document.getElementById('crowd_bar_verified') then true else false

    $scope.bge_info = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/was_ist_grundeinkommen.html"
        size: 'md'
      )
      return

    $scope.crowdbar_info = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/crowdbar_modal.html"
        controller: "CrowdbarModalCtrl"
        resolve:
          items: ->
            $scope.home
          browser: ->
            $scope.browser
        size: 'lg'
      )
      return

    $scope.crowdbar_install = (url) ->
      form = document.createElement("form");
      form.method = "GET";
      form.action = url;
      form.target = "_blank"
      document.body.appendChild(form)
      form.submit()
      $location.path("/menschen/#{$scope.security.currentUser.id}").search(
        crowdbar_install: true
      )



    Support.query().then (supports) ->
      result = []
      if supports.length > 2
        while (supports.length > 0)
          result.push(supports.splice(0, 3))
        $scope.supports = result

    $scope.support = {}
    $scope.support.amount = 33
    $scope.support.donate = true
    $scope.support.cmd = '_xclick'
    $scope.support.payment_method = 'bank'
    $scope.support.equals_bi = ''
    $scope.support.support_id = ''


    $scope.support.create = ->
      $scope.support.submitted = true

      support = $scope.support

      internal = (support.amount * 0.1).toFixed(2)

      new Support(
        amount_total: support.amount
        amount_for_income: if support.donate then support.amount - internal else support.amount
        amount_internal: if support.donate then internal else 0
        payment_method: support.payment_method
        recurring: support.cmd == '_xclick-subscriptions'
      ).create()
      .then (response) ->
        if response.errors
          $scope.support.submitted = false
          $scope.support.errors = response.errors
        else
          $scope.support.support_id = response.id
          $scope.support.return_url = "https://www.mein-grundeinkommen.de/start?thanks_for_support=" + response.id
          $scope.support.support_amount = response.amountTotal
          $scope.support.avatar = response.avatar
          $scope.support.nickname = response.nickname

          if support.payment_method == 'bank'
            $scope.support.submitted = false
            $scope.support_bank($scope.support)
          else
            document.getElementById('support_id').value = response.id
            document.getElementById('return_url').value = "https://www.mein-grundeinkommen.de/start?thanks_for_support=" + response.id
            document.paypal_form.submit()


    $scope.support.set_equals_bi = (nv) ->
      r = nv + '€ entsprechen '
      if nv > 32
        r += Math.floor((nv / 33)) + ' Tag'
        if nv > 65
          r += 'en'
      hours = Math.floor((nv % 33) / 1.375)
      if nv == 1
        r += '20 Minuten'
      if hours > 0
        if nv > 32
          r += ' und'
        r += ' ' + hours + ' Stunden'
      r += ' Grundeinkommen'
      $scope.support.equals_bi = r


    $scope.support.set_equals_bi($scope.support.amount)


    $scope.support_bank = (support) ->
      modalInstance = $modal.open(
        templateUrl: "/assets/bank.html"
        controller: "SupportBankCtrl"
        size: 'sm'
        resolve:
          items: ->
            support
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
  "$FB"
  (Security, $FB) ->
    Security.requestCurrentUser()
    $FB.init('1410947652520230')
]





angular.module("grundeinkommen").controller "SupportBankCtrl", ($scope, $modalInstance, items, Support) ->
  $scope.supported = items

  console.log items
  $scope.close = ->
    $modalInstance.dismiss('cancel')

  $scope.save_comment = (id,nickname,comment) ->
    new Support(
      id: id
      comment: comment
      nickname: nickname
    ).update().then ->
      $modalInstance.dismiss('cancel')


  return


angular.module("grundeinkommen").controller "CrowdbarModalCtrl", ($scope, $modalInstance, items, browser, $location, $timeout, $interval) ->

  $scope.daily_comm = Math.round(items.prediction.avgDailyCommissionCrowdbar)
  $scope.crowdbar_users = items.crowdbarUsers
  $scope.browser = browser

  console.log $scope.participation

  if $location.search().reload
    $scope.reload = true
    $scope.crowdbar_not_found = false
    $scope.crowdbar_found = false
    $scope.progress = 0

    progress = $interval(->
      if $scope.progress >= 100
        $scope.crowdbar_not_found = !$scope.has_crowdbar()
        $scope.crowdbar_found = $scope.has_crowdbar()
        $interval.cancel(progress)
      else
        $scope.progress += 5
      return
    , 100)

  $scope.has_crowdbar = () ->
    if window.document.getElementById('crowd_bar_verified') then true else false

  $scope.test_for_crowdbar = () ->
    $location.search(
      crowdbar_install: true
      reload: true
    )

    $timeout ->
      location.reload()
    ,
    500

  $scope.close = ->
    $modalInstance.dismiss('cancel')

  return





