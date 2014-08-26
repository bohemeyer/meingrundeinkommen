angular.module("profile", ["User","Wish","angularFileUpload",'ng-breadcrumbs','matchMedia'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/menschen/:userId",
      templateUrl: "/assets/profile.html"
      controller: "ProfileViewController"
      label: "Profil"
      resolve:
        thisuser: [
          "User"
          "$route"
          (User, $route) ->
            User.get($route.current.params.userId).then (user) ->
              user
        ]

]

.controller "ProfileViewController", [
  "$scope"
  "Security"
  "thisuser"
  "User"
  "Wish"
  "$upload"
  "$http"
  "breadcrumbs"
  "$cookies"
  "screenSize"
  "$modal"
  "$routeParams"

  ($scope, Security, user, UserModel, Wish, $upload, $http, breadcrumbs, $cookies, screenSize, $modal,  $routeParams) ->

    $scope.user = user
    $scope.default_avatar = if user.avatar.avatar.url == '/assets/team/team-member.jpg' then true else false

    $scope.mobile = screenSize.is('xs')
    $scope.largeScreen = screenSize.is('lg, md')

    # $scope.tabtype = if $scope.mobile then 'pills' else ''
    # $scope.verticaltabs = if $scope.mobile then 'true' else 'false'

    breadcrumbs.options =
      Profil: user.name + "s Profil"
    #$scope.breadcrumbs = breadcrumbs

    $scope.wish_form = {}


    $scope.$watch (->
      Security.is_own_profile(user.id)
    ), (newVal, oldVal) ->
      $scope.own_profile = newVal
      return

    Wish.forUser(user.id).then (wishes) ->
      $scope.user_wishes = wishes

      if $cookies.initial_wishes && $cookies.initial_wishes != ''  && $cookies.initial_wishes != ';'
        $scope.wish_form.new_wish = $cookies.initial_wishes.replace(';','').replace(';','')
        $cookies.initial_wishes = '' if $scope.user_wishes.length > 0


    UserModel.suggestions(user.id).then (suggestions) ->
      $scope.suggestions = suggestions


    $scope.new_name = user.name


    $scope.onFileSelect = ($files) ->

      #$files: an array of files selected, each file has name, size, and type.
      i = 0

      while i < $files.length
        file = $files[i]
        method: 'PUT'
        $scope.upload = $upload.upload(
          url: "/users.json"
          method: 'PUT'
          file: file
          fileFormDataName: 'user[avatar]'
        ).progress((evt) ->
          return
        ).success((data, status, headers, config) ->
          Security.requestCurrentUser()
          $scope.user.avatar.avatar.url = data.avatar.avatar.url
          $scope.user.default_avatar = false
          return
        )
        i++
      return


    $scope.open = () ->
      modalInstance = $modal.open(
        templateUrl: "/assets/edit_profile.html"
        controller: EditProfileCtrl
        size: 'lg'
        resolve:
          userdata: user
      )
      return

    EditProfileCtrl = ($scope, $modalInstance, $route, $location) ->

      $scope.register_user = user
      $scope.delete_account_check = false

      $scope.update_profile = ->
        $scope.submitted = true
        $scope.serverMessage = false
        input =
          user: $scope.register_user

        $http.put("/users.json", input)
        .success((data, status, headers, config) ->
          $modalInstance.dismiss "done"
          $route.reload()
          $scope.submitted = false
        ).error (data, status, headers, config) ->
          $scope.serverMessage = data.email
          $scope.submitted = false
          return

      $scope.delete_account = ->
        input =
          user:
            id: user.id
        $http.delete("/users.json", input)
        .success( ->
          Security.logout()
          $modalInstance.dismiss "done"
          $location.path("/")
        )
        return

      $scope.ok = ->
        $modalInstance.dismiss "done"
        return

      $scope.cancel = ->
        $modalInstance.dismiss "cancel"
        return

    if $routeParams['edit_profile']
      $scope.open()



    $scope.getSuggestions = (q) ->
      Wish.suggestions(q).then (wishes) ->
        r = []
        angular.forEach wishes, (item) ->
          r.push
            text: item.text
            count: item.othersCount
        return r

    $scope.me_too = (wish) ->
      new Wish(
        forUser: 'user_'
        wish_id: wish.id
      ).create()
      .then (response) ->
        $scope.suggestions.splice($scope.suggestions.indexOf(wish), 1)
        $scope.user_wishes.push response



    $scope.addWish = ->

      if $scope.wish_form.new_wish.count
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
        $scope.user_wishes.unshift response
        $scope.wish_form.new_wish = ""
        $scope.wish_form.story = ""


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
]
