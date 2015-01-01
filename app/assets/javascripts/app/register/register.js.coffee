angular.module("register", [

]).config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider.when "/register",
      templateUrl: "/assets/register.html"
      controller: "RegisterViewController"
]

.controller "RegisterViewController", RegisterViewController = ($auth, $rootScope, $scope, $location, $cookies, Session, $parse, $modal, $routeParams) ->

  if $scope.current.user
    $location.path( "/boarding")

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

    $auth.submitRegistration(credentials)

    $rootScope.$on 'auth:registration-email-error', (e, response, deferred) ->
      for fieldName of response.errors
        serverMessage = $parse("RegisterForm." + fieldName + ".$error.serverMessage")
        #$scope.RegisterForm.$setValidity fieldName, false, $scope.RegisterForm
        serverMessage.assign $scope, response.errors[fieldName][0]

    $rootScope.$on 'auth:registration-email-success', (e, response, deferred) ->
      $auth.submitLogin(credentials)

    $scope.$on 'auth:login-success', (e, response, deferred) ->
      if response.user.id
        $scope.current.setCurrentUser(response.user)
        $location.path( "/boarding" ).search('trigger', 'registered')


  $scope.submitted = false

  return

