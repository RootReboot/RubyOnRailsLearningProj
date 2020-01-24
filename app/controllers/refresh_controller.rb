class RefreshController < ApplicationController
    before_action :authorize_access_request!

    def create
        session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_acess_allowed: true)
        tokens = session.refresh_by_acess_alowed do 
            raise JWTSessions::Errors::Unauthorized, "Something not right"
        end

        response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production?)

        render json: { crsf: tokens[:csrf]}
    end
end