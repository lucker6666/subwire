class HomeController < ApplicationController
  # GET /
  def index
    if current_user
      if current_channel
        redirect_to articles_path
      else
        redirect_to channels_path
      end
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