(function(){
    'use strict';

    angular
        .module('app.data')
        .service('cCardService',['$http',Service]);

    function Service($http) {

        var path = 'api/crowdcards';

        return {
            store: store
        };

        function store(data) {
            return $http.post(path,data);
        }

    }
}());