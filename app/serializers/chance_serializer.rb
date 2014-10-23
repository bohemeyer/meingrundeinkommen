class ChanceSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :dob, :is_child, :country_id, :city, :confirmed_publication, :code, :code2

  def dob
  	object.dob.strftime('%d.%m.%Y')
  end

end
