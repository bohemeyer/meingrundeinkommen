angular.module("admin", ["Support", "Registration", "Statistic"])
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

  ($scope, Support, Registration, Crowdcard, Statistic) ->

    $scope.u = {}
    $scope.u.search = ''

    Support.query(
      admin: true
    ).then (supports) ->
      $scope.supports = supports

    Crowdcard.query(
      admin: true
    ).then (crowdcards) ->
      $scope.crowdcards = crowdcards

    Statistic.query(
      admin: true
    ).then (statistics) ->
      $scope.stats = statistics




    $scope.search_for_user = ->
      console.log $scope.u.search
      email = $scope.u.search
      email = email.substring(email.lastIndexOf("<")+1,email.lastIndexOf(">")) if email.indexOf("<") > -1

      Registration.query(
        admin: true
        q: email
      ).then (users) ->
        $scope.users = users


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


    $scope.enable_crowdbar = (user) ->
      if confirm('wirklich?')
        new Registration(
          id: user.id
          admin: true
          enable_crowdbar: true
        ).update()
        .then (response) ->
          user.flags.hasCrowdbar = true

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