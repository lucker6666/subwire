class LinksController < ApplicationController
  before_filter :load_channel
  before_filter :load_link, only: [:show, :edit, :update, :destory]
  before_filter :section


  # GET /channels/:id/links
  def index
    authorize! :read, Channel
    @links = Link.find_all_by_channel_id_and_page(@current_channel.id, params[:page])
  end


  # GET /channels/:id/links/1
  def show
  end


  # GET /channels/:id/links/new
  def new
    @link = Link.new
  end


  # GET /channels/:id/links/1/edit
  def edit
    authorize! :update, @link
  end


  # POST /links
  def create
    authorize! :create, Link

    unless params[:link][:href].match /^(http|ftp|https):\/\//
      params[:link][:href] = 'http://' + params[:link][:href]
    end

    @link = Link.new(params[:link])
    @link.channel = @current_channel

    if @link.save
      feedback t('links.created')
      redirect_to channel_links_path(@current_channel)
    else
      feedback t('links.not_created')
      render action: "new"
    end
  end


  # PUT /links/1
  def update
    authorize! :update, @link

    unless params[:link][:href].match /^(http|ftp|https):\/\//
      params[:link][:href] = 'http://' + params[:link][:href]
    end

    if @link.update_attributes(params[:link])
      feedback t('users.updated')
      redirect_to channel_links_path(@current_channel)
    else
      render action: "edit"
    end
  end


  # DELETE /links/1
  def destroy
    authorize! :destroy, @link

    @link.destroy
    redirect_to channel_links_path(@current_channel)
  end


  def move_position_up
    authorize! :update, @link

    @link.move_position_up!
    redirect_to channel_links_path(@current_channel)
  end


  def move_position_dn
    authorize! :update, @link

    @link.move_position_dn!
    redirect_to channel_links_path(@current_channel)
  end



  private

    def load_message
      @link = Link.find(params[:id])
      authorize! :read, @link
    end

    def section
      set_section :settings
    end
end
