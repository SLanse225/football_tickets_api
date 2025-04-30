class Match < ApplicationRecord
  belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id"

  has_many :tickets, dependent: :destroy

  validates :home_team, presence: true
  validates :away_team, presence: true

  # Allow searching/filtering by these associations in ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    [ "away_team", "home_team", "tickets" ]
  end

  # Allow searching/filtering by these attributes in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    # List attributes you want to allow searching on
    [ "id", "home_team_id", "away_team_id", "match_date", "stadium", "created_at", "updated_at" ]
    # Exclude sensitive attributes if any
  end
end
