class ApplicationController < ActionController::API
        def authenticate_request!
          if !payload || !JsonWebToken.valid_payload(payload)
            return invalid_authentication
          end
      
          @current_user = User.find_by(id: payload['sub'])
          invalid_authentication unless @current_user
        end
      
        private
      
        def invalid_authentication
          render json: { error: 'Invalid Request' }, status: :unauthorized
        end
      
        def payload
          JsonWebToken.decode(http_auth_header)
        rescue JWT::DecodeError
          nil
        end
      
        def http_auth_header
          if request.headers['Authorization'].present?
            return request.headers['Authorization'].split(' ').last
          end
          nil
        end
   
      
end
