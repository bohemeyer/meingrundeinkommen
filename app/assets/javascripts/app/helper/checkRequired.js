(function () {
    'use strict';

    angular
        .module('app.helper')
        .directive('checkRequired', [ Directive]);


    function Directive() {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attrs, ngModel) {
                ngModel.$validators.checkRequired = function (modelValue, viewValue) {
                    var value = modelValue || viewValue;
                    var match = scope.$eval(attrs.ngTrueValue) || true;
                    return value && match === value;
                };
            }
        };

    };

}());
