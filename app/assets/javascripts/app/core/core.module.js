(function(){
    'use strict';

    angular
        .module('app.core', [
            // angular dependencies
            'ngMessages',
            'ngAnimate',
            'ngRoute',
            'ngCookies',

            // third party modules
            // TODO separate our modules from third party stuff
            'ui.bootstrap',
            'pascalprecht.translate',
            'ngSlider',
            'mm.iban',

            'Devise',
            'meta', // check if we need this
            'ng-breadcrumbs', // check for usage
            'Security',
            'rails',
            'angulartics',
            'angulartics.google.analytics',
            'login',
            'reset_password',
            'home',
            'register',
            'profile',
            'wishpage',
            'content',
            'smoothScroll',
            'faq',
            'draw',
            'drawfrontend',
            'Support',
            'djds4rce.angular-socialshare',
            'admin',
            'blog',
            'boarding',
            'Crowdbar',
            'Crowdcard',
            'textAngular'
        ]);
}());

//= require_tree .
//= require_self