angular.module "Security", ["Devise","Flag"]
.factory "Security", [
  "$http"
  "$q"
  "$location"
  "Auth"
  "Flag"
  "$cookies"
  "$window"
  ($http, $q, $location, Auth, Flag, $cookies, $window) ->

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

      setFlag: (name, value) ->
        if service.isAuthenticated
          new Flag(
            name: name
            value: value
          ).create().then (flag) ->
            if service.user.flags
              service.user.flags[name] = value

      incFlag: (name) ->
        if service.isAuthenticated
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
        if service.isAuthenticated
          #todo: get all flags from server
          # Flag.query().then (flags) ->
          #   service.user.flags = flags
          if service.user.flags[name] then service.user.flags[name] else false

      # Is the current user an adminstrator?
      isAdmin: ->
        !!(service.user and service.user.admin)

    return service
]