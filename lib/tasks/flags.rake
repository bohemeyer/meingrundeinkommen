require "rubygems"

namespace :flags do
  task :migrate => :environment do
    desc "copy user flags from user model to flags model"


    User.all.each do |user|
      user.flags.create(:name => 'hasCrowdbar', :value_boolean => user.has_crowdbar)
      user.flags.create(:name => 'crowdbarNotFoundAfterInstall', :value_boolean => user.crowdbar_not_found) if user.crowdbar_not_found
    end
  end
end