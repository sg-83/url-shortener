class ScrapeUrlForTitleJob < ActiveJob::Base
  queue_as :default

  def perform(url_id)
    url = Url.find(url_id)

    begin
      scrape = HTTParty.get(url.full)
    rescue
      logger.error('Scraping Failed')
      # If parsing the http request fails, let's set a status so
      # we know what went wrong. We can try to fix it later
      url.status = Url.statuses['network_error']
      return
    end

    if scrape.success?
      title = Nokogiri::HTML(scrape.body).css('title').text
      url.title = title
      url.status = Url.statuses['ok']
      url.save
      logger.info("Ran Job, parsed title as #{title}")
    else
      url.status = Url.statuses['parse_error']
      logger.error('Parsing Failed')
    end
  end
end
