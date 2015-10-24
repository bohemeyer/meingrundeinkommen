angular.module("draw", ["Drawing",'ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/draw",
      templateUrl: "/assets/drawing.html"
      controller: "DrawingController"
]

.controller "DrawingController", [
  "$scope"
  "Drawing"
  "$http"

  ($scope, Drawing, $http) ->

    $scope.drawings = [
      digets: [
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ]
    ,
      digets: [
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ,
          value: ''
        ]
    ]


    $scope.loadDrawings = ->
      $http.get("/currentdrawing.json").success((response) ->
        $scope.drawings = response
      )

    console.log $scope.drawings
    $scope.loadDrawings()
    console.log $scope.drawings

    $scope.submitDrawing = ->
      console.log $scope.drawings
      new Drawing(
        d: $scope.drawings
      ).create()
      # .then (response) ->
      #   $scope.drawings = response.d
      #   console.log response.d
]