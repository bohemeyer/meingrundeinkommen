angular.module "Chance", ["rails","Support","Tandem"]

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
  "Tandem"
  "User"
  "$q"
  "$cookies"
  ($scope, $modal, Chance, Tandem, User, $q, $cookies) ->

    $scope.chances = []
    $scope.chances.affiliate_error = false

    synchronize_form_with_squirrel_state = ->
      $scope.current.user.isSquirrel = $scope.current.isSquirrel()

    synchronize_form_with_squirrel_state()


    $scope.openSquirrelModal = ->
      Squirrelmodal = $modal.open(
        templateUrl: "squirrelmodal.html"
        size: 'lg'
        controller: "SupportController"
        resolve:
          isModal: ->
            true
      )

      Squirrelmodal.result.then ->
        synchronize_form_with_squirrel_state()
      , ->
        synchronize_form_with_squirrel_state()

    $scope.sanitizeChances = ->
      adult = false
      participates = false
      angular.forEach $scope.chances_form.chances, (chance) ->
        if !chance.isChild
          adult = true
        if chance.id
          participates = true
          chance.isChild = if chance.is_child then chance.is_child else chance.isChild
          chance.is_child = if chance.isChild then chance.isChild else chance.is_child
          if !chance.dob_year
            dates = chance.dob.split "-"
            chance.dob_year = parseInt dates[0]
            chance.dob_month = parseInt dates[1]
            chance.dob_day = parseInt dates[2]

      if !adult
        $scope.chances_form.chances.unshift(
          isChild: false
          dob_year: 1980
          dob_month: 1
          dob_day: 1
        )
      $scope.steps.done = $scope.current.participates() if $scope.steps
      $scope.steps.hide_skip_button = $scope.current.participates() if $scope.steps


    $scope.addChild = ->
      $scope.chances_form.chances.push(
        isChild: true
        dob_year: 2010
        dob_month: 1
        dob_day: 1
      )

    $scope.saveChances = () ->

      # if $scope.chances.tandems.length == 0
      #   $scope.chances.notandemerror = true
      #   return false
      # else
      #   $scope.chances.notandemerror = false

      $scope.submitted = true
      $scope.confirmed_publication_error = false
      $scope.chances.affiliate_error = false
      errors = false
      queries = []

      handle = (response, chance, key, is_update) ->
        if response.errors
          errors = true
          $scope.chances_form.chances[key].errors = response.errors
          $scope.confirmed_publication_error = if response.errors.confirmedPublication then true else false
          $scope.chances.affiliate_error = if response.errors.affiliate then true else false

        if !response.errors #|| is_update
          $scope.chances_form.chances[key] = response.chance
          $scope.chances_form.chances[key].id = response.chance.id
          $scope.chances_form.chances[key].first_name = response.chance.firstName
          $scope.chances_form.chances[key].last_name = response.chance.lastName
          $scope.chances_form.chances[key].is_child = response.chance.isChild
          dates = response.chance.dob.split "-"
          $scope.chances_form.chances[key].dob_year = parseInt dates[0]
          $scope.chances_form.chances[key].dob_month = parseInt dates[1]
          $scope.chances_form.chances[key].dob_day = parseInt dates[2]

          if $scope.gotCrowdcardAsGift
            $scope.current.setFlag('gotCrowdcardAsGift',true)


      angular.forEach $scope.chances_form.chances, (c) ->
        key = $scope.chances_form.chances.indexOf(c)

        delete $scope.chances_form.chances[key].errors
        chance = c
        chance.dob = c.dob_year + '-' + c.dob_month + '-' + c.dob_day
        chance.is_child = c.isChild
        chance.confirmed_publication = $scope.confirmed_publication
        chance.mediacoverage = $scope.mediacoverage
        chance.remember_data = $scope.remember_data
        chance.city = $scope.city
        chance.affiliate = $scope.affiliate

        if chance.id
          queries.push new Chance(chance).update().then (response) ->
            handle(response,chance,key,true)
        else
          queries.push new Chance(chance).create().then (response) ->
            handle(response,chance,key)

      #update current user
      $scope.current.user.chances = $scope.chances_form.chances
      $q.all(queries).finally ->
        $scope.submitted = false
        if !errors
          #Handle tandems
          tqueries = []
          angular.forEach $scope.current.user.tandems, (t) ->
            if !t.id && (t.invitee_id || t.inviter_id || t.email)

              tandem =
                invitee_id: if t.invitee_id then t.invitee_id else null
                inviter_id: if t.inviter_id then t.inviter_id else null
                invitation_type: t.invitation_type
                invitee_name: t.invitee_name
                invitee_email_subject: if t.invitee_email_subject then t.invitee_email_subject else null
                invitee_email_text: if t.invitee_email_text then t.invitee_email_text else null
                invitee_email: t.invitee_email
                grudge: t.grudge
              tqueries.push new Tandem(tandem).create().then (t) ->
                tandem.id = t.id


          $q.all(tqueries).finally ->
            $cookies["mitdir"] = null
            $scope.current.inviter = null if $scope.current.inviter

          $scope.sanitizeChances()
          $scope.$emit('go_to_next_step')




    $scope.deleteChance = (chance) ->
      new Chance(chance).delete().then ->
        $scope.chances_form.chances.splice($scope.chances_form.chances.indexOf(chance), 1)

    $scope.cancelChild = (chance) ->
      if chance.id
        $scope.deleteChance(chance)
      else
        $scope.chances_form.chances.splice($scope.chances_form.chances.indexOf(chance), 1)

    $scope.gewinnspielbedingungen = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/gewinnspielbedingungen.html"
        size: 'lg'
        controller: [
          "$scope"
          ($scope) ->
            $scope.is_modal = true
        ]
      )
      return

    $scope.datenschutz = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/gewinnspielbedingungen_datenschutz_modal.html"
        size: 'lg'
      )
      return




    if $scope.current.user.chances && $scope.current.user.chances.length > 0
      $scope.chances_form =
        chances: $scope.current.user.chances
      $scope.confirmed_publication = $scope.current.user.chances[0].confirmed_publication
      $scope.mediacoverage = $scope.current.user.chances[0].mediacoverage
      $scope.remember_data = $scope.current.user.chances[0].remember_data
      $scope.city = $scope.current.user.chances[0].city
      $scope.sanitizeChances()

    else
      $scope.chances_form =
        chances: []

      $scope.sanitizeChances()

]