angular.module "Wish", ["rails"]
.factory "Wish", [
  "railsResourceFactory"
  (rails) ->

    Wish = rails(
      url: "/api/{{forUser}}wishes/{{id}}"
      name: "wish"
    )

    Wish.suggestions = (query) ->
      Wish.query
        q: query

    Wish.latest = (query) ->
      Wish.query {},
        forUser: 'user_'

    Wish.forUser = (user_id) ->
      Wish.query {},
        forUser: 'users/' + user_id + '/'

    Wish.users = (wish_id) ->
      Wish.query {},
        id: wish_id + '/users'

    Wish.stories = (wish_id) ->
      Wish.query {},
        id: wish_id + '/stories'

    Wish.users_also_wish = (wish_id) ->
      Wish.query {},
        id: wish_id + '/wishes'


    return Wish
]
.controller "WishesController", [
  "$scope"
  "Wish"
  "User"
  "$cookies"
  ($scope, Wish, UserModel, $cookies) ->

    $scope.wish_form = {}

    if $scope.own_profile && !$scope.user
      $scope.user = $scope.current.user

    Wish.forUser($scope.user.id).then (wishes) ->
      $scope.user_wishes = wishes

      $scope.current.user.wishes = wishes if $scope.own_profile

      if $scope.own_profile && wishes && wishes.length == 0 && $cookies.initial_wishes && $cookies.initial_wishes != ''  && $cookies.initial_wishes != ';'
        new Wish(
          text: $cookies.initial_wishes.replace(';','').replace(';','')
        ).create()
        .then (response) ->
          $scope.user_wishes.unshift response
          $cookies.initial_wishes = ''


    $scope.load_suggestions = ->
      UserModel.suggestions($scope.current.user.id).then (suggestions) ->
        $scope.suggestions = suggestions

    $scope.load_suggestions() if $scope.own_profile

    $scope.getSuggestions = (q) ->
      Wish.suggestions(q).then (wishes) ->
        r = []
        angular.forEach wishes, (item) ->
          r.push
            text: item.text
            count: item.count
            create: item.create
        return r

    $scope.selectedSuggestion = (item) ->
      $scope.wish_form.new_wish = item.text

    $scope.use_original_instead_of_suggested = (wish) ->
      $scope.suggestions[$scope.suggestions.indexOf(wish)] =
        text: wish.suggestion.isSuggestionFor
        suggestion:
          isSuggestionFor: wish.suggestion.isSuggestionFor
        user: user

    $scope.me_too = (wish) ->
      if $scope.current.user
        remove_initial_wish = if wish.suggestion then wish.suggestion.isSuggestionFor else false
        if wish.wishId
          resource = new Wish(
            forUser: 'user_'
            wish_id: wish.wishId
            remove_initial_wish: remove_initial_wish
          )
        else
          resource = new Wish(
            text: wish.text
            remove_initial_wish: remove_initial_wish
          )

        resource.create()
        .then (response) ->
          if $scope.own_profile
            $scope.suggestions.splice($scope.suggestions.indexOf(wish), 1)
            $scope.user_wishes.push response
            $scope.load_suggestions()
          else
            if !response.meToo
              $scope.user_wishes[$scope.user_wishes.indexOf(wish)].meToo = false
              $scope.user_wishes[$scope.user_wishes.indexOf(wish)].othersCount -= 1
            else
              $scope.user_wishes[$scope.user_wishes.indexOf(wish)] = response

      else
        $cookies.initial_wishes = wish.text
        $location.path( "/register")


    $scope.addWish = ->

      if $scope.wish_form.new_wish.text
        $scope.wish_form.new_wish = $scope.wish_form.new_wish.text

      for wish in $scope.user_wishes
        if wish.text == $scope.wish_form.new_wish
          alert 'Dieses Vorhaben hast du schon angelegt.'
          return false

      new Wish(
        text: $scope.wish_form.new_wish
        story: $scope.wish_form.story
      ).create()
      .then (response) ->
        $scope.steps.done = true if $scope.steps
        $scope.user_wishes.unshift response
        $scope.current.user.wishes = $scope.user_wishes if $scope.own_profile
        $scope.wish_form.new_wish = ""
        $scope.wish_form.story = ""
        $scope.load_suggestions()

    $scope.editStory = (user_wish) ->
      $scope.edit_story = user_wish
      if !user_wish.edited_story
        $scope.user_wishes[$scope.user_wishes.indexOf(user_wish)].edited_story = user_wish.story

    $scope.cancelStoryEditing = (user_wish) ->
      $scope.edit_story = false
      $scope.user_wishes[$scope.user_wishes.indexOf(user_wish)].edited_story = false

    $scope.updateStory = (user_wish) ->
      $scope.edit_story = false
      $scope.user_wishes[$scope.user_wishes.indexOf(user_wish)].story = user_wish.edited_story
      new Wish(
        id: user_wish.id
        story: user_wish.edited_story
        forUser: 'user_'
      ).update()


    $scope.removeWish = (user_wish) ->
      new Wish(
        id: user_wish.id
        forUser: 'user_'
      ).delete()
      $scope.user_wishes.splice($scope.user_wishes.indexOf(user_wish), 1)
      $scope.current.user.wishes = $scope.user_wishes if $scope.own_profile
      $scope.steps[$scope.current_step].done = false if $scope.steps && $scope.user_wishes.length == 0



]