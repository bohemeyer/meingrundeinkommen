angular.module "Wish", ["rails"]
.factory "Wish", [
  "railsResourceFactory"
  (rails) ->

    Wish = rails(
      url: "/api/{{forUser}}wishes/{{id}}"
      name: "wish"
    )

    Wish.forUser = (user_id) ->
      Wish.query {},
        forUser: 'users/' + user_id + '/'

    Wish.users = (wish_id) ->
      Wish.query {},
        id: wish_id + '/users'

    Wish.stories = (wish_id) ->
      Wish.query {},
        id: wish_id + '/stories'

    Wish.users_also_wish = (wish_id) ->
      Wish.query {},
        id: wish_id + '/wishes'


    return Wish
]