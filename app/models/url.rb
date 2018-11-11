class Url < ActiveRecord::Base
  def shorten!
    self.shortened = IdConverter.encode(self.id)
    self.save
  end

  def increment_clicks!
    self.clicks += 1
    self.save
  end
end
