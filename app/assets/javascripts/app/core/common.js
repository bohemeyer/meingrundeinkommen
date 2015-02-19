(function(){
    'use strict';

    angular
        .module('app.core')
        .service('common',['$http','$log',Common]);

    function Common($http,$log) {

        return {
            logger: {
                info: logInfo,
                error: logError
            },
            notify: {
                user: notifyUser,
                team: notifyTeam
            }
        };


        /**
         * To log something in the console
         * @param msg
         */
        function logInfo(msg) {
            $log.info(msg);
        }

        /**
         * To log an error in a external service
         * or in a chat for developer
         * TODO implement something useful
         * @param msg
         */
        function logError(msg) {
            $log.error(msg);
        }

        /**
         * Notify the user by a toast
         * @param msg
         */
        function notifyUser(msg) {
            // TODO implementation
        }

        /**
         * Notify the team about events in
         * a chat or what ever
         * @param msg
         */
        function notifyTeam(msg) {
            // TODO implementation
        }

    }


}());