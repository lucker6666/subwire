class HomeController < ApplicationController
  # User have to be logged in
	before_filter :require_login

	def index
	end
end