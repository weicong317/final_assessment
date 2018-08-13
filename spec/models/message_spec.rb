require 'rails_helper'

RSpec.describe Message, type: :model do

  context "validations" do

    describe "should have user id, message, category, upload, delete request" do
      it { should have_db_column(:user_id).of_type(:integer) }
      it { should have_db_column(:upload).of_type(:json) }
      it { should have_db_column(:message).of_type(:text) }
      it { should have_db_column(:category).of_type(:integer) }
      it { should have_db_column(:delete_request).of_type(:string) }
      it { should have_db_index(:user_id) }
    end

    describe "validates presence user id" do
      it { is_expected.to validate_presence_of(:user_id) }
    end

    describe "validates presence message" do
      it { is_expected.to validate_presence_of(:message) }
    end

    describe "validates presence category" do
      it { is_expected.to validate_presence_of(:category) }
    end

    describe "have enum for category" do
      it { should define_enum_for(:category).with([:family, :relationship, :study, :work, :others]) }
    end

  end

  context "associations" do

    describe "2 associations with dependency" do
      it { is_expected.to have_many(:comments).dependent(:destroy)}
      it { is_expected.to have_many(:reports).dependent(:destroy)}
    end

    describe "belong to user" do
      it { should belong_to(:user) }
    end
  
  end

  context "creations" do
    
    let(:user) { User.create(
      email: "testing@gmail.com", password: "123456", password_confirmation: "123456"
    )}

    # happy_path
    describe "created when all attributes except delete request are present" do
      When(:message) { Message.create(
        user_id: user.id,
        upload: "abc.jpg",
        message: "testingtestingtestingtestingtestingtesting",
        category: 2
      )}
      Then { message.valid? === true }
    end
    
    describe "can create without a upload" do
      When(:message) { Message.create(
        user_id: user.id,
        message: "testingtestingtestingtestingtestingtesting",
        category: 2
      )}
      Then { message.valid? === true }
    end

    # unhappy_path
    describe "cannot create without a user id" do
      When(:message) { Message.create(
        message: "testingtestingtestingtestingtestingtesting",
        category: 2
      )}
      Then { message.valid? === false }
    end

    describe "cannot create without a message" do
      When(:message) { Message.create(
        user_id: user.id,
        category: 2
      )}
      Then { message.valid? === false }
    end

    describe "cannot create without a category" do
      When(:message) { Message.create(
        user_id: user.id,
        message: "testingtestingtestingtestingtestingtesting"
      )}
      Then { message.valid? === false }
    end

  end

end