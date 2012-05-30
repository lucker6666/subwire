class LinksController < ApplicationController
  before_filter :authenticate_user!, :choose_instance!
  before_filter :check_admin

  # GET /links
  def index
    @links = Link.find_all_by_instance_id(current_instance.id)
  end

  # GET /links/1
  def show
    @link = Link.find(params[:id])
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  def create
    @link = Link.new(params[:link])
    @link.instance = current_instance

    if @link.save
      notify t('links.created')
			redirect_to links_path
    else
    	notify t('links.not_created')
      render action: "new"
    end
  end

  # PUT /links/1
  def update
    @link = Link.find(params[:id])

    if @link.update_attributes(params[:link])
    	notify t('users.updated')
      redirect_to link_path(@link)
    else
      render action: "edit"
    end
  end

  # DELETE /links/1
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    redirect_to links_url
  end
end
