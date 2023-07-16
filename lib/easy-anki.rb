# frozen_string_literal: true

require "dotenv"
require "openai"

require_relative "easy_anki/version"

Dotenv.load

module EasyAnki
  class Error < StandardError; end

  class Configuration
    attr_accessor :openai_access_token, :openai_organization_id

    def initialize
      @openai_access_token = ENV["OPENAI_ACCESS_TOKEN"]
      @openai_organization_id = ENV["OPENAI_ORGANIZATION_ID"]
    end
  end

  class << self
    attr_writer :configuration, :openai_client
  end

  def self.configuration
    @configuration ||= EasyAnki::Configuration.new
  end

  def self.openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def self.configure
    yield(configuration)
  end

  def self.chat(message)
    response = openai_client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: message }],
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
