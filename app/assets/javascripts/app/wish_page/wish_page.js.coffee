angular.module("wish_page", ["User","Wish","angularFileUpload",'ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/profiles/:userId",
      templateUrl: "/assets/profile.html"
      controller: "ProfileViewController"
      label: "Profil"
      resolve:
        user: [
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
  "user"
  "Wish"
  "$upload"
  "$http"
  "breadcrumbs"
  "$cookies"

  ($scope, Security, user, Wish, $upload, $http, breadcrumbs, $cookies) ->
    $scope.user = user
    breadcrumbs.options =
      user.name + "s Profil"
    $scope.breadcrumbs = breadcrumbs

    $scope.$watch (->
      Security.currentUser
    ), (newVal, oldVal) ->
      $scope.user = newVal
      return

    $scope.$watch (->
      Security.is_own_profile(user.id)
    ), (newVal, oldVal) ->
      $scope.own_profile = newVal
      return

    Wish.forUser(user.id).then (wishes) ->
      $scope.user_wishes = wishes

      if $cookies.initial_wishes && $cookies.initial_wishes != ''  && $cookies.initial_wishes != ';'
        $scope.new_wish = $cookies.initial_wishes.replace(';','').replace(';','')
        $cookies.initial_wishes = '' if $scope.user_wishes.length > 0

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
          return
        )
        i++
      return



    $scope.updateProfile = ->
      input =
        user:
          name: $scope.new_name

      $http.put("/users.json", input)
      .success((data, status, headers, config) ->
        Security.requestCurrentUser()
      ).error (data, status, headers, config) ->
        console.log data


    $scope.addWish = ->
      new Wish(
        text: $scope.new_wish
        story: "bla"
      ).create()
      $scope.user_wishes.push
        text: $scope.new_wish

      $scope.new_wish = ""

    $scope.removeWish = (user_wish) ->
      new Wish(
        id: user_wish.id
        forUser: 'user_'
      ).delete()
      $scope.user_wishes.splice($scope.user_wishes.indexOf(user_wish), 1)
]
