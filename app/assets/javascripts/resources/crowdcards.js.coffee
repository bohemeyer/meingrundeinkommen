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

    $scope.saveCrowdcard = (crowdcard) ->
      $scope.submitted = true
      $scope.crowdcard_errors = []

      crowdcard.country = 'de'

      new Crowdcard(crowdcard).create()
      .then (response) ->
        $scope.submitted = false
        if response.errors
          $scope.crowdcard_errors = response.errors
        else
          $scope.crowdcard_ordered = true
          $scope.steps.done = true if $scope.steps




]