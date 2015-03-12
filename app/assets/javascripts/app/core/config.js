(function () {
    'use strict';

    var core = angular.module('app.core');

    var config = {};

    core.value('config', config);

    core.config(translation);

    translation.$inject = ['$translateProvider'];

    /**
     * load the translations
     * TODO load this from separate files
     * @param $translateProvider
     */
    function translation ($translateProvider){
        $translateProvider.translations('de', {
            // globals
            OF: 'von',


            // global form keys
            FORM_NAME_LABEL: '',
            FORM_NAME_PLACEHOLDER: '',

            FORM_LAST_NAME_LABEL: '',
            FORM_LAST_NAME_PLACEHOLDER: '',

            FORM_STREET_LABEL: '',
            FORM_STREET_PLACEHOLDER: '',

            FORM_STREET_NUMBER_LABEL: '',
            FORM_STREET_NUMBER_PLACEHOLDER: '',

            FORM_BANK_LABEL: '',
            FORM_BANK_PLACEHOLDER: '',

            FORM_BIC_LABEL: '',
            FORM_BIC_PLACEHOLDER: '',

            FORM_IBAN_LABEL: '',
            FORM_IBAN_PLACEHOLDER: '',

            // farm validations
            VALIDATION_REQUIRED: '',
            VALIDATION_MIN: '',
            VALIDATION_MAX: '',
            VALIDATION_NUMERIC: '',
            VALIDATION_IBAN: '',
            VALIDATION_BIC: '',

            // stats directive
            STATS_SUPPORT_BUTTON: 'Ich will unterstützen',
            STATS_HEADING: 'Hilf direkt mit, das {{count}} . Grundeinkommen zu finanzieren!',
            STATS_INTRO: '{{amount}} von 12.000€ sind schon zusammen.',

            // donate directive
            DONATE_HEADING: 'Jetzt einmalig unterstützen.',
            DONATE_BUTTON: 'Jetzt unterstützen!',
            DONATE_CALC: 'davon 10% ({{calc}}€) an den Verein spenden',
            // TODO translate the form

            // be a squirrel directive
            SQUIRREL_HEADING: '',
            SQUIRREL_INTRO_ONE: '',
            SQUIRREL_INTRO_TWO: '',
            SQUIRREL_INFO_WHY: '',
            SQUIRREL_INFO_WHY_LINK: '',
            SQUIRREL_INFO_HOW: '',
            SQUIRREL_INFO_HOW_LINK: '',
            SQUIRREL_ACCEPT: '',
            SQUIRREL_SUBMIT: '',

            // support/funding
            SUPPORT_CHOOSE_HEADING: 'Werde Hörnchen',
            SUPPORT_CHOOSE_INTRO: 'Mach das jetzt',
            SUPPORT_OPTION_PRIMARY: 'Crowdhörnchen werden',
            SUPPORT_OPTION_SECONDARY: 'Einmalig unterstützen'



        });

        $translateProvider.preferredLanguage('de');

    };

}());