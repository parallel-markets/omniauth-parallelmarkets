# frozen_string_literal: true

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class ParallelMarkets < OmniAuth::Strategies::OAuth2
      option :client_options,
             site: 'https://api.parallelmarkets.com',
             authorize_url: '/v1/oauth/authorize',
             token_url: '/v1/oauth/token'

      uid { raw_info['id'] }

      info do
        {
          name: profile['name'] || "#{profile['first_name']} #{profile['last_name']}",
          first_name: profile['first_name'],
          last_name: profile['last_name'],
          email: profile['email']
        }
      end

      extra do
        {
          accreditations: raw_info['accreditations'],
          business_type: profile['business_type'],
          type: raw_info['type'],
          user_id: raw_info['user_id'],
          raw_info: raw_info
        }
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            params[v.to_sym] = request.params[v] if request.params[v]
          end
        end
      end

      def raw_info
        @raw_info ||= access_token.get('/v1/me').parsed
      end

      def profile
        @profile ||= raw_info.fetch('profile', {})
      end
    end
  end
end

OmniAuth.config.add_camelization 'parallelmarkets', 'ParallelMarkets'
