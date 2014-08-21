App.controller "HomeController", ["$scope", "Home", ($scope, Home) ->

  Home.query().then (home) ->
    $scope.home = home
    console.log home

  $scope.video_content = 'video_preview.html'

  $scope.showvideo = () ->
  	$scope.video_content = 'video.html'

]