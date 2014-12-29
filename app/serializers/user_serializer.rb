class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter, :chances, :has_crowdbar, :wishes, :states, :crowdcards, :confirmed_at, :admin, :flags

  def email
    if (scope && object == scope) || (scope && scope.admin?)
      object.confirmed_at
      object.email
    else
      ''
    end
  end

  def confirmed_at
    if (scope && object == scope) || (scope && scope.admin?)
      object.confirmed_at
    else
      ''
    end
  end

  def has_crowdbar
    if (scope && object == scope) || (scope && scope.admin?)
      object.has_crowdbar
    else
      ''
    end
  end

  def chances
    if (scope && object == scope) || (scope && scope.admin?)
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
    if object == scope
      object.newsletter
    else
      ''
    end
  end

  def admin
    if scope && object == scope && scope.admin?
      true
    else
      false
    end
  end

  def crowdcards
    if (scope && object == scope) || (scope && scope.admin?)
      object.crowdcards
    else
      ''
    end
  end

  def states
    # if (scope && object == scope) || (scope && scope.admin?)
    #   object.states
    # else
    #   object.states
    # end
  end

  def flags
    if (scope && object == scope) || (scope && scope.admin?)
      r = {}
      object.flags.each do |flag|
        r[flag.name] = flag.display
      end
      r
    else
      ''
    end
  end

end
