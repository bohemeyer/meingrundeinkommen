(function () {
    'use strict';

    angular
        .module('app.support')
        .config(function ($routeProvider) {

            $routeProvider
                .when('/support/crowdbar', {
                    controller: 'SupportNController',
                    controllerAs: 'vm',
                    templateUrl: '/assets/support/crowdbar.html',
                    label: 'Unterstützen'
                })
                .when('/support/crowdcard', {
                    controller: 'SupportNController',
                    controllerAs: 'vm',
                    templateUrl: '/assets/support/crowdcard.html',
                    label: 'Unterstützen'
                })
                .when('/support/cola', {
                    controller: 'SupportNController',
                    controllerAs: 'vm',
                    templateUrl: '/assets/support/cola.html',
                    label: 'Unterstützen'
                })
                .when('/support/donate', {
                    controller: 'SupportNController',
                    controllerAs: 'vm',
                    templateUrl: '/assets/support/donate.html',
                    label: 'Unterstützen'
                });

        });

}());