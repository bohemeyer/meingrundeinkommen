angular.module "Chance", ["rails"]
.factory "Chance", [
  "railsResourceFactory"
  (rails) ->

    Chance = rails(
      url: "/api/chances/{{id}}"
      name: "state"
    )

    return Chance
]