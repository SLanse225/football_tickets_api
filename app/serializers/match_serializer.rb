class MatchSerializer < ActiveModel::Serializer
  attributes :id, :home_team_id, :away_team_id, :match_date, :stadium

  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
end
