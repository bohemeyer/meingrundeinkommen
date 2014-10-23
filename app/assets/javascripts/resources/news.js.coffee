# angular.module "News", []
# .factory "News", [
#   "$http"
#   ($http) ->

#     News = []

#     News.get_all = () ->
#       all_news = []
#       $http.get("https://api.startnext.de/v1.1/projects/15645/updates?client_id=82142814552425").success (data, status, headers, config) ->
#         all_news = data
#       	return all_news


#     return News
# ]
