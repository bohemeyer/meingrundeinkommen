angular.module "Session", ["Flag"]
.factory "Session", [
  "$auth"
  "Flag"
  ($auth, Flag) ->

    service =
      user: null

      setCurrentUser: (data) ->
        service.user = data

      logoutUser: ->
        service.user = null

      is_own_profile: (profile_id) ->
        if service.isAuthenticated && service.user.id == profile_id then true else false

      is_default_avatar: ->
        if service.user.avatar.avatar.url == '/assets/team/team-member.jpg' then true else false

      isAuthenticated: ->
        !!service.user

      setFlag: (name, value) ->
        if service.isAuthenticated
          new Flag(
            name: name
            value: value
          ).create().then (flag) ->
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

      isAdmin: ->
        !!(service.isAuthenticated and service.user.admin)

    return service
]