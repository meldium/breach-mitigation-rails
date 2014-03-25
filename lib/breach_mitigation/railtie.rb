require 'breach_mitigation/masking_secrets'

module BreachMitigation
  class Railtie < Rails::Railtie
    initializer "breach-mitigation-rails.insert_middleware" do |app|
      if !app.config.respond_to?(:exclude_breach_length_hiding) || !app.config.exclude_breach_length_hiding
        require 'breach_mitigation/length_hiding'
        if Rails.version.include?("3.0.")
          app.config.middleware.use "BreachMitigation::LengthHiding"
        else
          app.config.middleware.insert_before "Rack::ETag", "BreachMitigation::LengthHiding"
        end
      end
    end
  end
end

# Monkey-patch ActionController::RequestForgeryProtection to use
# masked CSRF tokens
module ActionController
  module RequestForgeryProtection
    protected

    def verified_request?
      !protect_against_forgery? || request.get? || request.head? ||
        BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, params[request_forgery_protection_token]) ||
        BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
    end

    def form_authenticity_token
      BreachMitigation::MaskingSecrets.masked_authenticity_token(session)
    end
  end
end
