(function () {
    'use strict';

    angular
        .module('app.support')
        .directive('mgeDonate', [Directive]);

    function Directive() {
        return {
            restrict: 'E',
            templateUrl: 'assets/support/_donate_directive.html',
            controllerAs: 'vm',
            controller: function (SupportService, StatsService, common, $modal) {

                var vm = this;

                vm.submit = submit;
                //vm.stats = getStats;
                vm.stats = {
                    "number_of_users": "34.564",
                    "number_of_wishes": "86.640",
                    "number_of_wishes_raw": 86640,
                    "amount": "2.860",
                    "totally_financed_incomes": 7,
                    "percentage": "24%",
                    "percentage_raw": 23.832042437229028,
                    "supporter": "15.636",
                    "crowdbar_users": "12.001",
                    "crowdbar_amount": 21836.81186777204,
                    "crowdcard_amount": 783.216,
                    "crowdcard_today": "0,00",
                    "crowdcard_users": 12278,
                    "amount_internal": 3805.9139936378,
                    "prediction": {
                        "avg_daily_commission": 423.48928592545644,
                        "avg_daily_commission_crowdbar": 186.46571344988686,
                        "avg_daily_commission_crowdcard": 28.121428571428574,
                        "days": 22,
                        "date": "2015-03-14T03:38:54.055+01:00"
                    },
                    "number_of_participants": "19.614",
                    "supports": [

                    ],
                    "gap": 604.7820045188068
                };

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
                 * @param amount
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
                };

                function getStats() {
                    StatsService
                        .success(function(response){
                            return response.data;
                        })
                        .error(function(error){
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
                    var result = {
                        amount_total: vm.support.amount,
                        amount_for_income: vm.support.donate ? vm.support.amount - internal : vm.support.amount,
                        amount_internal: vm.support.donate ? internal : 0,
                        payment_method: vm.support.payment_method,
                        recurring: vm.support.cmd === '_xclick-subscriptions'
                    };

                    return result;
                };

                /**
                 * Send the Support request to the server and handle the response
                 * @returns {*}
                 */
                function submit() {
                    toggleFormState();
                    SupportService.store(getFormatData())
                        .success(function (response) {
                            // inform the team
                            common.notify.team('A new Donation from' + response.data);
                            // handle the success
                            toggleFormState();
                        })
                        .error(function (error) {
                            common.logger.error(error);
                            common.notify.user('Ein Fehler ist aufgetreten, bitte versuche es später noch einmal!');
                            toggleFormState();
                        });
                };
                function tredd() {


                    return new Support().create().then(function (response) {


                        $scope.support.support_id = response.id;
                        $scope.support.return_url = "https://www.mein-grundeinkommen.de/start?thanks_for_support=" + response.id;
                        $scope.support.item_name = "Zuwendung Nr. " + response.id + " zur Verlosung";

                        if ($scope.support.donate) {
                            $scope.support.item_name = $scope.support.item_name + ", davon 10% Spende an Verein";
                        }

                        $scope.support.support_amount = response.amountTotal;
                        $scope.support.avatar = response.avatar;
                        $scope.support.nickname = response.nickname;

                        if (support.payment_method === 'bank') {

                            // this is the modal
                            return Support.thanks_for_support($scope.support, 'bank', 'sm');

                        } else {
                            document.getElementById('support_id').value = response.id;
                            document.getElementById('return_url').value = "https://www.mein-grundeinkommen.de/start?thanks_for_support=" + response.id;
                            return document.paypal_form.submit();
                        }

                    });
                };

            }
        }
    }
}());