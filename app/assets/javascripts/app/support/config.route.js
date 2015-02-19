(function () {
    'use strict';

    angular
        .module('app.support')
        .config(function ($routeProvider) {

            $routeProvider
                .when('/support/crowdbar', {
                    controller: 'SupportController',
                    templateUrl: '/assets/support/crowdbar.html',
                    label: 'Unterstützen'
                })
                .when('/support/crowdcard', {
                    controller: 'SupportController',
                    templateUrl: '/assets/support/crowdcard.html',
                    label: 'Unterstützen'
                })
                .when('/support/cola', {
                    controller: 'SupportController',
                    templateUrl: '/assets/support/cola.html',
                    label: 'Unterstützen'
                })
                .when('/support/donate', {
                    controller: 'SupportController',
                    templateUrl: '/assets/support/donate.html',
                    label: 'Unterstützen'
                });

        });

}());