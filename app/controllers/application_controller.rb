class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def valid_url?(uri)
    begin
      uri = URI.parse(uri)
      uri.host.present?
    rescue
      false
    end
  end
end
