require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home page" do
    it { has_content(root_path, "Sample App") }
    it { does_not_have_content(root_path, 'Home') }
  end
  
  describe "Help page" do
    it { has_content(help_path, "Help") }
  end
  
  describe "About page" do
    it { has_content(about_path, "About Us") }
  end
  
  describe "Contact page" do
    it { has_content(contact_path, "Contact Us") }
  end

end


def has_content(page_path, description)
     visit page_path
     page.should have_selector('h1', text: description)
     page.should have_selector('title', text: description)
end

def does_not_have_content(page_path, description)
     visit page_path
     page.should_not have_selector('h1', text: description)
     page.should_not have_selector('title', text: description)
end