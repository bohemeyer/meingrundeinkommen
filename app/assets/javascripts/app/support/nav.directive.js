(function(){
    'use strict';

    angular
        .module('app.support')
        .directive('mgeSupportNav',[Navigation]);

    function Navigation() {
        return {
            restrict: 'E',
            templateUrl: '/assets/support/_nav.html',
            controllerAs: 'vm',
            controller: function($location){
                var vm = this;
                
                vm.isActive = checkLocationPathIsEqual;

                function checkLocationPathIsEqual(viewLocation) {
                    return viewLocation === $location.path();
                };
            }

        }
    };

}());