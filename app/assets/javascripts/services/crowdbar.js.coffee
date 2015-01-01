angular.module "Crowdbar", []
.factory "Crowdbar", ($http, $interval, $q, $modal) ->

  deferred = $q.defer()

  verify: (loops = 30, interval = 100) ->
    # firebug = null
    # #Create img tags
    # firebug_img = document.createElement("img")
    # firebug_img.addEventListener "load", ((e) ->
    #   #alert true
    #   firebug = true
    #   return
    # ), false
    # firebug_img.addEventListener "error", ((e) ->
    #   #alert false
    #   firebug = false
    #   return
    # ), false
    # #
    # # * Set the src-attribute to an internal image resource
    # # * of the extensions using the chrome protocol
    # #
    # firebug_img.setAttribute "src", "chrome://firebug/content/firebug32.png"


    crowdbar_checker = ->
      if window.document.getElementById('crowd_bar_verified')
        deferred.resolve 1
        deferred.promise
      else
        if window.document.getElementById('crowd_bar_verified_2')
          deferred.resolve 2
          deferred.promise
        else
          return false

    #firefox
    #$http.get("chrome://firebug/content/annotations.json")
    $http.get("chrome-extension://mjeadmcnffmdlplbdceeolmdgdlimhib/manifest.json")
    .success (manifest) ->
      deferred.resolve manifest.version
      deferred.promise
    .error ->
      periodical_crowdbar_test2 = $interval(crowdbar_checker, interval, loops)
      .then ->
        $interval.cancel(periodical_crowdbar_test2)
        deferred.resolve false

    return deferred.promise


  open_crowdbar_after_install_modal: (not_found = false) ->

    $modal.open(
      templateUrl: "/assets/crowdbar_check.html"
      controller: [
        "$scope"
        "installation_not_found"
        ($scope,installation_not_found) ->
          $scope.installation_not_found = installation_not_found
          $scope.close = ->
            $modalInstance.dismiss('cancel')
          $scope.reload = ->
            location.reload()
      ]
      size: 'lg'
      resolve:
        installation_not_found: ->
          not_found
    )

.controller "CrowdbarController", [
  "$scope"
  "$modal"
  "Crowdbar"
  "Support"
  "$location"
  "$http"
  ($scope, $modal, Crowdbar, Support, $location, $http) ->

    $scope.daily_comm = Math.round($scope.home.prediction.avgDailyCommissionCrowdbar)
    $scope.crowdbar_users = $scope.home.crowdbarUsers

    $scope.crowdbar_install = ->
      $scope.current.incFlag('CrowdbarDownloadLinkClicked') if $scope.current.user
      Crowdbar.open_crowdbar_after_install_modal(false)
      $location.search('trigger','crowdbar_installed')

    Support.query(
      crowdbar: true
    ).then (testimonials) ->
      $scope.testimonials = testimonials




]