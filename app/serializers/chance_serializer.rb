class ChanceSerializer < ActiveModel::Serializer
  attributes :id, :confirmed, :full_name, :dob, :is_child, :country_id, :city, :confirmed_publication, :code, :code2, :crowdcard_code

  def dob
  	object.dob.strftime('%d.%m.%Y')
  end

end
