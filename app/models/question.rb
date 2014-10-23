class Question < ActiveRecord::Base
  searchable do
    text :text
    text :answer
  end
end
