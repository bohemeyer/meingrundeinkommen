class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter, :chances

  def email
    if object == current_user
      object.email
    else
      ''
    end
  end

  def chances
    if object == current_user
      object.chances.order(:is_child => :asc)
    else
      []
    end
  end

  def newsletter
    if object == current_user
      object.newsletter
    else
      ''
    end
  end

end
