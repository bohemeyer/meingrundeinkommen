angular.module "Comment", ['rails']
.factory "Comment", [
  "railsResourceFactory"
  (rails) ->

    Comment = rails(
      url: "/api/comments"
      name: "comment"
    )

    return Comment
]