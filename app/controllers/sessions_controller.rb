class SessionsController < ApplicationController
  # ================================================================================================
  # Display login form
  #
  #   - GET /login

  def new
    respond_to do |format|
      format.html { render 'new', layout: 'login' }
    end
  end


  # ================================================================================================
  # Creates new session
  #
  #   - POST /session

  def create
    user = User.find_by_login(params[:login])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      notify "Welcome back, #{user.name}"
      redirect_to '/'
    else
      notify 'Name/Password wrong. Try again'
      render 'new', layout: 'login'
    end
  end


  # ================================================================================================
  # Destroys session
  #
  #   - DELETE /logout

  def destroy
    notify "Good Bye, #{@current_user.login}"
    session[:user_id] = nil
    redirect_to '/'
  end
end
