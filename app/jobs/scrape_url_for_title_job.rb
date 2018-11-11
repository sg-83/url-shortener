class ScrapeUrlForTitleJob < ActiveJob::Base
  queue_as :default

  def perform(full_url)
    begin
      scrape = HTTParty.get(full_url)
    rescue
      logger.error('Scraping Failed')
      return
    end

    if scrape.success?
      byebug
      title = Nokogiri::HTML(scrape.body).css('title').text
      logger.info("Ran Job, parsed title as #{title}")
    else
      logger.error('Parsing Failed')
    end
  end
end
