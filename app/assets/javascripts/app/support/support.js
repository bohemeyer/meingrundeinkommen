(function(){
    'use strict';

    angular
        .module('app.support')
        .controller('SupportNController',['$location','Crowdbar','$scope',SupportController]);

    function SupportController($location,Crowdbar,$scope) {

        var vm = this;

        /* public interface */
        vm.isActive = checkLocationPathIsEqual; // for support navigation
        vm.crowdbar = Crowdbar; // for install crowdbar buttons
        vm.browser = Crowdbar.get_browser(); // for install crowdbar buttons

        console.log($scope.home);

        /* implementation */

        function checkLocationPathIsEqual (viewLocation) {
            return viewLocation === $location.path();
        };




    };

}());