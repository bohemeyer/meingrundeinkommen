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
  ($http, $q, $location, Auth, Flag, $cookies, $window, User) ->

    # The public API of the service
    service =

      # Attempt to authenticate a user by the given email and password
      login: (credentials) ->
        Auth.login(credentials).then (response) ->
          service.user = response unless response.error
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


      # Ask the backend to see if a user is already authenticated - this may be from a previous session.
      requestCurrentUser: ->
        Auth.currentUser().then ((user) ->
          service.user = user unless user.error
          return user
        ), (error) ->
          service.user = false
          console.log error

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

      getAffiliateDetails: (id) ->
        if service.user.chances && service.user.chances[0] && service.user.chances[0].affiliate
          User.query {},
            id: service.user.chances[0].affiliate
          .then (user) ->
            service.user.chances[0].affiliateDetails = user
        else
          Promise.resolve()

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