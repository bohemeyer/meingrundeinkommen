angular.module "Setting", ["rails"]
.factory "Setting", [
  "railsResourceFactory"
  (rails) ->

    Setting = rails(
      url: "/api/settings"
      name: "setting"
    )
    return Setting
]