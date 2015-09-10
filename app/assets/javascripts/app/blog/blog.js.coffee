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
      console.log(data)

      angular.forEach data, (post) ->
        if post.featured_image
          $http.get("http://blog.meinbge.de/wp-json/wp/v2/media/#{post.featured_image}").success (img) ->
            post.thumb = img.media_details.sizes['post-thumbnail'].source_url
            post.image = img.media_details.sizes.large.source_url

        if $routeParams['postId'] && parseInt(post.id) == parseInt($routeParams['postId'])
          $http.get("http://blog.meinbge.de/wp-json/wp/v2/users/#{post.author}").success (author) ->
            post.authorname = author.name
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