angular.module("boarding", ['Crowdbar', 'Wish','State','Chance','Crowdcard','Avatar','ui.odometer'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/boarding",
      templateUrl: "/assets/boarding/layout.html"
      controller: "BoardingController"
      reloadOnSearch: false
      resolve:
        home: [
          "Home"
          (Home) ->
            Home.query().then (home) ->
              home
        ]
        has_crowdbar: [
          "Crowdbar"
          (Crowdbar) ->
            Crowdbar.verify().then (has_crowdbar) ->
              has_crowdbar
        ]

]

.controller "BoardingController", [
  "$scope"
  "has_crowdbar"
  "Crowdbar"
  "$location"
  "home"
  "$routeParams"
  "$modal"
  "$http"
  "$timeout"
  ($scope, has_crowdbar, Crowdbar, $location, home, $routeParams, $modal, $http, $timeout) ->

    $scope.user = $scope.current.user if $scope.current.user
    $scope.steps = {}
    $scope.own_profile = true

    $scope.home = home

    $scope.trigger = if $location.search().trigger then $location.search().trigger else 'login'


    $scope.all_steps = [

      #after login
      'welcome_back'
      'confirm'

      'avatar'

      #if not participates
      #'gewinnspiel_question'
      'wishes'
      #'gewinnspiel'
      'verify_crowdcard'

      'verify_gewinnspiel'

      'gewinnspiel_thanks'

      #if everything completed only
      #'states'

      'crowdbar'
      'crowdbar_thanks'

      #'crowdapp'

      'crowdcard'
      'crowdcard_thanks'

      'confirm'

      'crowdfund'
      # 'donate'
      # 'donate_thanks'

      'done'



    ]


    necessary = (stepname, test = false) ->
      switch stepname
        when 'welcome_back'
          if $scope.trigger == 'login' && !$scope.all_steps[$scope.what_is_next_step()] == 'verify_gewinnspiel'
            modalInstance = $modal.open(
              templateUrl: "/assets/boarding/welcome_back.html"
              controller: [
                "$scope"
                "user"
                "next_step"
                "crowdbar_users"
                ($scope, user, next_step, crowdbar_users) ->
                  $scope.user = user
                  $scope.next_step = next_step
                  $scope.crowdbar_users = crowdbar_users
                  $scope.close = ->
                    $modalInstance.dismiss('cancel')
              ]
              size: 'lg'
              resolve:
                user: ->
                  $scope.current.user
                next_step: ->
                  $scope.all_steps[$scope.what_is_next_step()]
                crowdbar_users: ->
                  $scope.home.crowdbarUsers
            )
            $scope.next_step()

          else
            return false

        when 'confirm'
          $scope.trigger = 'participates' if $location.search().trigger && $location.search().trigger == 'participates'
          if ($scope.trigger == 'login' || $location.search().trigger == 'participates') && !$scope.current.user.confirmed_at then true else false


        when 'avatar'
          if ($scope.trigger == 'login' || $scope.trigger == 'registered') && $scope.current.is_default_avatar() then true else false


        # when 'gewinnspiel_question'
        #   if $scope.trigger != 'crowdbar_installed' && $scope.trigger != 'crowdapp_installed' && !$scope.current.participates() && ($scope.current.getFlag('dontWantToParticipate') < 3 || $scope.trigger == 'wants_to_participate')
        #     true
        #   else
        #     false

        when 'wishes'
          if $scope.trigger != 'crowdbar_installed' && $scope.trigger != 'crowdapp_installed' && !$scope.current.participates() && $scope.current.user.wishes.length == 0 && ($scope.current.getFlag('dontWantToParticipate') < 3 || $scope.trigger == 'wants_to_participate')
            if !test
              $scope.steps.hide_skip_button = true
              $scope.steps.show_next_button = true
            true
          else
            false

        # when 'gewinnspiel'
        #   if $scope.trigger != 'crowdbar_installed' && $scope.trigger != 'crowdapp_installed' && !$scope.current.participates() && ($scope.current.getFlag('dontWantToParticipate') < 3 || $scope.trigger == 'wants_to_participate')
        #     if !test
        #       $scope.steps.show_next_button = true
        #     true
        #   else
        #     false

        when 'verify_gewinnspiel'
          if $scope.current.participates() && !$scope.current.participation_verified() && !$scope.current.has_ordered_crowdcard()
            if !test
              modalInstance = $modal.open(
                templateUrl: "/assets/boarding/verify_gewinnspiel.html"
                controller: [
                  "$scope"
                  "current"
                  ($scope, current) ->
                    $scope.current = current
                    $scope.close = ->
                      $modalInstance.dismiss('cancel')
                ]
                size: 'lg'
                resolve:
                  current: ->
                    $scope.current
              )

              $scope.next_step()
            true
          else
            false

        when 'gewinnspiel_thanks'
          if $scope.current.participation_verified() and $scope.current.user.confirmed_at and
          (  $location.search().trigger == 'crowdcard_verified' or
          $location.search().trigger    == 'participates' or
          $scope.trigger                == 'confirmed' or
          ($location.search().trigger == 'crowdbar_installed' and $location.search().trigger2 == 'not_verified') or
          ($location.search().trigger == 'crowdapp_installed' and $location.search().trigger2 == 'not_verified')
          )
            $location.search('trigger2', null) if !test
            true
          else
            false

        when 'states'
          if $scope.trigger != 'crowdbar_installed' && $scope.trigger != 'crowdapp_installed' && $scope.current.user.states.length == 0 && !$scope.current.is_default_avatar() && $scope.current.participation_verified() && $scope.current.user.confirmed_at then true else false


        when 'crowdbar'
          if (!has_crowdbar && Crowdbar.runs_in_this_browser()) || (!$scope.current.has_crowdapp() && Crowdbar.runs_in_this_browser_as_bookmark())
            if $location.search().trigger
              if $location.search().trigger == 'crowdbar_installed'
                Crowdbar.open_crowdbar_after_install_modal(true)
                $scope.current.setFlag('crowdbarNotFoundAfterInstall', true)
            return true
          else
            return false

        when 'crowdbar_thanks'
          if $scope.trigger == 'crowdbar_installed' && has_crowdbar && !$location.search().trigger2
            $scope.next_step_is = $scope.all_steps[$scope.what_is_next_step()]
            true
          else
            false

        when 'crowdcard'
          $scope.show_form = $scope.current.getFlag('ClickedCrowdcardMitmachen')
          $scope.steps.show_next_button = true
          if $scope.current.user.crowdcards.length == 0 && !$scope.current.user.flags.crowdcardNumber && !$scope.current.user.flags.NotifiyMeWhenCrowdcardReady && !$scope.current.user.flags.NumberOfCrowdcardDownloads && !$scope.current.user.flags.NumberOfPassbookDownloads then true else false

        when 'verify_crowdcard'
          $scope.steps.show_next_button = true

          if $scope.current.getFlag('crowdcardNumber')
            $scope.crowdcardNumber = $scope.current.getFlag('crowdcardNumber')

          $scope.crowdbarVerified = $scope.crowdcardNumber

          $scope.steps.done = true if $scope.crowdbarVerified

          if ($scope.current.has_received_crowdcard_letter() || $scope.current.user.flags.gotCrowdcardAsGift) && $scope.current.participates() && !$scope.current.participation_verified() && !$scope.current.has_crowdcard()
            true
          else
            false

        when 'donate'
          true
        when 'crowdfund'
          true
        when 'done'
          $scope.current_step = -1
          $location.path("/menschen/" + $scope.current.user.id)
          true
        else false



    $scope.what_is_next_step = () ->
      test = $scope.current_step + 1
      while !necessary($scope.all_steps[test],'test_only')
        test = test + 1
      test

    $scope.next_step = (skip = false) ->

      last_step = $scope.all_steps[$scope.current_step]

      #set flags for current step first
      switch $scope.all_steps[$scope.current_step]
        when 'gewinnspiel_question'
          if skip
            $scope.current.incFlag 'dontWantToParticipate'
            $scope.current_step = $scope.current_step + 3
        when 'gewinnspiel'
          if skip
            $scope.current.incFlag 'dontWantToParticipate'
            $scope.current_step = $scope.current_step + 2
          else
            $location.search('trigger','participates')

        when 'crowdbar'
          if skip
            $scope.current.incFlag 'dontWantCrowdbar'
          else
            if $location.search().trigger2 && $location.search().trigger2 == 'not_verified'
              $scope.go_to('verify_gewinnspiel')

        when 'crowdcard'
          $scope.current.incFlag 'dontWantCrowdcard' if skip
        when 'verify_crowdcard'
          if !skip
            $location.search('trigger','crowdcard_verified')
        when 'donate'
          $scope.current.incFlag 'dontWantToDonate' if skip
        when 'crowdfund'
          $scope.current.incFlag 'dontWantToCrowdfund' if skip
        when 'confirm'
          if skip && $scope.trigger == 'participates'
            alert 'Achtung: Solange deine E-Mail-Adresse nicht bestätigt ist, nimmmst du nicht an der Verlosung teil.'

      $scope.current_step++
      $scope.steps.hide_skip_button = false
      $scope.steps.show_next_button = false
      $scope.steps.done = false
      $scope.finishable = false
      while !necessary($scope.all_steps[$scope.current_step]) || $scope.all_steps[$scope.current_step] == last_step
        $scope.steps.hide_skip_button = false
        $scope.steps.show_next_button = false
        $scope.steps.done = false
        $scope.current_step = $scope.current_step + 1
        $scope.finishable = if $scope.all_steps[$scope.current_step].indexOf("_thanks") > -1 then true else false
      true


    $scope.done = ->
      necessary('done')

    $scope.go_to = (step_name) ->
      $scope.steps.hide_skip_button = false
      $scope.steps.show_next_button = false
      $scope.steps.done = false
      necessary(step_name)
      $scope.current_step = $scope.all_steps.indexOf(step_name)

    $scope.resend_link = ->
      $scope.resending_mail = true
      $http.post('/users/confirmation.json',
        user:
          email: $scope.current.user.email
      ).success((response) ->
        $scope.resending_mail = false
        alert "Es wurde eine neue E-Mail an #{$scope.current.user.email} versendet."
      )

    $scope.$on 'go_to_next_step', ->
      $scope.next_step()

    $scope.current.setFlag('hasCrowdbar', has_crowdbar)
    if has_crowdbar
      $scope.current.setFlag('hasHadCrowdbar', true)

    if $routeParams['go_to']
      $scope.go_to($routeParams['go_to'])
      $location.search('go_to', null)
    else
      $scope.current_step = -1
      $scope.next_step()


]
