angular.module "User", ['rails']
.factory "User", [
  "railsResourceFactory"
  (rails) ->

    User = rails(
      url: "/api/users/{{id}}/{{method}}"
      name: "user"
    )


    User.suggestions = (user_id) ->
      User.query {},
        method: 'suggestions'
        id: user_id

    return User
]