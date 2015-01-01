require "rubygems"

namespace :users do
  task :update => :environment do
    desc "migrate user data for new auth method"

    User.all.each do |user|
      user.update_attributes(:provider => 'email', :uid => user.email)
    end

  end
end