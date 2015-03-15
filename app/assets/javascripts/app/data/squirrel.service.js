(function(){
    'use strict';

    angular
        .module('app.data')
        .factory('SquirrelService',['$http','$q',Factory]);


    function Factory ($http, $q){

        var service = {
            store: store
        };

        return service;

        function store (data){

           return $http.post('/api/payments/',data);

        };


    }

}());