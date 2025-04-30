class TicketSerializer < ActiveModel::Serializer
  attributes :id, :price

  belongs_to :match
end
