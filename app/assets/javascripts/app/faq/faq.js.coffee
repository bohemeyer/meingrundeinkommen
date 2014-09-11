angular.module("faq", ["Question",'ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/info/faq",
      templateUrl: "/assets/faq.html"
      controller: "FAQController"
      label: "Häufige Fragen"

]

.controller "FAQController", [
  "$scope"
  "Question"

  ($scope, Question) ->

    Question.query().then (questions) ->
      $scope.questions = questions

    $scope.askQuestion = ->
      new Question(
        text: $scope.question.$
      ).create().then (response) ->
        $scope.questions.push response
]