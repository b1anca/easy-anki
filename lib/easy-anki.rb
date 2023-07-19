# frozen_string_literal: true

require "csv"
require "dotenv"
require "openai"

require_relative "easy_anki/version"

Dotenv.load

module EasyAnki
  class Error < StandardError; end

  class Configuration
    attr_accessor :openai_access_token, :openai_organization_id, :target_language

    def initialize
      @openai_access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
      @openai_organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
      @target_language = ENV.fetch("TARGET_LANGUAGE")
    end
  end

  class << self
    attr_writer :configuration, :openai_client
  end

  def self.configuration
    @configuration ||= EasyAnki::Configuration.new
  end

  def self.openai_client
    @openai_client ||= OpenAI::Client.new(access_token: configuration.openai_access_token,
                                          organization_id: configuration.openai_organization_id)
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

  def self.translations_and_definitions(words)
    message = "For each word, return the translations to #{configuration.target_language} and also definitions" \
              " (with examples). Include in the definitions idiom meanings. The response should ONLY contain a JSON" \
              " (root key data) with an array containing the keys text, translations (array), and definitions (array" \
              " of objects with text and example). Words array: #{words.to_json}"
    ai_message = chat(message)
    JSON.parse(ai_message, symbolize_names: true)[:data]
  end

  def self.parse_input_file(filename)
    file = File.read(filename)
    anki_file = filename.match?(/.txt$/)
    if anki_file
      puts "Parsing Anki file..."
      arr = CSV.parse(file, col_sep: "\t")
      puts "#{arr.count} words"
      arr.map { |a| { text: a.first } }
    else
      CSV.parse(file, headers: true, header_converters: :symbol).map(&:to_hash)
    end
  end

  def self.generate_flashcards(words)
    batch_size = 25
    batches = (words.count.to_f / batch_size).ceil
    words.each_slice(batch_size).with_index do |words_batch, index|
      words_batch = words_batch.map { |w| w[:text] }
      puts "Processing batch #{index + 1}/#{batches} ..."
      process_batch(words_batch)
    end
  end

  def self.process_batch(words_batch)
    ai_results = translations_and_definitions(words_batch)
    cards = create_anki_cards(ai_results)
    write_cards_to_file(cards)
  end

  def self.create_anki_cards(words)
    words.map do |note|
      definitions = note[:definitions].map do |d|
        d[:text] += "." if d[:text][-1] != "."
        "<li>#{d[:text]} <em>\"#{d[:example]}\"</em></li>"
      end
      back = "#{note[:translations].join(", ")}\n\n<ul>#{definitions.join}</ul>"
      { front: note[:text], back: back }
    end
  end

  def self.write_cards_to_file(cards)
    CSV.open("output_#{Date.today}.csv", "ab") do |csv|
      cards.each do |hash|
        csv << hash.values
      end
    end
  end
end
