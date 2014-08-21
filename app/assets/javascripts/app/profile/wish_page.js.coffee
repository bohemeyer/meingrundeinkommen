angular.module("wishpage", ["Wish",'ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/mit-grundeinkommen-wuerde-ich/:wishUrl/:wishId",
      templateUrl: "/assets/wish_page.html"
      controller: "WishPageViewController"
      label: "Vorhaben"
      resolve:
        this_wish: [
          "Wish"
          "$route"
          (Wish, $route) ->
            Wish.get($route.current.params.wishId).then (wish) ->
              wish
        ]

]

.controller "WishPageViewController", [
  "$scope"
  "Security"
  "this_wish"
  "Wish"
  "$http"
  "breadcrumbs"

  ($scope, Security, this_wish, Wish, $http, breadcrumbs) ->
    $scope.wish = this_wish
    console.log this_wish
    # breadcrumbs.options =
    #   user.name + "s Profil"
    # $scope.breadcrumbs = breadcrumbs

    Wish.users(this_wish.id).then (users) ->
      $scope.users = users
      console.log users
    Wish.stories(this_wish.id).then (stories) ->
      $scope.stories = stories
      console.log stories
    Wish.users_also_wish(this_wish.id).then (users_also_wish) ->
      $scope.users_also_wish  = users_also_wish
      console.log users_also_wish

]