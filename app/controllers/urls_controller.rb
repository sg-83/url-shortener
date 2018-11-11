class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  # Show top 100 URLS
  end

  def new
  # Form to create new short URLS
  end

  def create
  # Generate Short URL, persist it to DB and queue up scrape job
    @short_url = "/testing"
    respond_to do |format|
      format.html
      format.json { render json: @short_url }
    end
  end

  def show
  # Find short url, redirect to full URL
    redirect_to 'https://www.google.com' and return
  end
end
