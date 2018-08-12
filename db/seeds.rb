20.times do 
  user = {}
  user['password'] = '123456'
  user['email'] = Faker::Internet.free_email

  User.create(user)
end

50.times do
  message = {}
  message["user_id"] = rand(1..20)
  message["message"] = BetterLorem.p(2, true, true)
  message["category"] = rand(0..4)

  Message.create(message)
end

500.times do
  comment = {}
  comment["user_id"] = rand(1..20)
  comment["message_id"] = rand(1..100)
  comment["text"] = BetterLorem.w(50, true, true)

  Comment.create(comment)
end