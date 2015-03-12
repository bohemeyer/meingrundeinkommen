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
            controller: function ($scope) {

                var vm = this;
                var showLink = !!$scope.link;

                vm.showLink =  showLink;
            }
        }

    };

}());