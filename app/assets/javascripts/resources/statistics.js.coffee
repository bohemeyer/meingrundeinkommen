angular.module "Statistic", ["rails"]
.factory "Statistic", [
  "railsResourceFactory"
  (rails) ->

    Statistic = rails(
      url: "/api/statistics/{{id}}"
      name: "statistic"
    )

    return Statistic
]