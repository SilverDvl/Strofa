class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    admin_user = AdminUser.find_by(email: params[:email])

    if admin_user&.authenticate(params[:password])
      session[:admin_user_id] = admin_user.id
      redirect_to admin_root_path
    else
      # flash.now[:alert] = 'Invalid username or password'
      render :new
    end
  end

  def destroy
    session[:admin_user_id] = nil
    redirect_to root_path
  end
end
