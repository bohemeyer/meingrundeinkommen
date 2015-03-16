class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter, :chances, :has_crowdbar, :wishes, :states, :crowdcards, :confirmed_at, :admin, :flags, :payment

  def email
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.email
    else
      ''
    end
  end

  def confirmed_at
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.confirmed_at
    else
      ''
    end
  end

  def has_crowdbar
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.has_crowdbar
    else
      ''
    end
  end

  def chances
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.chances.order(:is_child => :asc)
    else
      r = []
      object.chances.each do |c|
        r << c.slice(:code,:code2,:is_child,:crowdbar_verified)
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

  def admin
    if current_user && object == current_user && current_user.admin?
      true
    else
      false
    end
  end

  def crowdcards
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.crowdcards
    else
      ''
    end
  end

  def states
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.states
    else
      object.states.where('state_users.visibility' => true)
    end
  end

  def flags
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      r = {}
      object.flags.each do |flag|
        r[flag.name] = flag.display
      end
      r
    else
      ''
    end
  end

  def payment
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.payment
    else
      object.payment ? object.payment.active : false
    end
  end

end
