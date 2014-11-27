require "rubygems"
require 'open-uri'
require 'json'
require 'date'

namespace :comments do
  task :getFromStartnext => :environment do
    desc "get all blog post comments from startnext"

    wp_startnext = {
      10 => 40389,
      13 => 39700,
      16 => 39212,
      19 => 38197,
      23 => 37440,
      27 => 37307,
      30 => 37167,
      33 => 37022
    }

    wp_startnext.each do |wp,startnext|
      post_comments = JSON.parse(open("https://api.startnext.de/v1.1/projects/updates/#{startnext}/comments?client_id=82142814552425").read)
      post_comments["comments"].each do |comment|
        if comment["author"]["image"]
          image = comment["author"]["image"].length > 0 ? comment["author"]["image"].last : comment["author"]["image"]
        else
          image = false
        end
        Comment.create(
          :text => comment["text"],
          :commentable_type => 'blogpost',
          :commentable_id => wp,
          :static_name => comment["author"]["name"],
          :static_avatar => image ? image["url"] : false,
          :created_at => DateTime.strptime(comment["created"].to_s,'%s')
        )
      end
    end





  end
end