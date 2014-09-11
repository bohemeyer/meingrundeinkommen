angular.module "Question", ['rails']
.factory "Question", [
  "railsResourceFactory"
  (rails) ->

    Question = rails(
      url: "/api/questions/{{id}}"
      name: "question"
    )

    return Question
]