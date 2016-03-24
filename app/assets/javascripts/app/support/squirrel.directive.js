(function () {
    'use strict';

    angular
        .module('app.support')
        .directive('mgeSquirrel', [Directive]);


    function Directive() {
        return {
            restrict: 'E',
            scope: true,
            templateUrl: 'assets/support/_squirrel_directive.html',
            controllerAs: 'vm',
            controller: function (AuthService, SquirrelService, $scope, Security, $modal) {

                $scope.user = Security

                var vm = this;
                vm.price = 6;
                vm.priceSociety = 3;
                vm.priceBge = 3;
                vm.auth = Security.isAuthenticated();

                // holds the form data in the user scope


                vm.user = {};

                // holds the form data for the payment scope
                vm.payment = {
                    accept: false
                };

                vm.priceChanged = priceChanged;
                vm.shareWithBge = sharePriceWithBge;
                vm.shareWithSociety = sharePriceWithSociety;
                vm.submit = submitForm;
                vm.quit = quit;

                // modals
                vm.showWhy = showWhy;
                vm.showHow = showHow;

                // state of the form
                vm.formState = {
                    show: true,
                    progress: {
                        show: false
                    },
                    response: {
                        show: false
                    }
                };

                // if the bic is required
                vm.bicRequired = false;
                vm.ibanChanged = detectGermanIban;

                /**
                 * options for the slider society amount
                 */
                vm.optionsSociety = {
                    from: 0,
                    to: 6,
                    step: 1,
                    dimension: " €",
                    round: 0,
                    smooth: false,
                    vertical: false,
                    css: {
                        background: {"background-color": "#a2dedd"}
                    }
                }

                /**
                 * options for the slider bge amount
                 */
                vm.optionsBge = {
                    from: 0,
                    to: vm.price,
                    step: 1,
                    dimension: " €",
                    round: 0,
                    smooth: false,
                    vertical: false,
                    css: {
                        background: {"background-color": "#a2dedd"}
                    }
                }

                function quit (){
                    if (confirm('Unterstützung wirklich beenden und alle Kontodaten löschen?')) {
                        vm.delete_me = true;
                        submitForm();
                    }
                }

                function boot (){
                    if(Security.isAuthenticated()) {
                        vm.user.email = Security.user.email;
                        if (Security.user.payment) {
                            var p = Security.user.payment;

                            vm.id = p.id;
                            vm.user.name = p.user_first_name;
                            vm.user.lastName = p.user_last_name;
                            vm.user.address = {
                                street: p.user_street,
                                streetNumber: p.user_street_number,
                                city: p.user_city,
                                zip: p.user_zip,
                            };
                            vm.priceSociety = p.amount_society;
                            vm.priceBge = p.amount_bge;
                            vm.price = p.amount_total;
                            vm.user.bank = {
                                name: p.account_bank,
                                iban: p.account_iban,
                                bic: p.account_bic
                            };
                            vm.payment.accept = p.accept;
                            vm.payment.active = p.active;

                        }
                    }
                }

                boot();

                /**
                 *
                 */
                function submitForm (){

                    if($scope.squirrelForm.$invalid){
                        $scope.squirrelForm.$setDirty();
                        return;
                    }

                    var payment = {
                        user_email: vm.user.email,
                        user_first_name: vm.user.name,
                        user_last_name: vm.user.lastName,
                        user_street: vm.user.address.street,
                        user_street_number: vm.user.address.streetNumber,
                        user_zip: vm.user.address.zip,
                        user_city: vm.user.address.city,
                        amount_society: vm.priceSociety,
                        amount_bge: vm.priceBge,
                        amount_total: vm.price,
                        account_bank: vm.user.bank.name,
                        account_iban: vm.user.bank.iban,
                        account_bic: vm.user.bank.bic,
                        accept: vm.payment.accept,
                        active: vm.payment.active
                    };


                    vm.formState.show = false;
                    vm.formState.edit = false;
                    vm.formState.progress.show = true;

                    if (vm.id) {
                        payment.id = vm.id;
                    }

                    if (vm.delete_me) {
                        payment.delete_me = vm.delete_me;
                        vm.formState.show = true;
                    }


                    var promise = SquirrelService.store(payment);


                    promise.then(function(response) {

                        vm.formState.progress.show = false;
                        vm.formState.response.show = true;

                        vm.id = response.data.id;

                        Security.user.payment = response.data;


                    }, function(error) {
                        console.log(error);
                    });

                };

                /**
                 * change the values
                 */
                function priceChanged() {

                    vm.optionsSociety.to = vm.price;
                    vm.optionsBge.to = vm.optionsSociety.to;
                    resharePrices();

                };

                /**
                 * @deprecated
                 * @param value
                 * @param part
                 * @returns {number}
                 */
                function getPercent(value, part) {
                    return ( part / value);
                }

                /**
                 * @deprecated
                 * @param value
                 * @param percent
                 * @returns {number}
                 */
                function getPart(value, percent){
                    return Math.round( value * percent );
                }

                /**
                 * The society shares with the bge
                 */
                function sharePriceWithBge() {
                    var societyPrice = vm.priceSociety;
                    var total = vm.price;
                    vm.priceBge = (total - societyPrice);
                };

                /**
                 * The bge shares with the society
                 */
                function resharePrices() {

                    var bgePrice = vm.priceBge;
                    var diff = vm.price - vm.priceBge - vm.priceSociety;

                    if (diff >= 0) {
                        vm.priceSociety = vm.priceSociety + diff;
                    }
                    else {
                        vm.priceBge = vm.priceBge + diff;
                        if (vm.priceBge < 0) {
                            vm.priceSociety = vm.priceSociety + vm.priceBge;
                            vm.priceBge = 0;
                        }
                    }
                }

                /**
                 * The bge shares with the society
                 */
                function sharePriceWithSociety() {
                    var bgePrice = vm.priceBge;
                    var total = vm.price;
                    vm.priceSociety = (total - bgePrice);
                };

                /**
                 * Modal for why
                 */
                function showWhy () {
                    var modalInstance = $modal.open({
                        templateUrl: 'squirrel/modal-why.html',
                        controller: modalController,
                        size: 'sm'
                    });
                };

                /**
                 * Modal for how
                 */
                function showHow () {
                    var modalInstance = $modal.open({
                        templateUrl: 'squirrel/modal-how.html',
                        controller:  modalController,
                        size: 'sm'
                    });
                };

                /**
                 *
                 * @param $scope
                 * @param $modalInstance
                 */
                function modalController ($scope,$modalInstance) {
                    $scope.ok = function () {
                        $modalInstance.close();
                    };
                }

                function detectGermanIban(){
                    var iban = vm.user.bank.iban;
                    var contryCode = iban.substring(0, 2);
                    if(contryCode == 'DE' || contryCode == 'de'){
                        vm.bicRequired = true;
                    }else{
                        vm.bicRequired = false;
                    }
                }



            }
        }

    };

}());
