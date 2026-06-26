# Cross-Origin Resource Sharing (CORS) configuration.
# Allows the Next.js frontend (localhost:3000) to make cross-origin requests.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:3000", "https://ai-travel-planner.rictaworks.jp"

    resource "*",
      headers:     :any,
      methods:     [:get, :post, :put, :patch, :options, :head],
      credentials: true
  end
end
