class Payment < ActiveRecord::Base
    searchable do
      text :account_iban
      text :user_last_name
      text :user_first_name
      text :account_bic
      text :user_id
    end
	belongs_to :user
end
