(function(){
    'use strict';

    angular
        .module('app.auth')
        .factory('AuthService',[Factory]);

    Factory.$inject = ['$http'];

    function Factory ($http){

        var service = {

            user: true

        };

        return service;

        function checkAuth (){
            // check auth status
        }

    };
}());