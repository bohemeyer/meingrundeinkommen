class Question < ActiveRecord::Base

	searchable do
    	text :text
  	end

end
