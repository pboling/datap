# frozen_string_literal: true

class PageViewsController < ApplicationController
  before_action :set_page_view, only: %i[show edit update destroy]

  # GET /page_views
  # GET /page_views.json
  def index
    @page_views = PageView.all
  end

  # GET /page_views/1
  # GET /page_views/1.json
  def show; end

  # GET /page_views/new
  def new
    @page_view = PageView.new
  end

  # GET /page_views/1/edit
  def edit; end

  # POST /page_views
  # POST /page_views.json
  def create
    @page_view = PageView.new(page_view_params)

    respond_to do |format|
      if @page_view.save
        format.html { redirect_to @page_view, notice: 'Page view was successfully created.' }
        format.json { render :show, status: :created, location: @page_view }
      else
        format.html { render :new }
        format.json { render json: @page_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_views/1
  # PATCH/PUT /page_views/1.json
  def update
    respond_to do |format|
      if @page_view.update(page_view_params)
        format.html { redirect_to @page_view, notice: 'Page view was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_view }
      else
        format.html { render :edit }
        format.json { render json: @page_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_views/1
  # DELETE /page_views/1.json
  def destroy
    @page_view.destroy
    respond_to do |format|
      format.html { redirect_to page_views_url, notice: 'Page view was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page_view
    @page_view = PageView.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_view_params
    params.require(:page_view).permit(:url, :referrer, :digest, :created_at)
  end
end
