class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter

  def email
    if object == current_user
      object.email
    else
      ''
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
