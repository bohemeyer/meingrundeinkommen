angular.module "Tandem", ["rails"]

.factory "Tandem", [
  "railsResourceFactory"
  (rails) ->

    Tandem = rails(
      url: "/api/tandems"
      name: "tandem"
    )

    return Tandem
]
.controller "TandemsController", [
  "$scope"
  "$modal"
  "Tandem"
  "User"
  "$q"
  "$cookies"
  ($scope, $modal, Tandem, User, $q, $cookies, anchorSmoothScroll) ->

    mail_re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i

    $scope.personallink = "www.mein-grundeinkommen.de/tandem?mitdir=#{$scope.current.user.id}"



    $scope.saveTandems = ->
      if $scope.current.participates() && $scope.current.user.tandems.length < 100
        tqueries = []
        angular.forEach $scope.current.user.tandems, (t) ->
          if !t.id
            tqueries.push new Tandem(t).create().then (tandem) ->
              $scope.current.user.tandems[$scope.current.user.tandems.indexOf(t)].id = tandem.tandem.id
          else
            if t.grudge
              tqueries.push new Tandem(
                id: t.id
                grudge: t.grudge
              ).update()

        $q.all(tqueries)
        true

    if $scope.current.inviter && parseInt($scope.current.inviter.id) != $scope.current.user.id

      if $scope.current.inviter.invitation_type == 'link'
        tnew =
          inviter_id: $scope.current.inviter.id
          invitee_id: $scope.current.user.id
          invitation_type: 'link'
          grudge: ''
          details:
            name: $scope.current.inviter.name
            avatar: $scope.current.inviter.avatar

      #if $scope.current.inviter.invitation_type == 'email'
      #TODO

      $scope.current.user.tandems.push(tnew)
      $scope.saveTandems()
      $scope.current.inviter = null


    $scope.tandeminviteform = {}
    $scope.tandeminviteform.name = ''
    $scope.tandeminviteform.email = ''
    $scope.tandeminviteform.purpose = ''
    $scope.tandeminviteform.reference = ''

    $scope.invite = false


    $scope.getTandem = (q) ->
      User.find(q).then (users) ->
        if mail_re.test(q)
          if q == $scope.current.user.email
            return [
              name: "Deine eigene Adresse kannst du nicht einladen"
              id: null
              avatar: null
              notpossible: true
            ]
          else
            if users.length == 0
              return [
                inviteemail: q
                name: "'#{q}' einladen"
                id: null
                avatar: null
              ]
        return users

    $scope.getRandomTandem = () ->
      User.random().then (user) ->
        $scope.chooseTandem(user,'random')


    $scope.openInviteModal = (email = false) ->
      InviteModal = $modal.open(
        templateUrl: "invitemodal.html"
        size: 'lg'
        controller: [
          "$scope"
          "tandeminviteform"
          "$modalInstance"
          ($scope,tandeminviteform,$modalInstance) ->
            $scope.tandeminviteform = tandeminviteform
            $scope.addRecipient = ->
              $scope.tandeminviteform.recipients.push
                email: ''
                name: ''
            $scope.removeRecipient = (r) ->
              $scope.tandeminviteform.recipients.splice($scope.tandeminviteform.recipients.indexOf(r), 1)
            $scope.inviteNow = ->
              $modalInstance.close($scope.tandeminviteform)
            $scope.encodemail = (txt) ->
              return encodeURI(txt)
        ]
        resolve:
          tandeminviteform: ->
            mailtext = "Hallo, \n\ndie Seite \"Mein Grundeinkommen\" will herausfinden, was mit Menschen passiert, wenn sie ein Bedingungsloses Grundeinkommen erhalten. Dazu verlosen sie regelmäßig an eine Person ein Grundeinkommen, das 1000 €  im Monat beträgt und ein Jahr lang ausgezahlt wird.\n\nFünfzehn Menschen erhalten das Geld schon.\nDieses Mal werden zwei Grundeinkommen an zwei Menschen verlost, die sich kennen.\nIch nehme selbst an der Verlosung teil und lade dich herzlich ein, mein_e Tandempartner_in zu sein. Du musst nichts weiter tun als diesem Link zu folgen und meine Tandem-Einladung zu bestätigen:\n\nhttps:\/\/www.mein-grundeinkommen.de\/tandem?mitdir=#{$scope.current.user.id} \n\nEs kostet nichts und im besten Fall erhalten wir beide ein Jahr lang Grundeinkommen.\n\nLiebe Grüße"
            subject = 'Grundeinkommen für dich und mich'
            if email
              r =
                mailtext: mailtext
                subject: subject
                recipients: [ {
                  email: email
                  name: ''
                } ]
            else
              r =
                mailtext: mailtext
                subject: subject
                recipients: [ {
                  email: ''
                  name: ''
                } ]
      )

      InviteModal.result.then (invites) ->
        angular.forEach invites.recipients, (invite) ->
          if mail_re.test(invite.email)
            t =
              invitee_email: invite.email
              invitee_name: invite.name
              invitee_email_text: invites.mailtext
              invitee_email_subject: invites.subject
              invitation_type: 'mail'
              inviter_id: $scope.current.user.id
              grudge: ''
              details:
                name: if invite.name and invite.name != '' then invite.name else invite.email

            $scope.current.user.tandems.push t

        $scope.saveTandems()



    $scope.chooseExisting = (model) ->
      if model.inviteemail
        $scope.openInviteModal(model.inviteemail)
        return true

      tandem =
        reference: $scope.tandeminviteform.reference
        invitee_id: $scope.tandeminviteform.reference.id
        inviter_id: $scope.current.user.id
        invitation_type: 'existing'
        grudge: ''
        details: model

      unless (model && model.notpossible)
        $scope.current.user.tandems.push(tandem)
        $scope.saveTandems()
        $scope.tandeminviteform.reference = ''



    # $scope.checkifblur = () ->
    #   if !tandem.reference.id
    #     if mail_re.test(tandem.reference) && tandem.reference != $scope.current.user.email
    #       $scope.chooseTandem(tandem, [
    #         email: tandem.reference
    #         name: tandem.reference
    #         id: null
    #         avatar: null
    #       ])
    #     if angular.isNumber(parseInt(tandem.reference))
    #       true
    #       #$scope.chooseTandem(tandem, $scope.current.getAffiliateDetails(tandem.reference) )


    $scope.grudge = (tandem) ->
      GrudgeModal = $modal.open(
        templateUrl: "grudgemodal.html"
        size: 'lg'
        controller: [
          "$scope"
          "tandem"
          "$modalInstance"
          ($scope,tandem,$modalInstance) ->
            $scope.tandem = tandem
            $scope.tandem.grudge = "" if !$scope.tandem.grudge
            $scope.saveGrudge = ->
              $modalInstance.close($scope.tandem)
        ]
        resolve:
          tandem: ->
            tandem
      )

      GrudgeModal.result.then (t) ->
        tandem.grudge = t.grudge
        $scope.saveTandems()


    $scope.removeTandem = (tandem) ->
      if confirm('Willst du wirklich von diesem Tandem absteigen?')
        if tandem.id
          new Tandem(
            id: tandem.id
          ).delete()

        if (tandem.inviter_id == $cookies["mitdir"] && tandem.inviter_id!= $scope.current.user) || (tandem.invitee_id == $cookies["mitdir"] && tandem.invitee_id!= $scope.current.user)
          $cookies["mitdir"] = null
        $scope.current.user.tandems.splice($scope.current.user.tandems.indexOf(tandem), 1)

]