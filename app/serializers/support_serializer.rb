class SupportSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :comment, :amount_total, :avatar, :payment_completed, :user

  def avatar
  	u = User.find_by_email(object.email)
  	if u && u.avatar
	  return u.avatar
	else
	  return false
	 end
  end

  def user
  	if object.user
  	  object.user.slice(:name, :avatar, :id)
  	else
  	  return false
  	end
  end

end