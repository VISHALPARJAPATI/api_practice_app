# lib/middleware/verify_token.rb

module Middleware
    class Authentication
      
      def initialize(app)
        @app = app
      end
    
      def call(env)
        token = extract_token(env)

        if token && !token_revoked?(token)
            decoded_token = decode_and_verify_token(token)
            if decoded_token
                user_id = decoded_token[0]["user_id"]
                if user_id && (user = User.find_by(id: user_id))
                  env["current_user"] = user
                end
            end
        end
    
        @app.call(env)
      end

      # Extracts the JWT encoded token from the request header.
      # Note: This method is made public because it's used in UsersController.
      def extract_token(env)
        authorization_header = env["HTTP_AUTHORIZATION"]
        return nil unless authorization_header

        token = authorization_header.split(' ').last
        token if token.present?
      end

      private 

      # decode that token
      def decode_and_verify_token(token)
        hmac_secret = Rails.application.secrets.secret_key_base
        begin
            decoded_token = JWT.decode(token, hmac_secret, true, algorithm: 'HS256')
        rescue JWT::DecodeError, JWT::ExpiredSignature
            nil
        end
      end

      # this method tells, did we've revoked the token or not
      def token_revoked?(token)
        RevokedToken.exists?(token: token)
      end
    end
end