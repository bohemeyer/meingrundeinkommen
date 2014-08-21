angular.module("login", [

]).config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider.when "/login",
      templateUrl: "/assets/login.html"
      controller: "LoginViewController"
]

.controller "LoginViewController", LoginViewController = ($rootScope, $routeParams, $scope, $http, $location, Security, $parse) ->

  if Security.isAuthenticated()
    $location.path( "/menschen/" + Security.currentUser.id )

  $scope.just_confirmed = if $routeParams['confirmed'] then $routeParams['confirmed'] else ''
  $scope.show_resend_link = false
  $scope.resend_status = false
  $scope.forgot_pw = false

  $scope.login_user =
    email: if $routeParams['email'] then $routeParams['email'] else ''
    password: 'lalalaldsgew'
    remember_me: false

  $scope.forgot_pw_open = ->
    $scope.forgot_pw = true

  $scope.cancel_forgot_pw = ->
    $scope.forgot_pw = false

  $scope.reset_password = ->
    $scope.submitted_reset = true
    $http.post('/users/password.json',
      user:
        email: $scope.login_user.email
    ).success((response) ->
      serverMessage = $parse("LoginForm.$error.serverMessage")
      serverMessage.assign $scope, 'Du erhältst in wenigen Minuten eine E-Mail mit der Anleitung, wie Du Dein Passwort zurücksetzen kannst.'
      $scope.submitted_reset = false
    )

  $scope.resend_link = ->
    $scope.resend_status = 'Bitte warten...'
    $http.post('/users/confirmation.json',
      user:
        email: $scope.login_user.email
    ).success((response) ->
      $scope.registered = "assets/checkmail.html"
      $scope.register_user.email = $scope.login_user.email
    )

  $scope.login = ->
    $scope.submitted = true
    $scope.show_resend_link = false

    # Try to login
    Security.login($scope.login_user).then ((response) ->
      $location.path( "/menschen/" + response.id ) if response.id && !response.error
      return
    )

    $scope.$on('devise:unauthorized', (event, xhr, deferred) ->
      $scope.show_resend_link = false
      if xhr.data.error
        serverMessage = $parse("LoginForm.$error.serverMessage")
        if xhr.data.error.indexOf('[[resend_link]]') > -1
          $scope.show_resend_link = true
        serverMessage.assign $scope, xhr.data.error.replace('[[resend_link]]','')
        $scope.submitted = false
    )

    return
