angular.module("faq", ["Question",'ng-breadcrumbs'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/info/faq",
      redirectTo: "/faq/projekt"
    .when "/faq",
      redirectTo: "/faq/projekt"
    .when "/faq/:topic",
      templateUrl: "/assets/faq.html"
      controller: "FAQController"
      label: "Häufige Fragen"

]

.filter "unsafe", ($sce) ->
  (val) ->
    $sce.trustAsHtml val


.controller "FAQController", [
  "$scope"
  "Question"
  "$cookieStore"
  "$sce"
  "$routeParams"

  ($scope, Question, $cookieStore, $sce, $routeParams) ->

    $scope.categories =
      projekt: true
      grundeinkommen: false
      crowdfunding: false
      crowdbar: false
      crowdcard: false
      community: false
      verlosung: false
      person: false
      winners: false

    if $routeParams['topic']
      $scope.categories[$routeParams['topic']] = true
      $scope.current_tab = $routeParams['topic']
    else
      $scope.current_tab = 'projekt'

    $scope.question = {}

    Question.query().then (questions) ->
      $scope.questions = questions

    $scope.delete = (q) ->
      new Question(
        id: q.id
      ).delete().then ->
        $scope.questions.splice($scope.questions.indexOf(q), 1)

    $scope.answer = (q) ->
      new Question(
        id: q.id
        answer: q.answer
        category: q.category
        text: q.text
        votes: q.votes
      ).update().then (response) ->
        $scope.questions[$scope.questions.indexOf(q)] = response


    $scope.tab = (tab) ->
      $scope.current_tab = tab
      $scope.question.$ = ''

    $scope.up = (q) ->
      if !$scope.has_been_voted_for(q.id)
        new Question(
          id: q.id
          up: true
        ).update().then (response) ->
          $scope.questions[$scope.questions.indexOf(q)] = response
          $scope.setVoted q

    $scope.setVoted = (q) ->
      $cookieStore.put('voted_for', []) if !$cookieStore.get('voted_for')
      array = $cookieStore.get('voted_for')
      array.push(q.id)
      $cookieStore.put('voted_for', array)

    $scope.has_been_voted_for = (id) ->
      if $cookieStore.get('voted_for')
        array = $cookieStore.get('voted_for')
        array.indexOf(id) > -1

    $scope.askQuestion = ->
      new Question(
        text: $scope.question.$
        category: $scope.current_tab
      ).create().then (response) ->
        $scope.questions.push response
        $scope.setVoted response
]

.filter "search", ($filter, Question) ->
  (items, text) ->
    return items  if not text or text.length is 0

    # split search text on space
    searchTerms = text.split(" ")

    # search for single terms.
    # this reduces the item list step by step

    searchTerms.forEach (term) ->
      test = $filter("filter")(items, term)  if term and term.length
      if test.length > 0
        items = test
      return

    #if items.length is 0
    # Question.query(
    #   q: text
    # ).then (questions) ->
    #   angular.forEach questions, (q) ->
    #     items = $filter("filter")(items, q.text)
    #   debugger
    items
