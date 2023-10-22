module JwtAuthenticator
    require 'jwt'
    def encode(user_id)
        expires_in = 1.hour.from_now.to_i
        payload = {user_id: user_id, exp: expires_in}
        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    end

    def decode(token)
        decode_jwt = JWT.decode(token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
        decode_jwt.first
    end
end