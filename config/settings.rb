# frozen_string_literal: true

module BentoHanami
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool
    setting :summon_authcode, constructor: Types::String
  end
end
