angular.module "State", ["rails"]
.factory "State", [
  "railsResourceFactory"
  (rails) ->

    State = rails(
      url: "/api/{{forUser}}state{{forStatesUser}}/{{id}}"
      name: "state"
    )

    State.forUser = (user_id) ->
      State.query {},
        forUser: 'users/' + user_id + '/'
        forStatesUser: 's'

    State.suggestions = (query) ->
      State.query
        q: query
      ,
        forStatesUser: 's'


    return State
]