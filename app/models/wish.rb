class Wish < ActiveRecord::Base
  searchable do
    text :text, :more_like_this => true
  end

  include ConjugationHelper
  has_many :user_wishes, :dependent => :destroy
  has_many :users, through: :user_wishes

  validates_uniqueness_of :text, :case_sensitive => false

  def conjugate
    [:me,:he,:they].inject({}) { |mem, var| mem[var] = conjugate_sentence(text, var); mem }
  end

end
