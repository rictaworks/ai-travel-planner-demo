class ApplicationController < ActionController::API
  include ActionController::Cookies

  private

  # Retrieve or generate a stable session ID from cookies.
  def current_session_id
    unless cookies.signed[:owner_session_id].present?
      cookies.signed[:owner_session_id] = {
        value:     SecureRandom.uuid,
        httponly:  true,
        same_site: :lax
      }
    end
    cookies.signed[:owner_session_id]
  end
end
