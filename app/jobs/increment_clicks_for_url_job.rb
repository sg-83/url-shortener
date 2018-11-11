class IncrementClicksForUrlJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    url = Url.find(id)
    url.increment_clicks!
  end
end
