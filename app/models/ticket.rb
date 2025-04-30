class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validates :user_id, presence: true
  validates :match_id, presence: true

  def self.ransackable_associations(auth_object = nil)
    [ "match", "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "created_at", "updated_at", "price", "seat_number", "match_id", "user_id" ]
  end
end
