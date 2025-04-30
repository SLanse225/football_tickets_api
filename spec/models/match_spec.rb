require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'associations' do
    it { should belong_to(:home_team).class_name('Team').with_foreign_key('home_team_id') }
    it { should belong_to(:away_team).class_name('Team').with_foreign_key('away_team_id') }
    it { should have_many(:tickets).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:home_team) }
    it { should validate_presence_of(:away_team) }
  end
end
