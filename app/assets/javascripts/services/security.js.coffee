angular.module("grundeinkommen").factory "Security", [
  "$http"
  "$q"
  "$location"
  "Auth"
  "$cookies"
  "$window"
  ($http, $q, $location, Auth, $cookies, $window) ->

    # The public API of the service
    service =

      # Attempt to authenticate a user by the given email and password
      login: (credentials) ->
        Auth.login(credentials).then (response) ->
          service.currentUser = response unless response.error
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
        service.currentUser = null
        Auth.logout().then ((old_user) ->
          return
        ), (error) ->
          console.log erro

        return


      currentUser: null


      # Ask the backend to see if a user is already authenticated - this may be from a previous session.
      requestCurrentUser: ->
        Auth.currentUser().then ((user) ->
          service.currentUser = user unless user.error
          return
        ), (error) ->
          service.currentUser = false
          console.log error

      is_own_profile: (profile_id) ->
        if this.currentUser && this.currentUser.id == profile_id then true else false

      # Is the current user authenticated?
      isAuthenticated: ->
        !!service.currentUser


      # Is the current user an adminstrator?
      isAdmin: ->
        !!(service.currentUser and service.currentUser.admin)

    return service
]