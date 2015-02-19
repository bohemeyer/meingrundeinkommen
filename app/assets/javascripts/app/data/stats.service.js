(function () {
    'use strict';

    angular
        .module('app.data')
        .service('StatsService', ['$http', '$log', Service]);

    function Service($http, $log) {


        return $http.get('/api/homepages')
            .success(function (response) {
                return response.data;
            })
            .error(function (error) {
                return {};
                $log.error(error);
            });


    };
}());