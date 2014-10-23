class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter, :chances, :has_crowdbar

  def email
    if object == current_user
      object.email
    else
      ''
    end
  end

  def has_crowdbar
    if object == current_user
      object.has_crowdbar
    else
      ''
    end
  end

  def chances
    if object == current_user
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
