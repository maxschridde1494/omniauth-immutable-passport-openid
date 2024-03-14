# frozen_string_literal: true

require 'omniauth'

module OmniAuth
  module Immutable
    module Strategies
      # Main class for Immutable Passport OmniAuth strategy.
      class PassportOpenId # < OmniAuth::Strategies::OAuth2
        include OmniAuth::Strategy

        option :name, 'immutable_passport'

        uid do
          raw_info.uid
        end

        info do
          email = raw_info.info.email
          nickname = raw_info.info.nickname
          name = raw_info.info.name || nickname || email

          { email: email, name: name }.tap { |h| h[:nickname] = nickname if nickname }
        end

        extra do
          {
            raw_info: raw_info
          }
        end

        def raw_info
          @raw_info ||= JSON.parse(request.body.read, object_class: OpenStruct).omniauth
        end
      end
    end
  end
end
