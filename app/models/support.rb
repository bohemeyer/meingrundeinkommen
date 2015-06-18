class Support < ActiveRecord::Base
  include TweetSupportConcern

  belongs_to :user

end
