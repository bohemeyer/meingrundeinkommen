angular.module "Flag", ["rails"]
.factory "Flag", [
  "railsResourceFactory"
  (rails) ->

    Flag = rails(
      url: "/api/flags/{{id}}"
      name: "flag"
    )

    return Flag
]