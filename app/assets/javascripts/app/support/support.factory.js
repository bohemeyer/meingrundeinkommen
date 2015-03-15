(function(){
    'use strict';

    angular
        .module('app.support')
        .factory('SupportFactory', ['railsResourceFactory','$modal',SupportFactory]);

    function SupportFactory(railsResourceFactory,$modal) {

        var Support;
        Support = railsResourceFactory({
            url: "/api/supports/{{id}}",
            name: "support"
        });
        Support.thanks_for_support = function(support, template, size) {
            var modalInstance;
            if (template == null) {
                template = 'thanks_for_support';
            }
            if (size == null) {
                size = 'md';
            }
            modalInstance = $modal.open({
                templateUrl: "/assets/" + template + ".html",
                controller: "SupportThanksController",
                size: size,
                resolve: {
                    items: function() {
                        return support;
                    }
                }
            });
        };
        return Support;
    };

}());
