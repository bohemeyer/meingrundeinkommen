class WishSerializer < ActiveModel::Serializer
  include ConjugationHelper
  attributes :id, :text, :he_text, :they_text

  def he_text
    conjugate_sentence(object.text, :he)
  end

  def they_text
    conjugate_sentence(object.text, :they)
  end

end
