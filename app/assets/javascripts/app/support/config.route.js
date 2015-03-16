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
                    controller: function($location, anchorSmoothScroll){
                        var vm = this;

                        vm.changeOption = toggleOptions;
                        vm.option = 'primary';

                        function toggleOptions (option){

                            vm.option = option;

                            anchorSmoothScroll.scrollTo('funding');
                        }

                    },
                    label: 'Unterstützen'
                });

        });

}());