class CommentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :text, :name, :avatar, :user_id

  def avatar
    if object.user && !object.user.nil?
      return object.user.avatar.url
    else
      return object.static_avatar ? object.static_avatar : false
    end
  end

  def name
    if object.user && !object.user.nil?
      return object.user.name
    else
      return object.static_name ? object.static_name : false
    end
  end

end
