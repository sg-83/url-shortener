class IncrementClicksForUrlJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    url = Url.find(id)
    url.increment_clicks!
  end
end
