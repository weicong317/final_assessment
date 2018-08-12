require 'rails_helper'

RSpec.describe User, type: :model do

  context "validations" do

    describe "should have email and password_digest and role" do
      it { should have_db_column(:email).of_type(:string) }
      it { should have_db_column(:password_digest).of_type(:string) }
      it { should have_db_column(:role).of_type(:integer).with_options(:default => "user") }
    end

    describe "has_secure_password" do
      it { should have_secure_password }
    end

    describe "validates presence, uniqueness and format of email" do
      it { is_expected.to validate_presence_of(:email).on(:create) }
      it { is_expected.to validate_uniqueness_of(:email).on(:create) }
      it { should allow_value('abc@abc.com').for(:email).with_message("Email is invalid") }
      it { should allow_value('abc.123@abc.com').for(:email).with_message("Email is invalid") }
      it { should allow_value('abc_123@abc.com').for(:email).with_message("Email is invalid") }
      it { should allow_value('abc123@abc.com').for(:email).with_message("Email is invalid") }
      it { should allow_value('abc@abc.com.my').for(:email).with_message("Email is invalid") }
      it { should allow_value('abc@abc.net').for(:email).with_message("Email is invalid") }
      it { should_not allow_value('abcabccom').for(:email).with_message("Email is invalid") }
      it { should_not allow_value('abc@abccom').for(:email).with_message("Email is invalid") }
      it { should_not allow_value('abcabc.com').for(:email).with_message("Email is invalid") }
    end

    describe "validates password" do
      it { is_expected.to validate_presence_of(:password).on(:create) }
      it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(20) }
      it { is_expected.to validate_confirmation_of(:password) }
    end

    describe "have enum for role" do
      it { should define_enum_for(:role).with([:user, :admin]) }
    end

  end

  context "associations" do

    describe "4 associations with dependency" do
      it { is_expected.to have_many(:messages).dependent(:destroy)}
      it { is_expected.to have_many(:comments).dependent(:destroy)}
      it { is_expected.to have_many(:reports).dependent(:destroy)}
      it { is_expected.to have_many(:authentications).dependent(:destroy)}
    end

  end

  context "creations" do
    
    # happy_path
    describe "created when all attributes are present" do
      When(:user) { User.create(
        email: "testing@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      )}
      Then { user.valid? === true }
    end
    
    describe "can create without a password confirmation" do
      When(:user) { User.create(
        email: "testing@gmail.com",
        password: "123456"
      )}
      Then { user.valid? == true }
    end

    # unhappy_path
    describe "cannot create without a email" do
      When(:user) { User.create(
        password: "123456",
        password_confirmation: "123456"
      )}
      Then { user.valid? === false }
    end

    describe "cannot create without a password" do
      When(:user) { User.create(
        email: "testing@gmail.com"
      )}
      Then { user.valid? == false }
    end

    describe "permit valid email only" do
      let(:user1) { User.create(
        email: "testing@gmail.com", password: "123456", password_confirmation: "123456"
      )}
      let(:user2) { User.create(
        email: "text.com", password: "123456", password_confirmation: "123456"
      )}

      # happy_path
      it "sign up with valid email" do
        expect(user1).to be_valid
      end

      # unhappy_path
      it "sign up with invalid email" do
        expect(user2).to be_invalid
      end
    end

    describe "permit enough length password only" do
      let(:user1) { User.create(
        email: "testing@gmail.com", password: "123456", password_confirmation: "123456"
      )}
      let(:user2) { User.create(
        email: "text.com", password: "123", password_confirmation: "123"
      )}

      # happy_path
      it "sign up with valid email" do
        expect(user1).to be_valid
      end

      # unhappy_path
      it "sign up with invalid email" do
        expect(user2).to be_invalid
      end
    end
  end

end