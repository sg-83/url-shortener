class Url < ActiveRecord::Base
  enum status: {
    ok: 0,
    parse_error: 1,
    network_error: 2
  }

  def shorten!
    self.shortened = IdConverter.encode(self.id)
    self.save
  end

  def shortened_url
    SITE_ROOT + '/' + shortened
  end

  def increment_clicks!
    self.clicks += 1
    self.save
  end
end
