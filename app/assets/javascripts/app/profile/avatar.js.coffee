angular.module "Avatar", ["angularFileUpload"]
.controller "AvatarController", [
  "$scope"
  "$upload"
  ($scope, $upload) ->

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
          $scope.current.user.avatar.avatar.url = data.avatar.avatar.url
          $scope.user.avatar.avatar.url = data.avatar.avatar.url
          $scope.default_avatar = false
          $scope.current.user.default_avatar = false
          $scope.steps.done = true if $scope.steps
          # if $scope.currentTab.image
          #   $scope.skip_section('image')
          return
        )
        i++
      return
]