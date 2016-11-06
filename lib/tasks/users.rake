require 'rubygems'
require 'digest/sha1'
      
namespace :users do
  task generateHash: :environment do
    desc 'set invidual hashes for users based on their mail address'
    
      all_users = User.where(initial_wishes: [nil, ''])
      all_users.each_with_index do |user,i|
        hash = Digest::SHA1.hexdigest user.email + user.encrypted_password[0..5]
        user.update_attribute(:initial_wishes, hash)
        puts "generated hash for user #{i} of #{all_users.count}"
      end
    
  end
end
