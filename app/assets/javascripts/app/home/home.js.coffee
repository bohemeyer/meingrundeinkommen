angular.module("home", ["Wish","Support","Winner","rails"])
.factory "Home", ["railsResourceFactory", (f) ->
  f(
    url: "/api/homepages"
    name: "homepage"
  )
]
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

.controller "HomeViewController", ["$scope", "$rootScope", "Wish", "$modal", "$cookies", "$location", "Security", "$http", "$routeParams", "Support", "Winner", ($scope, $rootScope, Wish, $modal, $cookies, $location, Security, $http, $routeParams, Support, Winner) ->

  if $routeParams.thanks_for_support
    Support.get($routeParams.thanks_for_support).then (support) ->
      Support.thanks_for_support(support)

  # Support.query().then (supports) ->
  #   result = []
  #   if supports.length > 2
  #     while (supports.length > 0)
  #       result.push(supports.splice(0, 3))
  #     $scope.supports = result

  Winner.query().then (winners) ->
    $scope.winners = []
    $scope.number_of_winners = winners.length
    row = 0
    i = 0
    angular.forEach winners, (winner) ->
      i++
      $scope.winners[row] = [] if !$scope.winners[row]
      $scope.winners[row].push winner
      if i % 3 == 0
        row++
        i = 0
    console.log $scope.winners



  TDay = new Date("November, 15, 2014")
  CurrentDate = new Date()
  DayCount = (TDay-CurrentDate)/(1000*60*60*24)
  $scope.days_left = Math.round(DayCount)


  $scope.pagination = []

  url = "/news.json"
  $http.get(url).success (data) ->
    $scope.news = []
    i = 0
    angular.forEach data, (p) ->
      i = i + 1
      $scope.news.push p if i < 4

  Wish.query().then (wishes) ->
    $scope.wishes = wishes

  Wish.latest().then (wishes) ->
    $scope.latest_wishes = wishes[0..9]
    $scope.portraits = wishes[15..39]

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
    if Security.currentUser
      new Wish(
        forUser: 'user_'
        wish_id: wish.wishId
      ).create()
      .then (response) ->
        count_change = if !wish.meToo then 1 else -1
        if $scope.wishes[$scope.wishes.indexOf(wish)]
          $scope.wishes[$scope.wishes.indexOf(wish)].othersCount += count_change
          $scope.wishes[$scope.wishes.indexOf(wish)].meToo = !wish.meToo
        if $scope.portraits[$scope.portraits.indexOf(wish)]
          $scope.portraits[$scope.portraits.indexOf(wish)].meToo = !wish.meToo
    else
      $cookies.initial_wishes = wish.text
      $location.path( "/register")


  ]