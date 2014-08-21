require "rubygems"
require "google_drive"

namespace :data do
  desc "import data from google to database"
  task :import => :environment do

    session = GoogleDrive.login("", "")
    ws = session.spreadsheet_by_key("1Sx2WEuMECe7yy6Bmi5a37erXIXwDxbgIDpnN4MHhJeE").worksheets[0]

    for row in 1..ws.num_rows
      if !ws[row,2].empty?
        user_data = {
          name: ws[row,2],
          email: "user#{row}@mein-grundeinkommen.de",
          password: "lalalaldsgew",
          password_confirmation: "lalalaldsgew"
        }
        user = User.new(user_data)
        user.skip_confirmation!

        if user.save!
          ws[row,4].split(';').each do |w|
            if !w.empty? && w.length > 3 && w.length < 101
              w = w.strip
              wish = Wish.find(:first, :conditions => ["lower(text) = ?", w.downcase])
              wish = Wish.create(text:w) if !wish
              user_wish = user.user_wishes.where(wish:wish)
              user_wish = user.user_wishes.create wish:wish if user_wish.blank?
            end
          end
        end

      end
    end


  end
end