# Cookie-based session store configuration.
# The owner_session_id is embedded in a signed cookie for tamper protection.
Rails.application.config.session_store :cookie_store,
  key:      "_ai_travel_session",
  httponly: true,
  same_site: :lax
