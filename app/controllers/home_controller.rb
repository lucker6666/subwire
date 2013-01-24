class HomeController < ApplicationController
  # GET /
  def index
    if current_user
      unless current_channel
        set_current_channel Relationship.find_all_by_user_id(current_user.id).first.channel
      end

      redirect_to articles_path
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