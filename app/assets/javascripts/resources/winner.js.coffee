angular.module "Winner", ['rails']
.factory "Winner", [
  "railsResourceFactory"
  (rails) ->

    Winner = rails(
      url: "/api/winners"
      name: "winner"
    )
    return Winner
]