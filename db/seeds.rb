5.times do
  Team.create(
    name: Faker::Sports::Football.team,
  )
end

5.times do
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
  )
end

5.times do
 Match.create(
    home_team_id: rand(1..5),
    away_team_id: rand(1..5),
    match_date: Faker::Date.forward(days: 23),
    stadium: Faker::Address.street_address,
  )
end

20.times do
  Ticket.create(
    match_id: rand(1..5),
    user_id: rand(1..5),
    price: rand(100..500),
  )
end
