angular.module "Chance", ["rails"]
.factory "Chance", [
  "railsResourceFactory"
  (rails) ->

    Chance = rails(
      url: "/api/chances/{{id}}"
      name: "state"
    )

    return Chance
]
.controller "ChancesController", [
  "$scope"
  "$modal"
  "Chance"
  ($scope, $modal, Chance) ->


    $scope.sanitizeChances = ->
      adult = false
      participates = false
      angular.forEach $scope.user.chances, (chance) ->
        if !chance.isChild
          adult = true
        if chance.id
          participates = true
      if !adult
        $scope.user.chances.unshift(
          isChild: false
          dob_year: 1975
          dob_month: 1
          dob_day: 1
        )
      if $scope.participation
        $scope.participation.participates = participates

    $scope.sanitizeChances()

    $scope.addChild = ->
      $scope.user.chances.push(
        isChild: true
        dob_year: 2000
        dob_month: 1
        dob_day: 1
      )

    $scope.saveChance = (c) ->
      $scope.submitted = true
      $scope.chance_errors = []
      chance = c
      chance.dob = c.dob_year + '-' + c.dob_month + '-' + c.dob_day
      chance.is_child = c.isChild

      new Chance(chance).create()
      .then (response) ->
        $scope.submitted = false
        if response.errors
          $scope.chance_errors = response.errors
        else
          $scope.user.chances[$scope.user.chances.indexOf(chance)] = response.chance
          $scope.current.user.chances.push response.chance
          $scope.sanitizeChances()
          $scope.participation.participates = true
          $scope.steps.done = true if $scope.steps
          #$scope.participation.double_chances = if ($scope.user.chances[0].crowdbarVerified || $scope.participation.crowdbar_test()) && !$scope.user.chances[0].ignoreDoubleChance then true else false
          #$scope.save_crowdbar_verified_to_db() if $scope.participation.crowdbar_test()


    $scope.removeChance = (chance) ->
      if chance.id
        new Chance(
          id: chance.id
        ).delete()
      $scope.user.chances.splice($scope.user.chances.indexOf(chance), 1)
      $scope.sanitizeChances()

    $scope.gewinnspielbedingungen = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/gewinnspielbedingungen.html"
        size: 'lg'
      )
      return

    $scope.datenschutz = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/gewinnspielbedingungen_datenschutz_modal.html"
        size: 'lg'
      )
      return

]