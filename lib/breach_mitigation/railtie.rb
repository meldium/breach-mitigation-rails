require 'breach_mitigation/length_hiding'

module BreachMitigation
  class Railtie < Rails::Railtie
    initializer "breach-mitigation-rails.insert_middleware" do |app|
      app.config.middleware.use "BreachMitigation::LengthHiding"
    end
  end
end
