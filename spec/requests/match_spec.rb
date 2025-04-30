require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Matches API', type: :request do
  let!(:team1) { Team.create!(name: "Team One") }
  let!(:team2) { Team.create!(name: "Team Two") }
  let!(:team3) { Team.create!(name: "Team Three") }
  let!(:matches) do
    Array.new(5) { Match.create!(home_team: team1, away_team: team2, match_date: Time.zone.now, stadium: "Stadium #{_1}") }
  end
  let(:match_id) { matches.first.id }
  let(:valid_attributes) { { home_team_id: team1.id, away_team_id: team3.id, match_date: Time.zone.now + 1.day, stadium: 'Valid Stadium' } }
  let(:invalid_attributes) { { home_team_id: nil, away_team_id: team3.id } }

  path '/api/v1/matches' do
    get('list matches') do
      tags 'Matches'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   home_team_id: { type: :integer },
                   away_team_id: { type: :integer },
                   match_date: { type: :string, format: :date_time },
                   stadium: { type: :string },
                   created_at: { type: :string, format: :date_time },
                   updated_at: { type: :string, format: :date_time }
                 },
                 required: [ 'id', 'home_team_id', 'away_team_id' ]
               }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body).size).to eq(5)
        end
      end
    end

    post('create match') do
      tags 'Matches'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :match, in: :body, schema: {
        type: :object,
        properties: {
          match: {
            type: :object,
            properties: {
              home_team_id: { type: :integer },
              away_team_id: { type: :integer },
              match_date: { type: :string, format: :date_time },
              stadium: { type: :string }
            },
            required: [ 'home_team_id', 'away_team_id' ]
          }
        },
        required: [ :match ]
      }

      response(201, 'created') do
        let(:match) { { match: valid_attributes } }

        run_test! do |response|
           expect(response).to have_http_status(:created)
           expect(JSON.parse(response.body)['home_team_id']).to eq(valid_attributes[:home_team_id])
           expect(JSON.parse(response.body)['away_team_id']).to eq(valid_attributes[:away_team_id])
           expect(JSON.parse(response.body)['stadium']).to eq(valid_attributes[:stadium])
        end
      end

      response(422, 'unprocessable entity') do
        let(:match) { { match: invalid_attributes } }

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  path '/api/v1/matches/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show match') do
      tags 'Matches'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { match_id }
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 home_team_id: { type: :integer },
                 away_team_id: { type: :integer },
                 match_date: { type: :string, format: :date_time },
                 stadium: { type: :string },
                 created_at: { type: :string, format: :date_time },
                 updated_at: { type: :string, format: :date_time }
               },
               required: [ 'id', 'home_team_id', 'away_team_id' ]

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(match_id)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test! do |response|
           expect(response).to have_http_status(:not_found)
        end
      end
    end

    patch('update match') do
      tags 'Matches'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id'
      parameter name: :match, in: :body, schema: {
        type: :object,
        properties: {
          match: {
            type: :object,
            properties: {
              stadium: { type: :string }
            }
          }
        },
        required: [ :match ]
      }

      let(:update_attributes) { { stadium: 'Updated Stadium Via Patch' } }

      response(200, 'successful') do
        let(:id) { match_id }
        let(:match) { { match: update_attributes } }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          body = JSON.parse(response.body)
          expect(body['stadium']).to eq(update_attributes[:stadium])
          expect(Match.find(match_id).stadium).to eq(update_attributes[:stadium])
        end
      end

       response(422, 'unprocessable entity') do
         let(:id) { match_id }
         let(:match) { { match: invalid_attributes } }

         run_test! do |response|
           expect(response).to have_http_status(:unprocessable_entity)
         end
       end

       response(404, 'not found') do
         let(:id) { 'invalid-id' }
         let(:match) { { match: { stadium: 'Does not matter' } } }
         run_test! do |response|
           expect(response).to have_http_status(:not_found)
         end
       end
    end

    put('update match') do
      tags 'Matches'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id'
      parameter name: :match, in: :body, schema: {
        type: :object,
        properties: {
          match: {
            type: :object,
            properties: {
              home_team_id: { type: :integer },
              away_team_id: { type: :integer },
              match_date: { type: :string, format: :date_time },
              stadium: { type: :string }
            },
            required: [ 'home_team_id', 'away_team_id' ]
          }
        },
        required: [ :match ]
      }

      let(:put_attributes) { { home_team_id: team2.id, away_team_id: team3.id, stadium: 'Put Stadium Update' } }

      response(200, 'successful') do
        let(:id) { match_id }
        let(:match) { { match: put_attributes } }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          body = JSON.parse(response.body)
          expect(body['stadium']).to eq(put_attributes[:stadium])
          expect(body['home_team_id']).to eq(put_attributes[:home_team_id])
          expect(body['away_team_id']).to eq(put_attributes[:away_team_id])
          db_match = Match.find(match_id)
          expect(db_match.stadium).to eq(put_attributes[:stadium])
          expect(db_match.home_team_id).to eq(put_attributes[:home_team_id])
          expect(db_match.away_team_id).to eq(put_attributes[:away_team_id])
        end
      end

      response(422, 'unprocessable entity') do
        let(:id) { match_id }
        let(:match) { { match: invalid_attributes } }

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        let(:match) { { match: valid_attributes } }
        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    delete('delete match') do
      tags 'Matches'
      parameter name: :id, in: :path, type: :string, description: 'id'

      response(204, 'no content') do
        let(:id) { match_id }

        run_test! do |response|
          expect(response).to have_http_status(:no_content)
          expect { Match.find(match_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
