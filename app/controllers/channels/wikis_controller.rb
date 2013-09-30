class Channels::WikisController < ApplicationController
  before_filter :load_wiki, only: [:show, :edit, :update, :destroy]
  before_filter :section


  # GET /channels/:id/wiki
  def index
    authorize! :read, current_channel
    @wikis = Wiki.where(channel_id: current_channel.id)
  end


  # GET /channels/:id/wiki/:id
  def show
  end


  # GET /channels/:id/wiki/new
  def new
    authorize! :create, Wiki
    @wiki = Wiki.new
  end


  # GET /channels/:id/wiki/:id/edit
  def edit
    authorize! :update, @wiki
  end


  # POST /channels/:id/wiki
  def create
    authorize! :create, @wiki

    @wiki = Wiki.new(params[:wiki])
    @wiki.channel = current_channel
    @wiki.user = current_user

    if @wiki.save
      redirect_to channel_wiki_path(current_channel, @wiki), notice: t('wiki.added')
    else
      render action: "new"
    end
  end


  # PUT /channels/:id/wiki/:id
  def update
    authorize! :update, @wiki

    if @wiki.update_attributes(params[:wiki])
      redirect_to channel_wiki_path(current_channel, @wiki), notice: t('wiki.updated')
    else
      render action: 'edit'
    end
  end


  # DELETE /channels/:id/wiki/:id
  def destroy
    authorize! :destroy, @wiki

    @wiki.destroy
    redirect_to wikis_url
  end


  # GET /channels/:id/wiki/home
  def home
    authorize! :read, current_channel
    @wiki = Wiki.where(is_home: true, channel_id: current_channel.id).first
    render 'show'
  end


  private

    def load_wiki
      @wiki = Wiki.find(params[:id])
      authorize! :read, @wiki
    end

    def section
      set_section :wiki
    end
end
