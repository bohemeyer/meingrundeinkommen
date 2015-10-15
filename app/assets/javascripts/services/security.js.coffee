angular.module "Security", ["Devise","Flag"]
.factory "Security", [
  "$http"
  "$q"
  "$location"
  "Auth"
  "Flag"
  "$cookies"
  "$window"
  "User"
  "Tandem"
  ($http, $q, $location, Auth, Flag, $cookies, $window, User, Tandem) ->

    # The public API of the service
    service =

      # Attempt to authenticate a user by the given email and password
      login: (credentials) ->
        Auth.login(credentials).then (response) ->
          service.user = response unless response.error
          if service.inviter
            service.confirmTandem()
          return response
        , (error) ->
          return error.data

      register: (credentials) ->
        Auth.register(credentials).then ((registeredUser) ->
          return registeredUser
        ), (error) ->
          return error.data


      # Logout the current user and redirect
      logout: () ->
        service.user = null
        Auth.logout().then ((old_user) ->
          return
        ), (error) ->
          console.log erro

        return


      user: null

      subscribed: false


      # Ask the backend to see if a user is already authenticated - this may be from a previous session.
      requestCurrentUser: ->
        Auth.currentUser().then ((user) ->
          service.user = user unless user.error
          return user
        ), (error) ->
          service.user = false
          console.log error


      setNewsletterFlag: ->
        $http.put("/users.json",
          user:
            newsletter: true
        )
        service.user.newsletter = true
        service.subscribed = true

      is_own_profile: (profile_id) ->
        if this.user && this.user.id == profile_id then true else false

      is_default_avatar: ->
        if service.user.avatar.avatar.url == '/assets/team/team-member.jpg' then true else false

      # Is the current user authenticated?
      isAuthenticated: ->
        !!service.user


      isSquirrel: ->
        if service.user.payment && service.user.payment.active
          return true
        else
          return false

      isPausedSquirrel: ->
        if service.user.payment && !service.user.payment.active
          return true
        else
          return false

      hasCode: ->
        if service.user.chances.length == 0
          false
        else
          found = false
          angular.forEach service.user.chances, (chance) ->
            if chance.id && chance.code
              found = true
          return found

      participates: ->
        if service.user.chances.length == 0
          false
        else
          found = false
          angular.forEach service.user.chances, (chance) ->
            if chance.id && chance.confirmed
              found = true
          return found

      participation_verified: ->
        if service.participates() and
        (service.getFlag('hasHadCrowdbar') or
        service.has_crowdbar() or

        #service.has_crowdcard() or
        service.has_ordered_crowdcard() or

        service.has_crowdapp())

          true
        else
          false

      getInviterDetails: (id) ->
        User.query {},
          id: id
        .then (user) ->
          return user

      confirmTandem: ->

        if parseInt(service.inviter.id)==service.user.id
          alert 'Nur gemeinsam ist man stark! Du kannst kein Tandem mit dir selbst bilden.'
          return false

        if service.user.tandems.length > 99
          alert('Du kannst kein weiteres Tandem bilden, weil du bereits 100 Tandems hast. Bitte lösche erst eines deiner Tandems um dieses hier bilden zu können.')
          $location.path("/menschen/#{service.user.id}").search('gewinnspiel',true)
        else
          if service.inviter.number_of_tandems > 99
            alert("Du kannst dieses Tandem nicht bilden, weil #{service.inviter.name} bereits 100 Tandems hat. Du kannst natürlich trotzdem teilnehmen.")
            $location.path("/menschen/#{service.user.id}").search('gewinnspiel',true)
          else

            if service.participates()
              tnew =
                invitee_id: service.user.id
                inviter_id: service.inviter.id
                invitation_type: service.inviter.invitation_type
                grudge: ""
                details:
                  name: service.inviter.name
                  avatar: service.inviter.avatar
              new Tandem(tnew).create().then (tandems) ->
                tnew.id = tandems.id
                service.user.tandems.push tnew
                $cookies["mitdir"] = null
                alert("Du und #{service.inviter.name} bildet jetzt ein Tandem! Gute Fahrt!")
                service.inviter = null if service.inviter
                $location.path("/menschen/#{service.user.id}").search('gewinnspiel',true).search('mitdir', null)

            else
              $location.path("/boarding").search('trigger','wants_to_participate')


      has_crowdbar: ->
        service.getFlag('hasCrowdbar')

      has_crowdapp: ->
        service.getFlag('crowdAppVisits')

      has_crowdcard: ->
        service.getFlag('crowdcardNumber')


      has_ordered_crowdcard: ->
        return false if service.user.crowdcards.length == 0
        return true  if service.user.crowdcards.length > 0

      has_received_crowdcard_letter: ->
        if service.has_ordered_crowdcard()
          if service.user.crowdcards[0].sent then true else false

      setFlag: (name, value) ->
        if service.isAuthenticated()
          service.user.flags[name] = value
          new Flag(
            name: name
            value: value
          ).create()


      incFlag: (name) ->
        if service.isAuthenticated()
          new Flag(
            id: 1
            name: name
            increment: true
          ).update().then (flag) ->
            if service.user.flags[name]
              service.user.flags[name] = flag.value
            else
              service.user.flags[name] = 1

      getFlag: (name) ->
        if service.isAuthenticated()
          if service.user.flags[name] then service.user.flags[name] else false

      # Is the current user an adminstrator?
      isAdmin: ->
        !!(service.user and service.user.admin)

    return service
]