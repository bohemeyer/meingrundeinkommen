angular.module("wishpage", ["Wish",'ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/mit-grundeinkommen-wuerde-ich/:wishUrl/:wishId",
      templateUrl: "/assets/community.html"
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
  "$cookies"
  "$location"

  ($scope, Security, this_wish, Wish, $http, breadcrumbs, $cookies, $location) ->

    $scope.render = 'wish_page'

    $scope.wish = this_wish


    # breadcrumbs.breadcrumbs.unshift
    #   label: 'Alle Vorhaben'
    #   path: '/community'

    # breadcrumbs.options =
    #   "Ich würde " + this_wish.text
    # $scope.breadcrumbs = breadcrumbs

    # console.log breadcrumbs

    Wish.users(this_wish.id).then (users) ->
      $scope.users = users
    Wish.stories(this_wish.id).then (stories) ->
      $scope.stories = stories
    Wish.users_also_wish(this_wish.id).then (users_also_wish) ->
      $scope.users_also_wish  = users_also_wish


    $scope.me_too = (wish) ->
      if Security.currentUser
        new Wish(
          forUser: 'user_'
          wish_id: wish.wishId
        ).create()
        .then (response) ->
          count_change = if !wish.meToo then 1 else -1
          if wish.wishId == this_wish.id
            $scope.wish.count += count_change
            $scope.wish.meToo = !wish.meToo
          else
            #$scope.wish.count += count_change
            #$scope.wish.meToo = !wish.meToo
      else
        $cookies.initial_wishes = wish.text
        $location.path( "/register")

]