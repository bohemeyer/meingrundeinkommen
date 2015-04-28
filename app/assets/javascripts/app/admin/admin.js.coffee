angular.module("admin", ["Support", "Registration", "Statistic", "Flag", "Payment", "Mailing"])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/admin",
      templateUrl: "/assets/admin.html"
      controller: "AdminController"
]

.controller "AdminController", [
  "$scope"
  "Support"
  "Registration"
  "Crowdcard"
  "Statistic"
  "Flag"
  "Payment"
  "Mailing"

  ($scope, Support, Registration, Crowdcard, Statistic, Flag, Payment, Mailing) ->

    $scope.u = {}
    $scope.u.search = ''
    $scope.pymnt = {}
    $scope.pymnt.search = ''
    $scope.mail = {}
    $scope.mail.body = '<p>Hallo *|name|*,</p><p><br></p><p><br></p><p><br></p><p>Dein Mein-Grundeinkommen-Team</p><p><br></p><hr><p>Mein Grundeinkommen bei <a href="http://www.facebook.com/MeinGrundeinkommen">Facebook</a> &amp; <a href="http://www.twitter.com/meinbge">Twitter</a> | Keine weiteren Mails erhalten: <a href="https://www.mein-grundeinkommen.de/subscriptions/*|uid|*?email=*|email|*">Hier</a> klicken</p>'
    $scope.mail.subject = ""

    # Support.query(
    #   admin: true
    # ).then (supports) ->
    #   $scope.supports = supports

    # Crowdcard.query(
    #   admin: true
    # ).then (crowdcards) ->
    #   $scope.crowdcards = crowdcards

    Statistic.query(
      admin: true
    ).then (statistics) ->
      $scope.stats = statistics

    Payment.query(
      admin: true
    ).then (payments) ->
      $scope.payments = payments



    $scope.group_selection = ['with_newsletter','confirmed']
    $scope.group_keys = ['','']

    new Mailing(
      groups: $scope.group_selection
      group_keys: $scope.group_keys
    ).create().then (response) ->
      $scope.m = response



    $scope.toggleGroupSelection = (group) ->
      idx = $scope.group_selection.indexOf(group)
      # is currently selected
      if idx > -1
        $scope.group_selection.splice idx, 1
        $scope.group_keys.splice idx, 1
      else
        $scope.group_selection.push group
        $scope.group_keys.push ""

      new Mailing(
        groups: $scope.group_selection
        group_keys: $scope.group_keys
      ).create().then (response) ->
        $scope.m = response

      return


    $scope.sendMail = (test = true)->
        if confirm('Sicher?')
          new Mailing(
            groups: $scope.group_selection
            group_keys: $scope.group_keys
            body: $scope.mail.body
            send: true
            test: test
            subject: $scope.mail.subject
          ).create().then (response) ->
            $scope.m = response

      return

    $scope.search_for_payment = ->
      Payment.query(
        admin: true
        q: $scope.pymnt.search
      ).then (payments) ->
        $scope.payments = payments


    $scope.search_for_user = ->
      console.log $scope.u.search
      email = $scope.u.search
      email = email.substring(email.lastIndexOf("<")+1,email.lastIndexOf(">")) if email.indexOf("<") > -1

      Registration.query(
        admin: true
        q: email
      ).then (users) ->
        $scope.users = users


    $scope.deletePayment = (payment) ->
      if confirm('wirklich löschen?')
        new Payment(
          id: payment.id
          admin: true
        ).delete()
        .then () ->
          $scope.payments.splice($scope.payments.indexOf(payment), 1)


    $scope.togglePayment = (payment) ->
      if confirm('wirklich?')
        new Payment(
          id: payment.id
          admin: true
          active: !payment.active
        ).update()
        .then () ->
          $scope.payments[$scope.payments.indexOf(payment)].active = !payment.active


    $scope.delete_user = (user) ->
      if confirm('wirklich?')
        new Registration(
          id: user.id
          admin: true
        ).delete()
        .then () ->
          $scope.users.splice($scope.users.indexOf(user), 1)


    $scope.confirm = (user) ->
      if confirm('wirklich?')
        new Registration(
          id: user.id
          admin: true
          confirm_user: true
        ).update()
        .then (response) ->
          $scope.users[$scope.users.indexOf(user)] = response
          body = """
          Hallo #{user.name},

          ich habe deine E-Mail-Adresse gerade freigeschaltet. Du kannst dich nun auf meinbge.de/login?email=#{user.email} damit einloggen.
          Am besten du lädst die Seite vorher neu.

          Liebe Grüße,

          Micha


          """
          link = "mailto:#{user.email}?" +
                 "subject=" + encodeURI("Deine E-Mail ist freigeschaltet") +
                 "&body=" + encodeURI(body)

          window.location.href = link


    $scope.enable_crowdcard = (user) ->
      if confirm('wirklich?')
        new Flag(
          for_user: user.id
          admin: true
          name: 'crowdcardNumber'
          value: 'pdf-' + user.id
        ).create()
        .then (response) ->
          user.flags.crowdcardNumber = 'pdf-' + user.id


    $scope.enable_crowdbar = (user) ->
      if confirm('wirklich?')
        new Flag(
          for_user: user.id
          admin: true
          value: true
          name: 'hasHadCrowdbar'
        ).create()
        .then (response) ->
          user.flags.hasHadCrowdbar = true



    $scope.reset_pw = (user) ->
      if confirm('wirklich?')
        new Registration(
          id: user.id
          admin: true
          reset_pw: true
        ).update()
        .then (response) ->
          $scope.users[$scope.users.indexOf(user)].pw = response.pw
          body = """
          Hallo #{user.name},

          ich habe dir ein neues Passwort erstellt, mit dem du dich nun auf meinbge.de/login?email=#{user.email} einloggen kannst.
          Am besten du lädst die Seite vorher neu.

          Das Passwort lautet:
          #{response.pw}

          Du kannst das Passwort wieder ändern indem du dich ausloggst, und auf meinbge.de/login?email=#{user.email} auf <Passwort vergessen> klickst. Du erhältst dann eine Mail mit der du dein Passwort ändern kannst.

          Liebe Grüße,

          Micha


          """
          link = "mailto:#{user.email}?" +
                 "subject=" + encodeURI("Dein neues Passwort") +
                 "&body=" + encodeURI(body)

          window.location.href = link

    $scope.changeStatus = (support) ->
      new Support(
        id: support.id
        payment_completed: !support.paymentCompleted
        comment: support.comment
        admin: true
      ).update()
      .then (response) ->
        $scope.supports[$scope.supports.indexOf(support)] = response


    $scope.sendCard = (crowdcard) ->
      new Crowdcard(
        id: crowdcard.id
        admin: true
      ).update()
      .then (response) ->
        $scope.crowdcards[$scope.crowdcards.indexOf(crowdcard)] = response
        #$scope.crowdcards.splice($scope.crowdcards.indexOf(crowdcard), 1)

]