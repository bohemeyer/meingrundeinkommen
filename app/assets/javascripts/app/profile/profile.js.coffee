angular.module("profile", ["User","Wish","Chance","State","Avatar",'ng-breadcrumbs','matchMedia'])
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
  "$rootScope"
  "Security"
  "thisuser"
  "User"
  "$http"
  "breadcrumbs"
  "$cookies"
  "screenSize"
  "$modal"
  "$routeParams"
  "filterFilter"
  "$location"

  ($scope, $rootScope, Security, user, UserModel, $http, breadcrumbs, $cookies, screenSize, $modal,  $routeParams, filterFilter, $location) ->

    # $scope.flagtest = (key, value) ->
    #   $scope.current.setFlag key, value

    $scope.user = user
    $scope.chances_form =
      chances: user.chances

    #todo: put in current user service
    $scope.default_avatar = if $scope.current && $scope.current.is_own_profile(user.id) && $scope.current.is_default_avatar() then true else false

    $scope.mobile = screenSize.is('xs')
    $scope.largeScreen = screenSize.is('lg, md')
    $scope.smallScreen = screenSize.is('sm, xs')

    $scope.skip = []
    $scope.currentTab = []
    $scope.tabs = ['wishes', 'image', 'states', 'gewinnspiel', 'crowdbar']

    # $scope.tabtype = if $scope.mobile then 'pills' else ''
    # $scope.verticaltabs = if $scope.mobile then 'true' else 'false'

    breadcrumbs.options =
      Profil: user.name + "s Profil"
    #$scope.breadcrumbs = breadcrumbs

    $scope.$watch (->
      Security.is_own_profile(user.id)
    ), (newVal, oldVal) ->
      $scope.own_profile = newVal
      return

    $scope.new_name = user.name

    $scope.skip_section = (section) ->
      $scope.skip[section] = true
      angular.forEach $scope.tabs, (tabname,key) ->
        if tabname == section
          $scope.currentTab[$scope.tabs[key]] = false
          $scope.currentTab[$scope.tabs[key + 1]] = true

    $scope.setNewsletterFlag = () ->
      $http.put("/users.json",
        user:
          newsletter: true
      )

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

    if $routeParams['gewinnspiel']
      $scope.currentTab.gewinnspiel = true

    if $routeParams['states']
      $scope.currentTab.states = true

    if $routeParams['crowdbar']
      $scope.currentTab.crowdbar = true

    $scope.jumpToFirstTab = ->
      $scope.currentTab = []
      $scope.currentTab.wishes = true


    # $scope.open_crowdbar_test_modal = () ->
    #   modalInstance = $modal.open(
    #     templateUrl: "/assets/crowdbar_check.html"
    #     controller: "CrowdbarModalCtrl"
    #     resolve:
    #       items: ->
    #         $scope.home
    #       browser: ->
    #         $scope.browser
    #     size: 'lg'
    #   )

    #   modalInstance.result.then ->
    #     r = $scope.participation.crowdbar_test()
    #     $scope.participation.has_crowdbar = r
    #     $scope.save_crowdbar_verified_to_db() if r
    #     $scope.save_crowdbar_problem_to_db() if !r
    #   ,
    #   ->
    #     r = $scope.participation.crowdbar_test()
    #     $scope.participation.has_crowdbar = r
    #     $scope.save_crowdbar_verified_to_db() if r
    #     $scope.save_crowdbar_problem_to_db() if !r
    #   return

    # $scope.save_crowdbar_problem_to_db = () ->
    #   $http.put("/users.json",
    #     user:
    #       id: user.id
    #       crowdbar_not_found: true
    #   )

    $scope.save_crowdbar_verified_to_db = () ->
      $http.put("/users.json",
        user:
          id: user.id
          has_crowdbar: true
          crowdbar_not_found: false
      ).then (r) ->
        $scope.participation.double_chances = if !r.ignore_double_chance then true else false


    # if $routeParams['crowdbar_install']
    #   $scope.skip_section('gewinnspiel')
    #   $scope.open_crowdbar_test_modal()
]
