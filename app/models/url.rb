class Url < ActiveRecord::Base
  def shorten!
    self.shortened = full
  end
end
