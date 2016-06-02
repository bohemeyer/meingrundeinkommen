class Question < ActiveRecord::Base
  searchable :auto_index => false, :auto_remove => false do
    text :text
    text :answer
  end
end
