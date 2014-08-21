class StateUserSerializer < ActiveModel::Serializer
  attributes :id, :story, :text, :user_state_id

  def id
    object.state.id
  end

  def user_state_id
    object.id
  end

  def text
    object.state.text
  end

end
