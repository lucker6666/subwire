require 'spec_helper'

describe Comment do
  describe "Associations" do
    it { should belong_to(:article) }
    it { should belong_to(:user) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:content) }
  end

  describe :newest_comments do
    before do
      @article = FactoryGirl.create(:channel).articles.first
    end

    it "sould return all comments of that article" do
      @article.newest_comments.should eq(Comment.newest.find_all_by_article_id(@article.id))
    end
  end
end