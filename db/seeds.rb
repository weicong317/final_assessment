100.times do
  Message.create(user_id: 1, message: BetterLorem.p(2, true, true))
end