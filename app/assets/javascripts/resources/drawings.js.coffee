angular.module "Drawing", ["rails"]
.factory "Drawing", [
  "railsResourceFactory"
  (rails) ->

    Drawing = rails(
      url: "/api/drawings/{{id}}"
      name: "drawing"
    )

    return Drawing
]