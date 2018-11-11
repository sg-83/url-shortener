class ScrapeUrlForTitleJob < ActiveJob::Base
  queue_as :default

  def perform(url_id)
    url = Url.find(url_id)

    begin
      scrape = HTTParty.get(url.full)
    rescue
      logger.error('Scraping Failed')
      return
    end

    if scrape.success?
      title = Nokogiri::HTML(scrape.body).css('title').text
      url.title = title
      url.save
      logger.info("Ran Job, parsed title as #{title}")
    else
      logger.error('Parsing Failed')
    end
  end
end
