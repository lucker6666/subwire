class PagesController < ApplicationController
  before_filter :load_page, only: [:show, :edit, :update, :destory]
  before_filter :section



  # GET /channels/:id/wiki
  def index
    @pages = Page.all
  end


  # GET /channels/:id/wiki/:id
  def show
  end


  # GET /channels/:id/wiki/new
  def new
    @page = Page.new
  end


  # GET /channels/:id/wiki/:id/edit
  def edit
  end


  # POST /channels/:id/wiki
  def create
    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render action: "new"
    end
  end


  # PUT /channels/:id/wiki/:id
  def update
    if @page.update_attributes(params[:page])
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render action: "edit"
    end
  end


  # DELETE /channels/:id/wiki/:id
  def destroy
    @page.destroy
    redirect_to pages_url
  end


  private

    def load_page
      @page = Page.find(params[:id])
      authorize! :read, @page
    end

    def section
      set_section :wiki
    end
end
