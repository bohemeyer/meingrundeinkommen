class UserWishSerializer < ActiveModel::Serializer
  include ConjugationHelper
  attributes :id, :story, :text, :he_text, :user_wish_id, :user_name, :created_at

  def id
    object.wish.try(:id)
  end

  def user_wish_id
    object.id
  end

  def text
    object.wish.try(:text)
  end

  def user_name
    object.user.try(:name)
  end

  def he_text
    conjugate_sentence(self.text, :he)
  end

end
