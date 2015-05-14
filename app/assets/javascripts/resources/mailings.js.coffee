angular.module "Mailing", ['rails']
.factory "Mailing", [
  "railsResourceFactory"
  (rails) ->

    Mailing = rails(
      url: "/api/mailings"
      name: "mailing"
    )

    return Mailing
]