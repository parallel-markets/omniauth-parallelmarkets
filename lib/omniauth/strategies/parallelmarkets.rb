# frozen_string_literal: true

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class ParallelMarkets < OmniAuth::Strategies::OAuth2
      option :client_options,
             site: 'https://api.parallelmarkets.com',
             authorize_url: '/v1/oauth/authorize',
             token_url: '/v1/oauth/token'
      option :authorize_options, %i[scope force_accreditation_check force_identity_check identity_claim_override_id]

      uid { raw_info['id'] }

      info { to_contact_details(profile) }

      extra do
        {
          authorize_scopes: authorize_scopes,
          # from /api/v1/me
          business_type: profile['business_type'],
          primary_contact: to_contact_details(profile['primary_contact']),
          raw_info: raw_info,
          type: raw_info['type'],
          user_id: raw_info['user_id'],
          user_profile: to_contact_details(user_profile),
          user_providing_for: raw_info['user_providing_for'],
          # from /api/v1/accreditations
          accreditations: accreditations,
          indicated_unaccredited: raw_accreditations['indicated_unaccredited'],
          # from /api/v1/identity
          identity_details: identity_details
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

      def scope?(single_scope)
        authorize_scopes.include?(single_scope.to_s)
      end

      # if given ?scope query parameter, use that. otherwise, use server-side provider configuration
      def authorize_scopes
        @authorize_scopes ||= (env['omniauth.params']['scope'] || authorize_params['scope']).split(' ')
      end

      def raw_info
        @raw_info ||= scope?(:profile) ? access_token.get('/v1/me').parsed : {}
      end

      def profile
        @profile ||= raw_info.fetch('profile', {})
      end

      def user_profile
        @user_profile ||= raw_info.fetch('user_profile', {})
      end

      def raw_accreditations
        @raw_accreditations ||= scope?(:accreditation_status) ? access_token.get('/v1/accreditations').parsed : {}
      end

      def accreditations
        @accreditations ||= raw_accreditations.fetch('accreditations', [])
      end

      def raw_identity
        @raw_identity ||= scope?(:identity) ? access_token.get('/v1/identity').parsed : {}
      end

      def identity_details
        @identity_details ||= raw_identity['identity_details']
      end

      def to_contact_details(contact)
        (contact.nil? || contact.empty?) ? {} : {
          name: contact['name'] || "#{contact['first_name']} #{contact['last_name']}",
          first_name: contact['first_name'],
          last_name: contact['last_name'],
          email: contact['email']
        }
      end
    end
  end
end

OmniAuth.config.add_camelization 'parallelmarkets', 'ParallelMarkets'
