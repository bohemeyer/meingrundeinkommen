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
  ($scope, $modal, Tandem, User, $q, $cookies) ->

    mail_re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i

    $scope.chances.tandems = $scope.current.user.tandems

    if $scope.current.inviter
      if $scope.current.inviter.invitation_type == 'link'
        tnew =
          inviter_id: $scope.current.inviter.id
          invitation_type: 'link'
          details:
            name: $scope.current.inviter.name
            avatar: $scope.current.inviter.avatar

      #if $scope.current.inviter.invitation_type == 'email'
      #TODO

      $scope.chances.tandems.push(tnew)
      $scope.current.inviter = null


    $scope.tandeminviteform = {}
    $scope.tandeminviteform.name = ''
    $scope.tandeminviteform.email = ''
    $scope.tandeminviteform.purpose = ''
    $scope.tandeminviteform.reference = ''

    # $scope.current.getAffiliateDetails().then ->

    #   if $cookies["bgemitdir"] && ($scope.current.user.chances.length == 0 || ($scope.current.user.chances[0] && $scope.current.user.chances[0].affiliate == null))
    #     $scope.affiliate = $cookies["bgemitdir"]
    #     User.query {},
    #       id: $cookies["bgemitdir"]
    #     .then (user) ->
    #       $scope.affiliateDetails = user

    $scope.invite = false

    $scope.confirmTandem = (tandem) ->
      new Tandem(
        id: tandem.id
        confirm: true
      ).update()

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
            return [
              dbemail: q
              name: q
              id: null
              avatar: null
            ]
        return users

    $scope.getRandomTandem = () ->
      User.random().then (user) ->
        $scope.chooseTandem(user,'random')



    $scope.chooseTandem = (model = false, type = false) ->
      tandem =
        name: $scope.tandeminviteform.name
        email: $scope.tandeminviteform.email
        purpose: $scope.tandeminviteform.purpose
        reference: $scope.tandeminviteform.reference
        invitee_id: $scope.tandeminviteform.reference
        invitation_type: if type then type else if model then 'existing' else 'mail'


      unless (model && model.notpossible)
        tandem.created = true if !model || !model.email
        tandem.invitee_id = model.id if model
        tandem.details = model if model
        tandem.is_invite = true if model && model.email
        tandem.is_invite = false if !model
        tandem.email = model.dbemail if model.dbemail
        if !model
          tandem.details =
            name: if tandem.name then tandem.name else tandem.email

        $scope.chances.tandems.push(tandem)
        $scope.tandeminviteform.name = ''
        $scope.tandeminviteform.email = ''
        $scope.tandeminviteform.purpose = ''
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




    $scope.removeTandem = (tandem) ->
      if confirm('Willst du wirklich von diesem Tandem absteigen?')
        if tandem.id
          new Tandem(
            id: tandem.id
          ).delete()
        console.log $scope.current.inviter
        console.log tandem.inviter_id

        if (tandem.inviter_id == $cookies["mitdir"] && tandem.inviter_id!= $scope.current.user) || (tandem.invitee_id == $cookies["mitdir"] && tandem.invitee_id!= $scope.current.user)
          $cookies["mitdir"] = null
        $scope.chances.tandems.splice($scope.chances.tandems.indexOf(tandem), 1)

]