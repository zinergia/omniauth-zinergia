require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Zinergia < OmniAuth::Strategies::OAuth2
      option :name, :zinergia

      option :client_options, {
        :site => "http://zin-auth.herokuapp.com",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          email: raw_info["email"],
          name:  raw_info["name"],
          role:  raw_info["role"],
          admin: raw_info["admin"],
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get(profile_info_path).parsed
      end

      private

      def profile_info_path
        "/api/user"
      end
    end
  end
end
