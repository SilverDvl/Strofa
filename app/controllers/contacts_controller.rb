class ContactsController < ApplicationController
  def create
    @page = Contact.create!(email: params[:email])
    redirect_to promo_path
  end

  def success
    @page = Page.find_by!(slug: "success")
  end
end
