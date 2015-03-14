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

            var deferred = $q.defer();

            setTimeout(function() {
                deferred.notify('About to greet ' + name + '.');

                if (data.success) {
                    deferred.resolve('Hello, ' + name + '!');
                } else {
                    deferred.reject('Greeting ' + name + ' is not allowed.');
                }
            }, 2000);

            return deferred.promise;




        };


    }

}());