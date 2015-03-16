(function(){
    'use strict';

    angular
        .module('app.support')
        .directive('mgeOrderCCard',[Directive])
        .controller('ModalTestController',['$scope','$modalInstance','options',function($scope, $modalInstance, options){

            $scope.options = options;

            $scope.formData = {
                firstName: null,
                lastName: null,
                city: null,
                street: null,
                houseNumber: null,
                additionalCards: options[3],
                country: 'de'
            };

            $scope.save = function () {
                $modalInstance.close($scope.formData);
            };

            $scope.cancel = function () {
                $modalInstance.dismiss('cancel');
            };
        }]);


    function Directive() {
        return {
            restrict: 'E',
            scope: true,
            templateUrl: '/assets/support/_cCard_order.html',
            controller: function($scope, $modal, common, cCardService) {

                var additionalCardOptions = [
                    {label: 'keine', value:0},
                    {label: 'Eine Karte', value:1},
                    {label: 'Zwei Karten', value:2},
                    {label: 'Drei Karten', value:3},
                    {label: 'Vier Karten', value:4},
                    {label: 'Fünf Karten', value:5},
                    {label: 'Sechs Karten', value:6}
                ];


                $scope.openOrderModal = openModal;

                /**
                 * Open the order crowdCard modal and get the result
                 */
                function openModal() {
                    var modalInstance = $modal.open({
                        templateUrl: 'modal/order/crowdcard.html',
                        controller: 'ModalTestController',
                        size: 'sm',
                        resolve: {
                            options: function () {
                                return additionalCardOptions;
                            }
                        }
                    });

                    modalInstance.result.then(function (result) {
                        // the form is submitted
                        storeCrowdCardOrder(formatData(result));
                    }, function () {
                        // the form is canceled
                        $log.info('Modal dismissed at: ' + new Date());
                    });

                };

                /**
                 * Format the form data to the expected server data
                 * @param data
                 * @returns {*}
                 */
                function formatData(data) {
                    var result = data;
                    result.number_of_cards = data.additionalCards.value + 1;
                    result.last_name = data.lastName;
                    result.first_name = data.firstName;
                    result.zip_code = data.zipCode;
                    result.house_number = data.houseNumber;
                    return result;

                }

                /**
                 *
                 * @param data | the form data from the modal
                 */
                function storeCrowdCardOrder(data) {

                    cCardService.store(data)
                        .success(function(response) {
                            common.notify.team('Eine CrowdCard wurde bestellt. ' + data);


                        })
                        .error(function(error) {
                            common.logger.error(error);
                        });

                };



            }
        }
    }
}());