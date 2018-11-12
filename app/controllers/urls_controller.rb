class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # Show top 100 URLS that have successfully been parsed.
    @urls = Url.all
               .order(clicks: :desc)
               .where.not(title: nil)
               .limit(100)

    respond_to do |format|
      format.html
      format.json { render json: @urls.map{ |url| {title: url.title, url: url.shortened} }.to_json }
    end
  end

  def new
  # Form to create new short URLS
  end

  def create
  # Generate Short URL, persist it to DB and queue up scrape job
    if valid_url?(params["url"])
      @url = Url.new(full: params["url"])
      @url.save
      @url.shorten!

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
    id = IdConverter.decode(params["id"])
    url = Url.find(id)
    IncrementClicksForUrlJob.perform_later(id)
    redirect_to url.full and return
  end
end
