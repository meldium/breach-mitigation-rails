module BreachMitigation
  class MaskingSecrets
    class << self
      AUTHENTICITY_TOKEN_LENGTH = 32

      # Sets the token value for the current session and returns it in
      # a masked form that's safe to send to the client. See section
      # 3.4 of "BREACH: Reviving the CRIME attack".
      def masked_authenticity_token(session)
        one_time_pad = SecureRandom.random_bytes(AUTHENTICITY_TOKEN_LENGTH)
        encrypted_csrf_token = xor_byte_strings(one_time_pad, real_csrf_token(session))
        masked_token = one_time_pad + encrypted_csrf_token
        Base64.strict_encode64(masked_token)
      end

      # Checks the client's masked token to see if it matches the
      # session token. Essentially the inverse of
      # +masked_authenticity_token+.
      def valid_authenticity_token?(session, encoded_masked_token)
        return false if encoded_masked_token.nil? || encoded_masked_token.empty?

        masked_token = Base64.strict_decode64(encoded_masked_token)

        return false if masked_token.length != AUTHENTICITY_TOKEN_LENGTH * 2

        # Split the token into the one-time pad and the encrypted
        # value and decrypt it
        one_time_pad = masked_token[0...AUTHENTICITY_TOKEN_LENGTH]
        encrypted_csrf_token = masked_token[AUTHENTICITY_TOKEN_LENGTH..-1]
        csrf_token = xor_byte_strings(one_time_pad, encrypted_csrf_token)

        csrf_token == real_csrf_token(session)
      end

      private

      def real_csrf_token(session)
        session[:_csrf_token] ||= SecureRandom.base64(AUTHENTICITY_TOKEN_LENGTH)
        Base64.strict_decode64(session[:_csrf_token])
      end

      def xor_byte_strings(s1, s2)
        s1.bytes.zip(s2.bytes).map { |(c1,c2)| c1 ^ c2 }.pack('c*')
      end
    end
  end
end
