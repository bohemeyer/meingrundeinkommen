class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter, :chances, :has_crowdbar, :confirmed_at

  def email
    if (current_user && object == current_user) || (current_user && current_user.id == 1)
      object.email
    else
      ''
    end
  end

  def confirmed_at
    if (current_user && object == current_user) || (current_user && current_user.id == 1)
      object.confirmed_at
    else
      ''
    end
  end

  def has_crowdbar
    if (current_user && object == current_user) || (current_user && current_user.id == 1)
      object.has_crowdbar
    else
      ''
    end
  end

  def chances
    if (current_user && object == current_user) || (current_user && current_user.id == 1)
      object.chances.order(:is_child => :asc)
    else
      r = []
      object.chances.each do |c|
        r << c.slice(:code,:code2,:is_child)
      end
      r
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
