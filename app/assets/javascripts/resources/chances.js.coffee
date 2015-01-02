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


    if $scope.current.user.chances
      $scope.chances_form =
        chances: $scope.current.user.chances

    $scope.sanitizeChances = ->
      adult = false
      participates = false
      angular.forEach $scope.chances_form.chances, (chance) ->
        if !chance.isChild
          adult = true
        if chance.id
          participates = true
      if !adult
        $scope.chances_form.chances.unshift(
          isChild: false
          dob_year: 1975
          dob_month: 1
          dob_day: 1
        )
      $scope.steps.done = $scope.current.participates() if $scope.steps
      $scope.steps.hide_skip_button = $scope.current.participates() if $scope.steps

    $scope.sanitizeChances()

    $scope.addChild = ->
      $scope.chances_form.chances.push(
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
          $scope.chances_form.chances[$scope.chances_form.chances.indexOf(chance)] = response.chance
          $scope.sanitizeChances()


    $scope.removeChance = (chance) ->
      if chance.id
        new Chance(
          id: chance.id
        ).delete()
      $scope.chances_form.chances.splice($scope.chances_form.chances.indexOf(chance), 1)
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