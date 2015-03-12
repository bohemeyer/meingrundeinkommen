(function(){
    'use strict';

    angular
        .module('app.core', [
            // angular dependencies
            'ngMessages',
            'ngAnimate',
            'ngRoute',

            // third party modules
            'ui.bootstrap',
            'pascalprecht.translate',
            'meta', // check if we need this
            'ng-breadcrumbs', // check for usage
            'Security',
            'ngCookies',
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
            'Crowdcard'
        ]);
}());

//= require_tree .
//= require_self