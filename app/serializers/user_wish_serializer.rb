class UserWishSerializer < ActiveModel::Serializer
  include ConjugationHelper
  include ActionView::Helpers::DateHelper

  attributes :id, :story, :text, :he_text, :user_wish_id, :user, :time_ago, :created_at

  def id
    object.wish.try(:id)
  end

  def user_wish_id
    object.id
  end

  def text
    object.wish.try(:text)
  end

  def user
    object.user.slice(:name,:id,:avatar) if object.user
  end

  def time_ago
    time_ago_in_words(object.created_at)
  end

  def he_text
    conjugate_sentence(self.text, :he)
  end

end
