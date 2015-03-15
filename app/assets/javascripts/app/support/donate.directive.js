(function () {
    'use strict';

    angular
        .module('app.support')
        .directive('mgeDonate', [Directive]);

    function Directive() {
        return {
            restrict: 'E',
            scope: true,
            templateUrl: 'assets/support/_donate_directive.html',
            controllerAs: 'vm',
            controller: function (SupportService, StatsService, common, $modal) {

                var vm = this;

                vm.submit = submit;
                vm.stats = getStats;


                /**
                 * The Form object
                 * @type {{amount: number, donate: boolean, payment_method: string, cmd: string}}
                 */
                vm.support = {
                    amount: 33,
                    donate: true,
                    payment_method: '',
                    cmd: '_xclick'
                };

                /**
                 * Available payment methods
                 * @type {{label: string, value: string}[]}
                 */
                vm.payment_methods = [
                    {label: 'Überweisung', value: 'bank'},
                    {label: 'Flattr', value: 'flattr'}
                ];
                vm.support.payment_method = vm.payment_methods[0].value; // init the payment method

                /**
                 * Handle the gui state
                 * @type {{donateForm: {request: boolean}}}
                 */
                vm.gui = {
                    donateForm: {
                        request: false
                    }
                };

                /**
                 * variable and function reference for the calc string
                 * @type {string}
                 */
                vm.geString = 'hallo';
                vm.calculateGeString = calc;


                /**
                 * expect 33€ entsprechen 1 Tag Grundeinkommen
                 *
                 * @returns {string}
                 */
                function calc() {
                    var amount = vm.support.amount;
                    var hours, string;

                    string = amount + '€ entsprechen ';

                    if (amount > 32) {
                        string += Math.floor(amount / 33) + ' Tag';
                        if (amount > 65) {
                            string += 'en';
                        }
                    }

                    hours = Math.floor((amount % 33) / 1.375);

                    if (amount === 1) {
                        string += '20 Minuten';
                    }

                    if (hours > 0) {
                        if (amount > 32) {
                            string += ' und';
                        }
                        string += ' ' + hours + ' Stunden';
                    }

                    string += ' Grundeinkommen';

                    vm.geString = string;
                }

                function getStats() {
                    StatsService
                        .success(function (response) {
                            return response.data;
                        })
                        .error(function (error) {
                            common.logger.error(error);
                        });
                }


                /**
                 * toggle the gui state for the form
                 */
                function toggleFormState() {
                    vm.gui.donateForm.request = !vm.gui.donateForm.request;
                }

                /**
                 * Format the data before send request
                 * @returns {{amount_total: (number|Document.donateForm.amount|Document.paypal_form.amount), amount_for_income: number, amount_internal: string, payment_method: (string|*), recurring: boolean}}
                 */
                function getFormatData() {
                    var internal = (vm.support.amount * 0.1).toFixed(2);
                    return {
                        amount_total: vm.support.amount,
                        amount_for_income: vm.support.donate ? vm.support.amount - internal : vm.support.amount,
                        amount_internal: vm.support.donate ? internal : 0,
                        payment_method: vm.support.payment_method,
                        recurring: vm.support.cmd === '_xclick-subscriptions'
                    };
                }

                /**
                 *
                 * @returns {*}
                 * @params object {} the object to extend
                 */
                function extendDataByResult(data) {

                    return angular.extend(vm.support, data);
                }

                /**
                 * Send the Support request to the server and handle the response
                 * @returns {*}
                 */
                function submit() {
                    toggleFormState();
                    SupportService.store(getFormatData())
                        .success(function (response) {
                            // inform the team
                            common.notify.team('A new Donation from' + response);
                            // handle the success
                            console.log(response);
                            handleSupportSuccessBank(response);
                            toggleFormState();
                        })
                        .error(function (error) {
                            common.logger.error(error);
                            common.notify.user('Ein Fehler ist aufgetreten, bitte versuche es später noch einmal!');
                            toggleFormState();
                        });
                }

                /**
                 *
                 * @param supportData the response from the server
                 */
                function handleSupportSuccessBank(supportData) {

                    var modalInstance = $modal.open({
                        templateUrl: 'modal/support/bank.html',
                        controllerAs: 'vm',
                        controller: function ($modalInstance,data) {

                            var vm = this;

                            vm.support = data;

                            vm.ok = function () {

                                $modalInstance.close(data);
                            };

                            vm.cancel = function () {
                                $modalInstance.dismiss('cancel');
                            };

                        },
                        size: 'lg',
                        resolve: {
                            data: function() {
                                return extendDataByResult(supportData);
                            }
                        }
                    });

                    /**
                     * handle the result from the modal
                     */
                    modalInstance.result.then(function(result){
                        SupportService.save(result)
                            .success(function(response){
                                common.notify.team('Donation updated ' + response);

                            })
                            .error(function(error) {
                                common.logger.error('Error by updating donation ' + error);

                            });

                    }, function() {
                       common.logger.info('Support modal dismissed.');
                    });

                }

            }
        }
    }
}());