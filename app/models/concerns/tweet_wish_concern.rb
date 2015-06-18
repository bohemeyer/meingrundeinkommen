module TweetWishConcern
  extend ActiveSupport::Concern

  require 'net/http'
  require 'uri'


  included do
    after_create :tweetWishText
  end

  def tweetWishText

    uri = URI.parse("http://localhost:5000/tweet")

    text = self.user.name + ' würde mit Grundeinkommen ' + self.text

    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({'text' => text, 'hashtag' => 'bge', 'url' => self.wish_url})
    request.basic_auth('foo', 'bar')

    response = http.request(request)

  end


end