# frozen_string_literal: true

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class ParallelMarkets < OmniAuth::Strategies::OAuth2
      option :client_options,
             site: 'https://api.parallelmarkets.com',
             authorize_url: '/v1/oauth/authorize',
             token_url: '/v1/oauth/token'
      option :authorize_options, %i[scope force_accreditation_check]

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
          accreditations: accreditations,
          indicated_unaccredited: indicated_unaccredited,
          business_type: profile['business_type'],
          primary_contact: profile['primary_contact'].nil? ? nil : {
            name: "#{profile['primary_contact']['first_name']} #{profile['primary_contact']['last_name']}",
            first_name: profile['primary_contact']['first_name'],
            last_name: profile['primary_contact']['last_name'],
            email: profile['primary_contact']['email']
          },
          type: raw_info['type'],
          user_id: raw_info['user_id'],
          raw_info: raw_info
        }
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] if request.params[k.to_s]
          end
        end
      end

      # this is dumb, but https://github.com/omniauth/omniauth-oauth2/issues/93 is still open
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= access_token.get('/v1/me').parsed
      end

      def profile
        @profile ||= raw_info.fetch('profile', {})
      end

      def raw_accreditations
        @raw_accreditations ||= access_token.get('/v1/accreditations').parsed
      end

      def indicated_unaccredited
        raw_accreditations['indicated_unaccredited']
      end

      def accreditations
        raw_accreditations['accreditations']
      end
    end
  end
end

OmniAuth.config.add_camelization 'parallelmarkets', 'ParallelMarkets'
