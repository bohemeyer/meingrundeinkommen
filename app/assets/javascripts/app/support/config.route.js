(function () {
    'use strict';

    angular
        .module('app.support', ['ngRoute','ngSanitize'])
        .config(function ($routeProvider) {

            $routeProvider
                .when('/tandem', {
                    templateUrl: '/assets/tandem.html',
                    controller: function ($scope, $modal) {

                        $scope.openVideoModal = function(slug) {
                          var VideoModal;
                          return VideoModal = $modal.open({
                            templateUrl: "videomodal.html",
                            size: 'lg',
                            controller: [
                              "$scope", "slug", "$modalInstance", "$sce", function($scope, slug, $modalInstance,$sce) {
                                $scope.slug = $sce.trustAsResourceUrl("//www.youtube.com/embed/" + slug + "?autoplay=1");

                              }
                            ],
                            resolve: {
                              slug: function() {
                                return slug;
                              }
                            }
                          });
                        };

                    },
                })
                .when('/bgemitdir', {
                    redirectTo: '/tandem'
                })
                .when('/advocate-europe', {
                    templateUrl: '/assets/advocateEurope.html'
                })
                .when('/support', {
                    redirectTo: '/support/crowdfund'
                })
                .when('/support/crowdbar', {
                    templateUrl: '/assets/support/crowdbar.html',
                    label: 'Unterstützen'
                })
                .when('/support/crowdcard', {
                    templateUrl: '/assets/support/crowdcard.html',
                    label: 'Unterstützen'
                })
                .when('/support/cola', {
                    templateUrl: '/assets/support/cola.html',
                    label: 'Unterstützen'
                })
                .when('/support/donate', {
                    redirectTo: '/support/crowdfund'
                })
                .when('/support/crowdfund', {
                    templateUrl: '/assets/support/donate.html',
                    controllerAs: 'vm',
                    controller: function ($scope, $location, anchorSmoothScroll) {
                        var vm = this;

                        vm.changeOption = toggleOptions;

                        if ($scope.current.isAuthenticated()) {
                            vm.option = 'primary';
                        }
                        else {
                            vm.option = 'secondary';
                        }

                        function toggleOptions(option) {

                            vm.option = option;

                            anchorSmoothScroll.scrollTo('funding');
                        }

                    },
                    label: 'Unterstützen'
                });

        });

}());