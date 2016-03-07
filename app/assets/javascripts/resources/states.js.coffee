angular.module "State", ["rails"]
.factory "State", [
  "railsResourceFactory"
  (rails) ->

    State = rails(
      url: "/api/{{forUser}}state{{forStatesUser}}/{{id}}"
      name: "state"
    )


    State.initial_states = [
      'Renter*in',
      'Student*in',
      'Kind',
      'Frau',
      'Mann',
      'Elternteil',
      'Unternehmer*in',
      'Arbeitnehmer*in',
      'Schüler*in',
      'Sozialleistungsbeziehende*r',
      'Arbeitslose*r',
      'Künstler*in',
      'Urheber*in',
      'Sportler*in',
      'Freiberufler*in',
      'Alleinerziehende*r',
      'Ehrenamtliche*r',
      'Manager*in',
      'Migrant*in',
      'Mensch mit Behinderungen',
      'Aussteiger*in',
      'Akademiker*in',
      'Wissenschaftler*in, Lehrende*r',
      'Beamte*r',
      'in sozialem Beruf tätig',
      'in der Sozialverwaltung tätig'
    ]

    State.forUser = (user_id) ->
      State.query {},
        forUser: 'users/' + user_id + '/'
        forStatesUser: 's'

    State.suggestions = (query) ->
      State.query
        q: query
      ,
        forStatesUser: 's'

    return State
]
.controller "StatesController", [
  "$scope"
  "State"
  ($scope, State) ->

    $scope.user_states = []
    $scope.state_form = {}

    if $scope.own_profile && !$scope.user
      $scope.user = $scope.current.user

    #initialize default states
    $scope.states = []
    angular.forEach State.initial_states, (statename) ->
      $scope.states.push
        text: statename
        visibility: true
        selected: false
        user_state_id: false
        is_default_state: true


    State.forUser($scope.user.id).then (user_states) ->
      $scope.current.user.states = user_states if $scope.own_profile

      angular.forEach user_states, (user_state) ->
        is_default_state = false

        angular.forEach $scope.states, (state,key) ->
          if state.text == user_state.text
            is_default_state = true
            $scope.states[key].selected = true
            $scope.states[key].visibility = user_state.visibility
            $scope.states[key].user_state_id = user_state.userStateId
        if !is_default_state
          $scope.states.push
            text: user_state.text
            visibility: user_state.visibility
            user_state_id: user_state.userStateId
            selected: true
            is_default_state: false



    $scope.changeVisibility = (state) ->
      if state.user_state_id
        new State(
          id: state.user_state_id
          visibility: state.visibility
          forStatesUser: '_users'
        ).update()

    $scope.addCustomState = () ->
      new_state =
        text: $scope.state_form.new_custom_state
        visibility: true
        selected: true
        is_default_state: false

      if new_state.text.trim() != ""
        new_state.forStatesUser = 's'
        new State(new_state).create().then (response) ->
          new_state.user_state_id = response.userStateId
          $scope.states.push new_state
          $scope.current.user.states.push new_state if $scope.own_profile
          $scope.state_form.new_custom_state = ""

    $scope.stateClicked = (state) ->

      if state.selected #ADD
        state.forStatesUser = 's'
        new State(state).create().then (response) ->
          $scope.states[$scope.states.indexOf(state)].user_state_id = response.userStateId
          $scope.current.user.states.push(response) if $scope.own_profile
      else
        if state.user_state_id #DELETE
          #"/api/{{forUser}}state{{forStatesUser}}/{{id}}
          new State(
            id: state.user_state_id
            forStatesUser: '_users'
          ).delete().then ->
            if $scope.own_profile
              angular.forEach $scope.current.user.states, (ustate) ->
                if ustate.userStateId == state.user_state_id
                  $scope.current.user.states.splice($scope.current.user.states.indexOf(ustate),1)
            $scope.states[$scope.states.indexOf(state)].selected = false
            $scope.states[$scope.states.indexOf(state)].user_state_id = false

      console.log $scope.current.user.states

    $scope.getStateSuggestions = (q) ->
      State.suggestions(q).then (states) ->
        return states

    $scope.$watch "states|filter:{selected:true}", ((nv) ->
      $scope.user_states = nv.map((state) ->
        state
      )
      $scope.steps[$scope.current_step].done = ($scope.user_states.length > 0) if $scope.steps
      return
    ), true

]
