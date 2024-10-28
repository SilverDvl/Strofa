require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should create contact" do
    post contacts_path, params: { email: "test@email.com" }

    assert_response :redirect

    contact = Contact.find_by!(email: "test@email.com")
    assert contact.persisted?
  end
end
