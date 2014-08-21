class Wish < ActiveRecord::Base
  include ConjugationHelper
  has_many :user_wishes, :dependent => :destroy
  has_many :users, through: :user_wishes

  def conjugate
    [:me,:he,:they].inject({}) { |mem, var| mem[var] = conjugate_sentence(text, var); mem }
  end

end
