(function(){
    'use strict';

    angular
        .module('app.support')
        .directive('mgeCBarButton',[Buttons]);

    function Buttons() {
        return {
            restrict: 'E',
            scope: true,
            templateUrl: '/assets/support/_cBar_button.html',
            controller: function($scope,Crowdbar,$modal){


                $scope.crowdbar = Crowdbar; // for install crowdbar buttons
                $scope.browser = Crowdbar.get_browser(); // for install crowdbar buttons

                /**
                 *
                 * @returns {Object}
                 */
                $scope.crowdbar_install = function() {
                    if ($scope.current.user) {
                        $scope.current.incFlag('CrowdbarDownloadLinkClicked');
                    }
                    Crowdbar.open_crowdbar_after_install_modal(false);
                    $location.search('trigger', 'crowdbar_installed');
                    if ($scope.current.participates() && !$scope.current.participation_verified()) {
                        return $location.search('trigger2', 'not_verified');
                    }
                };

                $scope.crowdapp_install = function() {
                    var modal;
                    if ($scope.current.user) {
                        $location.path('/crowdapp', false).search('installed_for', $scope.current.user.id);
                    } else {
                        $location.path('/crowdapp', false).search('installed', '1');
                    }
                    $scope.current.setFlag('crowdappInstallClicked', true);
                    return modal = $modal.open({
                        templateUrl: "/assets/crowdapp_install.html",
                        controller: [
                            "$scope", "browser", "Flag", function($scope, browser, Flag) {
                                $scope.browser = browser;
                                $scope.appclass_name = 'ath-container ath-' + browser.OS + ' ath-' + browser.OS + (browser.OSVersion + '').substr(0, 1) + ' ath-' + (browser.isTablet ? 'tablet' : 'phone');
                                return $scope.check_for_crowdapp = function() {
                                    return Flag.query().then(function(flags) {
                                        if (flags.crowdAppVisits) {
                                            $location.search('trigger', 'crowdapp_installed');
                                            if ($scope.current.participates() && !$scope.current.participation_verified()) {
                                                $scope.current.user.flags['crowdAppVisits'] = true;
                                                $location.search('trigger2', 'not_verified');
                                            }
                                            $location.path('/boarding');
                                            $scope.$emit('go_to_next_step');
                                            return modal.close();
                                        } else {
                                            return $scope.not_found = true;
                                        }
                                    });
                                };
                            }
                        ],
                        size: 'lg',
                        scope: $scope,
                        resolve: {
                            browser: function() {
                                return Crowdbar.get_browser();
                            }
                        }
                    });
                };

            }
        }
    }

}());