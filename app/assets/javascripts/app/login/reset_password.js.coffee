angular.module("reset_password", [

]).config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider.when "/users/password/edit",
      templateUrl: "/assets/reset_password.html"
      controller: "ResetPasswordViewController"
]

.controller "ResetPasswordViewController", ResetPasswordViewController = ($rootScope, $routeParams, $scope, $http, $location, Security, $parse) ->

  if Security.isAuthenticated()
    $location.path( "/menschen/" + Security.currentUser.id )

  $scope.submitted = false
  $scope.serverMessage = false
  $scope.reset_password_token = if $routeParams['reset_password_token'] then $routeParams['reset_password_token'] else ''

  $scope.change_password = ->
    $scope.submitted = true
    $http.put('/users/password.json',
      user:
        password: $scope.login_user.password
        password_confirmation: $scope.login_user.password_confirmation
        reset_password_token: $scope.reset_password_token
    ).success((response) ->
      $location.path( "/login" )
    ).error((response) ->
      $scope.serverMessage = response
      $scope.submitted = false
    )

