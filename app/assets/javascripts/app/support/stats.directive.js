(function () {
    'use strict';

    angular
        .module('app.support')
        .directive('mgeStats', [Directive]);


    function Directive() {
        // usage <mge-stats></mge-stats>
        // params: link | boolean
        return {
            restrict: 'E',
            scope: {
                link: '='
            },
            templateUrl: 'assets/support/_stats.html',
            controllerAs: 'vm',
            controller: function ($scope,StatsService) {

                var vm = this;
                vm.stats = StatsService;
                var showLink = !!$scope.link;

                vm.showLink =  showLink;
            }
        }

    };

}());