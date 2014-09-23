class SupportSerializer < ActiveModel::Serializer
  attributes :id, :user, :firstname, :lastname, :amount, :amount_internal, :email, :company, :street, :zip, :city, :country, :payment_method, :comment, :anonymous, :recurring, :recurring_period, :string
end
