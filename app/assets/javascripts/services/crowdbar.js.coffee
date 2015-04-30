angular.module "Crowdbar", ["Flag"]
.factory "Crowdbar", ($http, $interval, $q, $modal, Flag) ->

  verify: (loops = 30, interval = 100) ->

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

    deferred = $q.defer()

    #firefox
    #$http.get("chrome://firebug/content/annotations.json")
    if this.runs_in_this_browser()
      $http.get("chrome-extension://mjeadmcnffmdlplbdceeolmdgdlimhib/manifest.json")
      .success (manifest) ->
        deferred.resolve manifest.version
        deferred.promise
      .error ->
        periodical_crowdbar_test2 = $interval(crowdbar_checker, interval, loops)
        .then ->
          $interval.cancel(periodical_crowdbar_test2)
          deferred.resolve false
    else
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

  get_browser: ->
    ua = navigator.userAgent.match(/chrome|firefox|safari|opera|msie|trident|iPad|iPhone|iPod/i)[0].toLowerCase()
    _ua = window.navigator.userAgent

    browser = {}
    browser.isOpera       = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    browser.isFirefox     = typeof InstallTrigger isnt "undefined" # Firefox 1.0+
    browser.isChrome      = !!window.chrome and not browser.isOpera && !(ua == "ipad" || ua == "iphone" || ua == "ipod") # Chrome 1+
    browser.isSafari      = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0 && !(ua == "ipad" || ua == "iphone" || ua == "ipod")
    browser.isIDevice     =  (/iphone|ipod|ipad/i).test(_ua)
    browser.isMobileChrome= _ua.indexOf('Android') > -1 && (/Chrome\/[.0-9]*/).test(_ua)
    browser.isMobileIE    = _ua.indexOf('Windows Phone') > -1
    browser.isMobile = if ( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i ).test(navigator.userAgent) then true else false
    browser.isMobileSafari = browser.isIDevice && _ua.indexOf('Safari') > -1 && _ua.indexOf('CriOS') < 0
    browser.OS = if browser.isIDevice then 'ios' else if browser.isMobileChrome then 'android' else if browser.isMobileIE then 'windows' else 'unsupported'
    browser.OSVersion = _ua.match(/(OS|Android) (\d+[_\.]\d+)/)
    browser.OSVersion = if browser.OSVersion && browser.OSVersion[2] then browser.OSVersion[2].replace('_', '.') else 0
    browser.isStandalone = window.navigator.standalone || ( browser.isMobileChrome && ( screen.height - document.documentElement.clientHeight < 40 ) )
    browser.isTablet = (browser.isMobileSafari && _ua.indexOf('iPad') > -1) || (browser.isMobileChrome && _ua.indexOf('Mobile') < 0)
    browser.isCompatibleForApp = (browser.isMobileSafari && browser.OSVersion >= 6) || browser.isMobileChrome

    return browser

  runs_in_this_browser: ->
    browser = this.get_browser()
    if (browser.isFirefox || browser.isChrome || browser.isSafari) && !browser.isMobile then true else false

  runs_in_this_browser_as_bookmark: ->
    browser = this.get_browser()
    if browser.isMobile || browser.isCompatibleForApp then true else false


.controller "CrowdbarController", [
  "$scope"
  "$modal"
  "Crowdbar"
  "Support"
  "$location"
  "$http"
  ($scope, $modal, Crowdbar, Support, $location, $http) ->

    $scope.crowdbar = Crowdbar

    $scope.daily_comm = Math.round($scope.home.prediction.avgDailyCommissionCrowdbar)
    $scope.crowdbar_users = $scope.home.crowdbarUsers
    $scope.browser = Crowdbar.get_browser()

    $scope.crowdbar_install = ->
      $scope.current.incFlag('CrowdbarDownloadLinkClicked') if $scope.current.user
      Crowdbar.open_crowdbar_after_install_modal(false)
      $location.search('trigger','crowdbar_installed')
      if $scope.current.participates() && !$scope.current.participation_verified()
        $location.search('trigger2','not_verified')

    $scope.crowdapp_install = ->
      if $scope.current.user
        $location.path('/crowdapp',false).search('installed_for',$scope.current.user.id)
      else
        $location.path('/crowdapp',false).search('installed','1')

      $scope.current.setFlag('crowdappInstallClicked',true)
      modal = $modal.open(
        templateUrl: "/assets/crowdapp_install.html"
        controller: [
          "$scope"
          "browser"
          "Flag"
          ($scope, browser, Flag) ->
            $scope.browser = browser
            $scope.appclass_name = 'ath-container ath-' + browser.OS + ' ath-' + browser.OS + (browser.OSVersion + '').substr(0,1) + ' ath-' + (if browser.isTablet then 'tablet' else 'phone')
            $scope.check_for_crowdapp = ->
              Flag.query().then (flags) ->
                if flags.crowdAppVisits
                  $location.search('trigger','crowdapp_installed')
                  if $scope.current.participates() && !$scope.current.participation_verified()
                    $scope.current.user.flags['crowdAppVisits'] = true
                    $location.search('trigger2','not_verified')
                  $location.path('/boarding')
                  $scope.$emit('go_to_next_step')
                  modal.close()
                else
                  $scope.not_found = true
        ]
        size: 'lg'
        scope: $scope
        resolve:
          browser: ->
            Crowdbar.get_browser()
      )



    Support.get_crowdbar_statements().then (testimonials) ->
      $scope.testimonials = testimonials


# // try to get the highest resolution application icon
#     if ( !this.applicationIcon ) {
#       if ( ath.OS == 'ios' ) {
#         this.applicationIcon = document.querySelector('head link[rel^=apple-touch-icon][sizes="152x152"],head link[rel^=apple-touch-icon][sizes="144x144"],head link[rel^=apple-touch-icon][sizes="120x120"],head link[rel^=apple-touch-icon][sizes="114x114"],head link[rel^=apple-touch-icon]');
#       } else {
#         this.applicationIcon = document.querySelector('head link[rel^="shortcut icon"][sizes="196x196"],head link[rel^=apple-touch-icon]');
#       }
#     }

]