angular.module("register", [

]).config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider.when "/register",
      templateUrl: "/assets/register.html"
      controller: "RegisterViewController"
      resolve:
        veganz: ->
          false
    $routeProvider.when "/veganz",
      templateUrl: "/assets/register.html"
      controller: "RegisterViewController"
      resolve:
        veganz: ->
          true
]

.controller "RegisterViewController", [
  "$rootScope"
  "$scope"
  "$http"
  "$location"
  "$cookies"
  "Security"
  "$parse"
  "$modal"
  "$routeParams"
  "veganz"
  ($rootScope, $scope, $http, $location, $cookies, Security, $parse, $modal, $routeParams, veganz) ->

    if veganz || $cookies.veganz
      $scope.veganz = true
      $cookies["veganz"] = true
    else
      $scope.veganz = false


    $scope.registered = false
    $scope.submitted = false

    if $routeParams.wishes #&& $routeParams.wishes != null && $routeParams.wishes != ''
      wish = $routeParams.wishes
      initial_wishes = decodeURIComponent($routeParams.wishes)
    else
      if !$cookies.initial_wishes
        initial_wishes = ''
      else
        initial_wishes = $cookies.initial_wishes + ';'


    console.log $scope.current.user
    if $scope.current.user
      console.log 'ok'
      $location.path("/boarding")


    $scope.register_user =
      email: if $routeParams.email then $routeParams.email else ''
      password: ''
      name: if $routeParams.name then $routeParams.name else ''
      datenschutz: null
      newsletter: null
      initial_conditions: if !$cookies.initial_conditions then '' else $cookies.initial_conditions + ';'
      initial_wishes: initial_wishes

    $scope.register = ->
      $scope.submitted = true

      credentials =
        email: $scope.register_user.email
        password: $scope.register_user.password
        password_confirmation: $scope.register_user.password
        name: $scope.register_user.name
        initial_wishes: $scope.register_user.initial_wishes
        initial_conditions: $scope.register_user.initial_conditions
        datenschutz: $scope.register_user.datenschutz
        newsletter: $scope.register_user.newsletter
        veganz: $scope.veganz


      Security.register(credentials).then ((response) ->

        if response.errors
          for fieldName of response.errors
            serverMessage = $parse("RegisterForm." + fieldName + ".$error.serverMessage")
            #$scope.RegisterForm.$setValidity fieldName, false, $scope.RegisterForm
            serverMessage.assign $scope, response.errors[fieldName][0]
        else
          Security.login(credentials).then ((response) ->
            $location.path( "/boarding" ).search('trigger', 'registered') if response.id && !response.error
            return
          )
          #$scope.registered = "assets/checkmail.html"

        $scope.submitted = false

        return
      ), (x) ->
        return
      return

    $scope.open = (template) ->
      modalInstance = $modal.open(
        templateUrl: "/assets/" + template + ".html"
        controller: ModalInstanceCtrl
        size: 'lg'
      )
      return

    ModalInstanceCtrl = ($scope, $modalInstance) ->
    $scope.ok = ->
      $modalInstance.close
      return

    $scope.cancel = ->
      $modalInstance.dismiss "cancel"
      return
]