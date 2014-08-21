angular.module "User", ['rails']
.factory "User", [
  "railsResourceFactory"
  (f) ->

    User = f(
      url: "/api/users"
      name: "user"
    )

    return User
]