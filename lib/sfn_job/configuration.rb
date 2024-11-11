# frozen_string_literal: true

module SfnJob
  class Configuration
    attr_accessor :region, :stub_sfn_client

    def initialize
      @stub_sfn_client = false
    end
  end
end
