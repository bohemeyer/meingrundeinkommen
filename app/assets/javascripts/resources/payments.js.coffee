angular.module "Payment", ["rails"]
.factory "Payment", [
  "railsResourceFactory"
  "$modal"
  (rails, $modal) ->

    Payment = rails(
      url: "/api/payments/{{id}}"
      name: "payment"
    )

    return Payment
]

.controller "PaymentsController", [
  "$scope"
  "$modal"
  "Payment"
  ($scope, $modal, Payment) ->

    $scope.payment.delete = ->
      new Payment(
        id: $scope.current.user.payment.id
      ).delete().then ->
        #blalbalba


    $scope.payment.update = ->
      new Payment(
        id: $scope.current.user.payment.id
        active: $scope.new_payment.active
      ).update().then ->
        #blalbalba

    $scope.payment.create = ->
      new Payment(
        amount_total: 10
        amount_for_income: 8
        amount_internal: 2
        bank_owner: new_payment.bank_owner
        bank_account: new_payment.bank_account
        bank_code: new_payment.bank_code
        email: if $scope.current.user then $scope.current.user.email else new_payment.email
      ).create()
      .then (response) ->
        if response.errors
          #bububu
        else
          #lallala



]
