require 'rails_helper'

describe "post_message_feature", type: :feature do
  
  let(:user) {User.create(email: "testing@gmail.com", password: "123456", password_confirmation: "123456")}

  describe "log in" do

    # happy_path
    it "user log in success" do
      visit root_path
      click_link('Sign In')
      expect(page).to have_button('Sign In')
      fill_in("sign_in_email", with: user.email)
      fill_in("sign_in_password", with: user.password)
      click_button('Sign In')
      expect(current_path).to eql(user_path(user.id))
    end

    # unhappy_path
    it "user log in without password" do
      visit root_path
      click_link('Sign In')
      expect(page).to have_button('Sign In')
      fill_in("sign_in_email", with: user.email)
      click_button('Sign In')
      expect(current_path).to eql(new_session_path)
    end

    it "user log in without email" do
      visit root_path
      click_link('Sign In')
      expect(page).to have_button('Sign In')
      fill_in("sign_in_password", with: user.password)
      click_button('Sign In')
      expect(current_path).to eql(new_session_path)
    end

  end

  describe "post new message" do

    # happy_path
    it "post new meesage success" do
      visit root_path
      click_link('Sign In')
      fill_in("sign_in_email", with: user.email)
      fill_in("sign_in_password", with: user.password)
      click_button('Sign In')
      expect(page).to have_button('Post new message')
      click_button('Post new message')
      expect(current_path).to eql(new_message_path)
      expect(page).to have_field("new_message_message", type: "textarea")
      expect(page).to have_field("new_message_upload", type: "file")
      expect(page).to have_select("new_message_category", selected: "Others")
      expect(page).to have_select("new_message_category", options: ['Family', 'Relationship', 'Study', 'Work', 'Others'])
      expect(page).to have_button('Post')
      fill_in("new_message_message", with: "hello i am testing")
      click_button('Post')
      message = Message.last
      expect(current_path).to eql(message_path(message.id))
      expect(page).to have_button('Delete Message')
      expect(page).to have_content("Message #{message.id}")
      expect(page).to have_content("hello i am testing")
    end

    # unhappy_path
    it "post new meesage success" do
      visit root_path
      click_link('Sign In')
      fill_in("sign_in_email", with: user.email)
      fill_in("sign_in_password", with: user.password)
      click_button('Sign In')
      click_button('Post new message')
      click_button('Post')
      expect(current_path).to eql(messages_path)
    end
  
  end

end