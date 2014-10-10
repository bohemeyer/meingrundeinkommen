window.App = angular.module('grundeinkommen', ['ui.bootstrap','rails','ngRoute','ng-breadcrumbs','Devise','sticky','ngCookies','login','reset_password','home','register','profile','wishpage','content','smoothScroll','angulartics','angulartics.google.analytics','faq','draw','drawfrontend', 'Support'])

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
  "Support"

  ($scope, Security, breadcrumbs, Home, $modal, Support) ->
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
          $scope.support.support_id = response.support.id
          $scope.support.support_amount = response.support.amountTotal
          if support.payment_method == 'bank'
            $scope.support.submitted = false
            $scope.support_bank($scope.support)
          else
            document.getElementById('support_id').value = response.support.id
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


    $scope.crowdbar_verify = () ->
      if window.document.getElementById('main')
        alert 'verified'

    $scope.support_bank = (support) ->
      modalInstance = $modal.open(
        templateUrl: "/assets/bank.html"
        controller: "SupportBankCtrl"
        size: 'md'
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
  (Security) ->
    Security.requestCurrentUser()
]





angular.module("grundeinkommen").controller "SupportBankCtrl", ($scope, $modalInstance, items) ->
  $scope.supported = items

  $scope.close = ->
    $modalInstance.dismiss('cancel')

  return


