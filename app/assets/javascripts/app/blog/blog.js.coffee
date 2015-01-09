angular.module("blog", ['ng-breadcrumbs','Comment'])
.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when "/blog",
      templateUrl: "/assets/blog.html"
      controller: "BlogController"
      label: "Blog"
    .when "/blog/:postId",
      templateUrl: "/assets/blogpost.html"
      controller: "BlogController"
      label: "Blog"

]
.filter "unsafe", ($sce) ->
  (val) ->
    $sce.trustAsHtml val
.controller "BlogController", [
  "$scope"
  "$http"
  "$routeParams"
  "Comment"
  "Security"
  ($scope, $http, $routeParams, Comment, Security) ->
    $scope.comments = []
    $scope.new_comment = ""
    query = {}
    url = "/news.json"
    #url += "?" + serializeQuery(query)  if serializeQuery(query)
    $http.get(url).success (data) ->
      $scope.posts = data

      if $routeParams['postId']
        angular.forEach data, (post) ->
          if parseInt(post.ID) == parseInt($routeParams['postId'])
            $scope.post = post
          return
      return


    if $routeParams['postId']
      Comment.query(
        post_id: $routeParams['postId']
      ).then (comments) ->
        $scope.comments = comments
        $scope.add_commentable()


    $scope.add_comment = () ->
      new Comment(
        post_id: $routeParams['postId']
        text: $scope.comments[0].text
      ).create().then (c) ->
        $scope.comments.shift()
        $scope.comments.unshift(c)
        $scope.add_commentable()

    $scope.add_commentable = () ->
      if $scope.current.user
        $scope.comments.unshift
          createdAt: Date.new
          name: $scope.current.user.name
          avatar: $scope.current.user.avatar.avatar.url
          blank: true
          text: ""


    # serializeQuery = (obj) ->
    #   str = []
    #   for p of obj
    #     str.push encodeURIComponent("filter[" + p + "]") + "=" + encodeURIComponent(obj[p])  if obj.hasOwnProperty(p)
    #   str.join "&"

]