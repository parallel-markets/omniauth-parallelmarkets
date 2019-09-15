# frozen_string_literal: true

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class ParallelMarkets < OmniAuth::Strategies::OAuth2
      option :client_options,
             site: 'https://api.parallelmarkets.com',
             authorize_url: '/v1/oauth/authorize',
             token_url: '/v1/oauth/token'

      uid { raw_info['uid'] }

      info do
        {
          name: raw_info['name'] || "#{raw_info['first_name']} #{raw_info['last_name']}",
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name'],
          email: raw_info['email']
        }
      end

      extra do
        {
          accreditations: raw_info['accreditations'],
          type: raw_info['type'],
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
    end
  end
end

OmniAuth.config.add_camelization 'parallelmarkets', 'ParallelMarkets'
