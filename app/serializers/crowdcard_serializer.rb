class CrowdcardSerializer < ActiveModel::Serializer
  attributes :id, :user, :first_name, :last_name, :street, :house_number, :zip_code, :city, :number_of_cards, :sent

end
