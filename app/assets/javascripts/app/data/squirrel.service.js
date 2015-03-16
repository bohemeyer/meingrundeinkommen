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

           if (data.id) {
                return $http.put('/api/payments/' + data.id ,data);

           }
           else {
                return $http.post('/api/payments/',data);
           }

        };


    }

}());