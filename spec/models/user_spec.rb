require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
  end

  it "should create a new channel given a valid attribute" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(email: ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(email: address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(email: address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(email: upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(password: "", password_confirmation: "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(password_confirmation: "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "aa"
      hash = @attr.merge(password: short, password_confirmation: short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe "login status" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have online status" do
      @user.last_activity = DateTime.parse('2012-09-19 06:00:00')
      @user.login_status_by_time(DateTime.parse('2012-09-19 06:03:00'), 'username').should eq('#157f00')
    end

    it "should have offline status" do
      @user.last_activity = DateTime.parse('2012-09-19 06:00:00')
      @user.login_status_by_time(DateTime.parse('2012-09-19 06:04:00'), 'username').should eq('#cc0022')
    end

    it "should have online status always when user see himself" do
      @user.last_activity = DateTime.parse('2012-09-19 06:00:00')
      @user.login_status_by_time(DateTime.parse('2012-09-19 06:04:00'), 'Example User').should eq('#157f00')
    end

    it "should have online status none when show login status is on false" do
      @user.show_login_status = false
      @user.login_status('Example User').should eq('#000')
    end

  end

end