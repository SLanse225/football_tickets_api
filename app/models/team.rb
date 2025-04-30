class Team < ApplicationRecord
  has_many :home_matches, class_name: "Match", foreign_key: "home_team_id", dependent: :restrict_with_error
  has_many :away_matches, class_name: "Match", foreign_key: "away_team_id", dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
