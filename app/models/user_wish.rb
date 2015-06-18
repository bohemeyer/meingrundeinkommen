class UserWish < ActiveRecord::Base
  #include TweetWishConcern
  belongs_to :wish
  belongs_to :user
end
