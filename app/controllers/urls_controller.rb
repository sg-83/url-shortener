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
    if valid_url?(params["url"])
      @url = Url.new(full: params["url"])
      @url.shorten!
      @url.save

      byebug

      ScrapeUrlForTitleJob.perform_later(@url.id)

      respond_to do |format|
        format.html
        format.json { render json: @url }
      end
    else
      logger.error('Invalid Url')
      respond_to do |format|
        format.html { redirect_to :root }
        format.json { render json: {error: "Invalid Url"}}
      end
    end
  end

  def show
  # Find short url, redirect to full URL
    redirect_to 'https://www.google.com' and return
  end
end
