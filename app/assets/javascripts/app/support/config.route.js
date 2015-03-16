(function () {
    'use strict';

    angular
        .module('app.support')
        .config(function ($routeProvider) {

            $routeProvider
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
                // .when('/support/cola', {
                //     templateUrl: '/assets/support/cola.html',
                //     label: 'Unterstützen'
                // })
                .when('/support/donate', {
                    redirectTo: '/support/crowdfund'
                })
                .when('/support/crowdfund', {
                    templateUrl: '/assets/support/donate.html',
                    controllerAs: 'vm',
                    controller: function($scope, $location, anchorSmoothScroll){
                        var vm = this;

                        vm.changeOption = toggleOptions;

                        if($scope.current.isAuthenticated()) {
                            vm.option = 'primary';
                        }
                        else {
                            vm.option = 'secondary';
                        }

                        function toggleOptions (option){

                            vm.option = option;

                            anchorSmoothScroll.scrollTo('funding');
                        }

                    },
                    label: 'Unterstützen'
                });

        });

}());