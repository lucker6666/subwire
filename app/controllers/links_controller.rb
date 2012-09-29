class LinksController < ApplicationController
  # User have to be logged in, choosed an channel and have to be allowed to see that channel
  # and have to be at least admin of that channel
  before_filter :authenticate_user!, :choose_channel!, :check_permissions, :restricted_to_admin

  # GET /links
  def index
    @links = Link.find_all_by_channel_id_and_page(current_channel.id, params[:page])
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
    unless params[:link][:href].match /^(http|ftp|https):\/\//
      params[:link][:href] = 'http://' + params[:link][:href]
    end

    @link = Link.new(params[:link])
    @link.channel = current_channel

    if @link.save
      feedback t('links.created')
      redirect_to links_path
    else
      feedback t('links.not_created')
      render action: "new"
    end
  end

  # PUT /links/1
  def update
    unless params[:link][:href].match /^(http|ftp|https):\/\//
      params[:link][:href] = 'http://' + params[:link][:href]
    end

    @link = Link.find(params[:id])

    if @link.update_attributes(params[:link])
      feedback t('users.updated')
      redirect_to links_path
    else
      render action: "edit"
    end
  end

  # DELETE /links/1
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    redirect_to links_path
  end
end
