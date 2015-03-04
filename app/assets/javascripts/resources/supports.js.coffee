angular.module "Support", ["rails"]
.factory "Support", [
  "railsResourceFactory"
  "$modal"
  (rails, $modal) ->

    Support = rails(
      url: "/api/supports/{{id}}"
      name: "support"
    )


    Support.thanks_for_support = (support, template = 'thanks_for_support', size = 'md') ->
      modalInstance = $modal.open(
        templateUrl: "/assets/#{template}.html"
        controller: "SupportThanksController"
        size: size
        resolve:
          items: ->
            support
      )
      return

    return Support
]

.controller "SupportController", [
  "$scope"
  "$location"
  "$modal"
  "Support"
  "Crowdbar"
  "$routeParams"
  ($scope, $location, $modal, Support, Crowdbar, $routeParams) ->

    $scope.tabs =
      crowdbar: false
      crowdcard: false
      crowdfund: false
      donate: false
      cola: false

    if $routeParams['support_type']
      $scope.tabs[$routeParams['support_type']] = true
      if $routeParams['support_type'] == 'colagetrunken'
        $scope.tabs['cola'] = true
    else
      $scope.tabs.crowdbar = true

    # if $location.search().tab
    #   alert $location.search().tab

    if $location.search().trigger && $location.search().trigger == 'crowdbar_installed'

      Crowdbar.verify().then (has_crowdbar) ->
        if has_crowdbar
          modalInstance = $modal.open(
            templateUrl: "/assets/boarding/crowdbar_thanks.html"
            size: 'lg'
          )
        else
          Crowdbar.open_crowdbar_after_install_modal(true)
          $scope.current.setFlag('crowdbarNotFoundAfterInstall', true)






    $scope.support = {}
    $scope.support.amount = 33
    $scope.support.donate = true
    $scope.support.cmd = '_xclick'
    $scope.support.payment_method = 'bank'
    $scope.support.equals_bi = ''
    $scope.support.support_id = ''

    $scope.support.create = ->
      $scope.support.submitted = true

      support = $scope.support

      internal = (support.amount * 0.1).toFixed(2)

      new Support(
        amount_total: support.amount
        amount_for_income: if support.donate then support.amount - internal else support.amount
        amount_internal: if support.donate then internal else 0
        payment_method: support.payment_method
        recurring: support.cmd == '_xclick-subscriptions'
      ).create()
      .then (response) ->
        if response.errors
          $scope.support.submitted = false
          $scope.support.errors = response.errors
        else
          $scope.support.support_id = response.id
          $scope.support.return_url = "https://www.mein-grundeinkommen.de/start?thanks_for_support=" + response.id
          $scope.support.item_name = "Donatie voor Nr. #{response.id} "
          $scope.support.item_name = $scope.support.item_name + ", hiervan 10% doneert aan de stichting" if $scope.support.donate
          $scope.support.support_amount = response.amountTotal
          $scope.support.avatar = response.avatar
          $scope.support.nickname = response.nickname

          if support.payment_method == 'bank'
            $scope.support.submitted = false
            Support.thanks_for_support($scope.support,'bank','sm')
          else
            document.getElementById('support_id').value = response.id
            document.getElementById('return_url').value = "https://www.mein-grundeinkommen.de/start?thanks_for_support=" + response.id
            document.paypal_form.submit()


    $scope.support.set_equals_bi = (nv) ->
      r = '€ '+ nv + ',- euro volstaat voor '
      if nv > 32
        r += Math.floor((nv / 33)) + ' Dag'
        if nv > 65
          r += 'en'
      hours = Math.floor((nv % 33) / 1.375)
      if nv == 1
        r += '20 Minuten'
      if hours > 0
        if nv > 32
          r += ' und'
        r += ' ' + hours + ' Uren'
      r += ' Basisinkomen'
      $scope.support.equals_bi = r


    $scope.support.set_equals_bi($scope.support.amount)

]

.controller "SupportThanksController", [
  "$scope"
  "$modalInstance"
  "items"
  "Support"
  ($scope, $modalInstance, items, Support) ->

    $scope.supported = items

    console.log items
    $scope.close = ->
      $modalInstance.dismiss('cancel')

    $scope.save_comment = (id,nickname,comment) ->
      new Support(
        id: id
        comment: comment
        nickname: nickname
      ).update().then ->
        $modalInstance.dismiss('cancel')
      return
]