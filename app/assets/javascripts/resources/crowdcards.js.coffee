angular.module "Crowdcard", ["rails"]
.factory "Crowdcard", [
  "railsResourceFactory"
  (rails) ->

    Crowdcard = rails(
      url: "/api/crowdcards/{{id}}"
      name: "crowdcard"
    )

    return Crowdcard
]
.controller "CrowdcardsController", [
  "$scope"
  "$modal"
  "Crowdcard"
  ($scope, $modal, Crowdcard) ->

    $scope.items = [
      {
        id: 1
        name: "keine"
      }
      {
        id: 2
        name: "1"
      }
      {
        id: 3
        name: "2"
      }
      {
        id: 4
        name: "3"
      }
      {
        id: 5
        name: "4"
      }
      {
        id: 6
        name: "5"
      }
      {
        id: 7
        name: "6"
      }
    ]

    $scope.saveCrowdcard = (crowdcard) ->
      $scope.submitted = true
      $scope.crowdcard_errors = []


      crowdcard.country = 'de'
      if crowdcard.number_of_cards_select
        crowdcard.number_of_cards = crowdcard.number_of_cards_select.id

      new Crowdcard(crowdcard).create()
      .then (response) ->
        $scope.submitted = false
        if response.errors
          $scope.crowdcard_errors = response.errors
        else
          $scope.crowdcard_ordered = true
          $scope.steps.done = true if $scope.steps




]