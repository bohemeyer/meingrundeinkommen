class SupportSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :comment, :amount_total, :avatar, :payment_completed

  def avatar
  	u = User.find_by_email(object.email)
  	if u && u.avatar
	  return u.avatar
	else
	  return false
	 end
  end
end