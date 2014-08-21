# App.factory "User", ["railsResourceFactory", (f) ->
#   f(
#     url: "/api/users"
#     name: "user"
#   )
# ]

App.factory "Home", ["railsResourceFactory", (f) ->
  f(
    url: "/api/homepages"
    name: "homepage"
  )
]