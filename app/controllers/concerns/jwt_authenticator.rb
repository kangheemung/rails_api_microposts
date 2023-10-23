module JwtAuthenticator
    require 'jwt'
    require 'dotenv/load'
    def encode(user_id)
        expires_in = 1.hour.from_now.to_i
        payload = {user_id: user_id, exp: expires_in}
        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    end

    def decode(token)
        decode_jwt = JWT.decode(token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
        decode_jwt.first
    end
    def authenticate_request(request)
        token = extract_token_from_request(request)
        return nil unless token
    
        begin
          decoded_token = decode(token)
          user_id = decoded_token['user_id']
          User.find(user_id)
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
          nil
        end
      end
    
      private
      
      def extract_token_from_request(request)
        auth_header = request.headers['Authorization']
        token = auth_header&.split(' ')&.last
      end
end