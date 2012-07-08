require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    
    describe "invalid signin" do
      before { click_button "Sign in" }
      
      it { should have_selector('title', text: 'Sign in') }
      it {should have_selector('div.alert.alert-error', text: 'Invalid') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
      
    end
    
    describe "valid signin" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      it { should have_selector('title', text: user.name) }
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Settings') }
      end
      
    end
    
  end
end
  
describe "authorization" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  
  describe "visiting the edit page" do
    before { visit edit_user_path(user) }
    it { should have_selector('title', text: 'Sign in') }
  end
  
  describe "submitting to the update action" do
    before { put user_path(user) }
    specify { response.should redirect_to(signin_path) }
  end
  
  describe "as wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
    before { sign_in user }
    
    describe "visiting other user's edit page" do
      before { visit edit_user_path(wrong_user) }
      it { should_not have_selector('title', text: "Edit user") }
    end
    
    describe "submitting a PUT request to the Users#update action" do
      before { put user_path(wrong_user) }
      specify { response.should redirect_to(root_path) }
    end
  end
  
  describe "as non-signed in user" do
    before { visit edit_user_path(user) }
    describe "after signing in it should render the desired protected page" do
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it { should have_selector('title', text: 'Edit user') }
    end
    
    describe "visiting the user index" do
      before { visit users_path }
      it { should have_selector('title', text: 'Sign in') }
    end
    
    describe "visiting the following page" do
      before { visit following_user_path(user) }
      it { should have_selector('title', text: 'Sign in') }
    end

    describe "visiting the followers page" do
      before { visit followers_user_path(user) }
      it { should have_selector('title', text: 'Sign in') }
    end
    
  end
  
  describe "as non-admin user try and submit a DELETE User request" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }
    
    describe "before sign-in" do
      before { delete user_path(user) }
      specify { response.should redirect_to(signin_path) }
    end
    
    describe "after sign-in" do
    
      before do
        sign_in non_admin
        delete user_path(user)
      end
    
      specify { response.should redirect_to(root_path) }
    end
  end
  
  describe "as an admin try to DELETE self" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    it "should not work" do
      expect { delete user_path(admin) }.to change(User, :count).by(0)
    end
    
  end
  
  describe "require sign in when modifying microposts" do
  
    let(:user) { FactoryGirl.create(:user) }

    describe "using create action" do
      before { post microposts_path }
      specify { response.should redirect_to(signin_path) }
    end
    
    describe "using delete action" do
      before { delete micropost_path(FactoryGirl.create(:micropost)) }
      specify { response.should redirect_to(signin_path) }
    end
  
  end
  
  describe "require sign in when modifying relationships" do
  
    let(:user) { FactoryGirl.create(:user) }

    describe "using create action" do
      before { post relationships_path }
      specify { response.should redirect_to(signin_path) }
    end
    
    describe "using delete action" do
      before { delete relationship_path(1) }
      specify { response.should redirect_to(signin_path) }
    end
  
  end
  
  
  
end #authorization