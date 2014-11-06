angular.module("admin", ["Support"])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/admin",
      templateUrl: "/assets/admin.html"
      controller: "AdminController"
]

.controller "AdminController", [
  "$scope"
  "Support"

  ($scope, Support) ->

    Support.query(
      admin: true
    ).then (supports) ->
      $scope.supports = supports

    $scope.changeStatus = (support) ->
      new Support(
        id: support.id
        payment_completed: !support.paymentCompleted
        comment: support.comment
        admin: true
      ).update()
      .then (response) ->
        $scope.supports[$scope.supports.indexOf(support)] = response
]