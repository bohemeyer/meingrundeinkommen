(function(){
    'use strict';

    angular
        .module('app.data')
        .service('SupportService',['$http',Service]);

    function Service($http) {

        var path = 'api/supports';

        return {
            store: store,
            save: save
        };

        function store(data) {
            return $http.post(path,data);
        }

        function save(data) {
            return $http.put(path + '/' + data.id,data);
        }


    }
}());