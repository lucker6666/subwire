class HomeController < ApplicationController
  ### Methods

  # GET /
  def index
    if current_user
      redirect_to channels_path
    else
      flash.keep
      redirect_to "/users/sign_in"
    end
  end

  def inactive
    flash.keep
    redirect_to "/"
  end

  def virgin
    render "virgin", layout: "empty"
  end

  def integration
    I18n.locale = params[:locale]

    if current_user
      render "logged_in", layout: "integration"
    else
      @user = User.new
      render "login", layout: "integration"
    end
  end
end