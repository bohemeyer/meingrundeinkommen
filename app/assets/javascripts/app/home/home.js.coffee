angular.module("home", ["Wish"])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/start",
      templateUrl: "/assets/home.html"
      controller: "HomeViewController"
      label: "Startseite"
    .when "/community",
      templateUrl: "/assets/community.html"
      controller: "HomeViewController"
      label: "Was wäre wenn?"
]

.controller "HomeViewController", ["$scope", "$rootScope", "Wish", ($scope, $rootScope, Wish) ->

  $scope.pagination = []

  Wish.query().then (wishes) ->
    $scope.wishes = wishes

  Wish.latest().then (wishes) ->
    $scope.latest_wishes = wishes

  $scope.$watch (->
    $scope.pagination.current_page
  ), (nv) ->
    Wish.query
      page: nv
    .then (wishes) ->
      $scope.wishes = wishes
    return

  $scope.video_content = 'video_preview.html'

  $scope.showvideo = () ->
    $scope.video_content = 'video.html'

  $scope.me_too = (wish) ->
    new Wish(
      forUser: 'user_'
      wish_id: wish.wishId
    ).create()
    .then (response) ->
      count_change = if !wish.meToo then 1 else -1
      $scope.wishes[$scope.wishes.indexOf(wish)].othersCount += count_change
      $scope.wishes[$scope.wishes.indexOf(wish)].meToo = !wish.meToo


  ]