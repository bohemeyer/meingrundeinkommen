angular.module("login", [
  "autofill-directive"
]).config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider.when "/login",
      templateUrl: "/assets/login.html"
      controller: "LoginViewController"
]

.controller "LoginViewController", LoginViewController = ($auth, $rootScope, $routeParams, $scope, $location, $parse) ->

  if $scope.current.user
    $location.path( "/boarding" )

  $scope.just_confirmed = if $routeParams['confirmed'] then $routeParams['confirmed'] else ''
  $scope.confirmation_error = if $routeParams['confirmation_error'] then true else false
  $scope.show_resend_link = false
  $scope.resend_status = false
  $scope.forgot_pw = false

  $scope.login_user =
    email: if $routeParams['email'] then $routeParams['email'] else ''
    password: ''
    remember_me: true

  $scope.forgot_pw_open = ->
    $scope.forgot_pw = true

  $scope.cancel_forgot_pw = ->
    $scope.forgot_pw = false

  $scope.reset_password = ->
    # $scope.submitted_reset = true
    # $http.post('/users/password.json',
    #   user:
    #     email: $scope.login_user.email
    # ).success((response) ->
    #   serverMessage = $parse("LoginForm.$error.serverMessage")
    #   serverMessage.assign $scope, 'Du erhältst in wenigen Minuten eine E-Mail mit der Anleitung, wie Du Dein Passwort zurücksetzen kannst.'
    #   $scope.submitted_reset = false
    # ).error((response) ->
    #   serverMessage = $parse("LoginForm.$error.serverMessage")
    #   serverMessage.assign $scope, "Du bist noch gar nicht registriert. Bitte registrier dich neu indem du im Menü ganz oben auf 'Mitmachen' klickst."
    #   $scope.submitted_reset = false
    # )

  $scope.resend_link = ->
    # $scope.resend_status = 'Bitte warten...'
    # $http.post('/users/confirmation.json',
    #   user:
    #     email: $scope.login_user.email
    # ).success((response) ->
    #   $scope.registered = "assets/checkmail.html"
    #   $scope.register_user.email = $scope.login_user.email
    # )

  $scope.login = ->
    if $scope.forgot_pw
      return $scope.reset_password()


    $scope.submitted = true
    $scope.show_resend_link = false

    # Try to login
    $auth.submitLogin($scope.login_user)

    $rootScope.$on 'auth:login-success', (e, response, deferred) ->
      if response.user.id
        $scope.current.setCurrentUser(response.user)
        $location.path( "/boarding" )

    $rootScope.$on 'auth:login-error', (event, xhr, deferred) ->
      console.log xhr
      $scope.show_resend_link = false
      if xhr.errors
        serverMessage = $parse("LoginForm.$error.serverMessage")
        if xhr.errors[0].indexOf('[[resend_link]]') > -1
          $scope.show_resend_link = true
        serverMessage.assign $scope, xhr.errors[0].replace('[[resend_link]]','')
        $scope.submitted = false

    return
