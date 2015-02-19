angular.module("drawfrontend", ['ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/auslosung",
      templateUrl: "/assets/auslosung.html"
      controller: "DrawingFrontendController"
]

.controller "DrawingFrontendController", [
  "$scope"
  "$http"
  "$timeout"
  "Security"
  "$modal"

  ($scope, $http, $timeout, Security, $modal) ->

    $scope.verlosung_erklaert = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/verlosung_erklaert.html"
        size: 'md'
      )
      return

    if Security.currentUser
      $scope.own_codes = Security.currentUser.chances

    myLoop = ->

      # When the timeout is defined, it returns a
      # promise object.
      timer = $timeout(->
        console.log "Timeout executed", Date.now()
        return
      , 1000)
      timer.then (->
        console.log "Timer resolved!"

        $http.get("/currentdrawing.json").success((response) ->
          $scope.drawings = response

          # current_drawing_key = 0
          # angular.forEach $scope.drawings, (d) ->
          #  if d.done
          #    current_drawing_key = current_drawing_key + 1
          # #$scope.current_drawing = $scope.drawings[current_drawing_key]
          # $scope.current_drawing_key = current_drawing_key

          myLoop()
          return
        )

        return

      # something went wrong :(
      ), ->
        console.log "Timer rejected!"
        return

      return
    timer = undefined
    myLoop()


]