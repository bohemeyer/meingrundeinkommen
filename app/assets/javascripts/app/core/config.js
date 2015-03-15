(function () {
    'use strict';

    var core = angular.module('app.core');

    var config = {};

    core.value('config', config);

    core.config(translation);

    translation.$inject = ['$translateProvider'];

    /**
     * load the translations
     *
     * @param $translateProvider
     */
    function translation ($translateProvider){

        $translateProvider.useStaticFilesLoader({
            prefix: "\/languages\/",
            suffix: ".json"
        });

        $translateProvider.preferredLanguage('deDE');

    };

}());