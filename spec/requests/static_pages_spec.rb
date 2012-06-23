require 'spec_helper'

describe "StaticPages" do
  
  describe "Home page" do
    it "should have the content 'Sample App'" do
      page_has(root_path, "Sample App")
    end
    
    it "should not have a custom page title" do
      visit root_path
      page.should_not have_selector('title', text: '| Home')
    end
  end
  
  describe "Help page" do
    it "should have the content 'Help'" do
      page_has(help_path, "Help")
    end
  end
  
  describe "About page" do
  
    it "should have the content 'About Us'" do
      page_has(about_path, "About Us")
    end
  end
  
  describe "Contact page" do
    it "should have the content 'Contact Us'" do
      page_has(contact_path, "Contact Us")
    end
  end

end


def page_has(page_path, description)
     visit page_path
     page.should have_selector('h1', text: description)
     page.should have_selector('title', text: description)
end