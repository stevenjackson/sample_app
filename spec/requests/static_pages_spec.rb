require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home page" do
    it { page_has_content(root_path, "Sample App") }
    it { does_not_have_content(root_path, 'Home') }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) } 
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      
      it "should render the user's feed" do
        user.feed.each do | item |
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      
      it "user's feed should have delete links" do
        page.should have_link "delete"
      end
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
        
      end
      
    end
    
  end
  
  describe "Help page" do
    it { page_has_content(help_path, "Help") }
  end
  
  describe "About page" do
    it { page_has_content(about_path, "About Us") }
  end
  
  describe "Contact page" do
    it { page_has_content(contact_path, "Contact Us") }
  end

  describe "Check links" do
    before { visit root_path }
    it { links_to("About", 'About Us') }
    it { links_to("Help", 'Help') }
    it { links_to("Contact", 'Contact') }
    it { links_to("Home", 'Sample App') }
    it { links_to("Sign up now!", 'Sign up') }
    it { links_to("sample app", 'Sample App') }    
  end

end


def page_has_content(page_path, description)
     visit page_path
     has_content(description)
end

def has_content(description)
     page.should have_selector('h1', text: description)
     page.should have_selector('title', text: description)
end

def does_not_have_content(page_path, description)
     visit page_path
     page.should_not have_selector('h1', text: description)
     page.should_not have_selector('title', text: description)
end

def links_to (link, content)
  click_link link
  has_content(content)
end
