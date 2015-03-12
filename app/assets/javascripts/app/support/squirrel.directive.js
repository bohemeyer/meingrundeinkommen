(function () {
    'use strict';

    angular
        .module('app.support')
        .directive('mgeSquirrel', [ Directive]);


    function Directive() {
        return {
            restrict: 'E',
            scope: true,
            templateUrl: 'assets/support/_squirrel_directive.html',
            controllerAs: 'vm',
            controller: function () {

                var vm = this;




            }
        }

    };

}());