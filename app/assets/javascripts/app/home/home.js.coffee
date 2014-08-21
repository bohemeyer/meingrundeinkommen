App.controller "HomeController", ["$scope", "Home", "Wish", ($scope, Home, Wish) ->

  Home.query().then (home) ->
    $scope.home = home

    $scope.home.financedIncomes = []

    for fi in [1..home.totallyFinancedIncomes]
      $scope.home.financedIncomes.push "#{fi}. Grundeinkommen mit 12.000€ per Crowdfunding finanziert!"

  CurrentDate = new Date()
  Verlosung = new Date("September, 18, 2014")
  DayCount = (Verlosung - CurrentDate) / (1000 * 60 * 60 * 24)
  $scope.daysLeft = Math.round(DayCount)


  Wish.query().then (wishes) ->
    $scope.wishes = wishes


  $scope.video_content = 'video_preview.html'

  $scope.showvideo = () ->
    $scope.video_content = 'video.html'

]