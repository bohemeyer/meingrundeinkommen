angular.module "Support", ["rails"]
.factory "Support", [
  "railsResourceFactory"
  (rails) ->

    Support = rails(
      url: "/api/supports/{{id}}"
      name: "support"
    )

    return Support
]