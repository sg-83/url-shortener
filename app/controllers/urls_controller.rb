class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # Show top 100 URLS that have successfully been parsed and a title set.
    @urls = Url.all
               .order(clicks: :desc)
               .where.not(title: nil)
               .limit(100)

    render json: @urls.map { |u| { title: u.title, url: u.shortened_url } }.to_json
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
      render json: {shortened_link: @url.shortened_url }
    else
      logger.error('Invalid Url')
      render json: { error: "Failed to shorten URL" }
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
