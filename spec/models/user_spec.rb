require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

  describe "Associations" do
    it do
      should have_many(:comments)
      should have_many(:messages)
      should have_many(:availabilities)
      should have_many(:notifications)
      should have_many(:relationships)
      should have_many(:channels).through(:relationships)
    end
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:is_deleted) }
  end

  describe "Validation" do
    it do
      should validate_presence_of(:lang)
      should validate_presence_of(:timezone)
      should validate_presence_of(:email)
      should validate_presence_of(:password)

      should ensure_length_of(:password).is_at_least(5).is_at_most(32)

      should ensure_length_of(:name).is_at_least(3).is_at_most(30)

      should allow_value('Dr.Evil_58').for(:name)
      should_not allow_value('Dr.Ev!l_58').for(:name)

      should validate_uniqueness_of(:email)

      should allow_value('user@foo.com').for(:email)
      should allow_value('THE_USER@foo.bar.org').for(:email)
      should allow_value('first.last@foo.jp').for(:email)

      should_not allow_value('user@foo,com').for(:email)
      should_not allow_value('user_at_foo.org').for(:email)
      should_not allow_value('example.user@foo.').for(:email)

      should ensure_inclusion_of(:lang).in_array(['en', 'de'])
    end
  end

  describe "Respond to" do
    it do
      should respond_to(:is_admin_of_channel?)
      should respond_to(:channel_count)
      should respond_to(:login_status_by_time)
      should respond_to(:login_status)
      should respond_to(:may_create_new_channel?)
    end
  end

  describe "password validations" do
    it "should require a matching password confirmation" do
      user = FactoryGirl.create(:user)

      user.password_confirmation = 'invalid'
      user.should_not be_valid
    end
  end

  describe "login status" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.show_login_status = true
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
      @user.login_status_by_time(DateTime.parse('2012-09-19 06:04:00'), @user.name).should eq('#157f00')
    end

    it "should have online status none when show login status is on false" do
      @user.show_login_status = false
      @user.login_status('Example User').should eq('#000')
    end
  end
end
