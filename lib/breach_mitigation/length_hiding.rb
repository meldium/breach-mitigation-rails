module BreachMitigation
  class LengthHiding
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      # Only pad HTML documents
      if headers['Content-Type'] =~ /text\/html/ && env['rack.url_scheme'] == 'https'
        # Copy the existing response to a new object
        response = Rack::Response.new(body, status, headers)

        # Append to that response
        response.write random_html_comment

        body.close if body.respond_to? :close
        response.finish
      else
        [status, headers, body]
      end
    end

    private

    # Append a comment from 0 to MAX_LENGTH bytes in size to the
    # response body. See section 3.1 of "BREACH: Reviving the CRIME
    # attack". This should make BREACH attacks take longer, but does
    # not fully protect against them. The longer MAX_LENGTH is, the
    # more effective the mitigation is, however longer lengths mean
    # more time spent in this middleware and more data on the wire.

    MAX_LENGTH = 2048
    ALPHABET = ('a'..'z').to_a

    def random_html_comment
      # The length of the padding should be strongly random, but the
      # data itself doesn't need to be strongly random; it just needs
      # to be resistant to compression
      length = SecureRandom.random_number(MAX_LENGTH)
      junk = (0...length).inject("") { |junk| junk << ALPHABET[rand(ALPHABET.size)] }

      "\n<!-- This is a random-length HTML comment: #{junk} -->".html_safe
    end
  end
end
