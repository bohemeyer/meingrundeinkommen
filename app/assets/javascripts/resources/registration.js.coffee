angular.module "Registration", ['rails']
.factory "Registration", [
  "railsResourceFactory"
  (rails) ->

    Registration = rails(
      url: "/users/{{id}}"
      name: "user"
    )

    return Registration
]