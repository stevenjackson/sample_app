require 'spec_helper'

describe "StaticPages" do
  
  describe "Home page" do
    it "should have the content 'Sample App'" do
      page_has("home", "Sample App")
    end
  end
  
  describe "Help page" do
    it "should have the content 'Help'" do
      page_has("help", "Help")
    end
  end
  
  describe "About page" do
  
    it "should have the content 'About Us'" do
      page_has("about", "About Us")
    end
  end
  
  describe "Contact page" do
    it "should have the content 'Contact Us'" do
      page_has("contact", "Contact Us")
    end
  end

end


def page_has(page_name, description)
     visit "/static_pages/#{page_name}"
     page.should have_selector('h1', :text => description)
     page.should have_selector('title', :text => description)
end