# Easy Anki

Fetch translations and definitions using ChatGPT and generate your Anki flashcards from an array of words, a `.csv` or your exported `.txt` Anki deck.

[![Gem Version](https://badge.fury.io/rb/easy-anki.svg)](https://badge.fury.io/rb/easy-anki)

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
$ bundle add easy-anki
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
$ gem install easy-anki
```

## Configuration

Get your API key and organization ID from https://platform.openai.com/account/api-keys

You can either create a `.env` from the `.env_sample` file and add your credentials, the default values will be fetched from this file, or configure the gem, for example in an initializer file.

```rb
EasyAnki.configure do |config|
  config.openai_access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.openai_organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
  config.target_language = ENV.fetch("TARGET_LANGUAGE")
end
```

## Usage

```rb
words = [{ text: "rambling" }, { text: "beckoned", context: "something else to add to the flashcard" }] # or
words = EasyAnki.parse_input_file('csv-input.csv') # or an exported .txt file from Anki
EasyAnki.generate_flashcards(words) # generate CSV file to import to Anki
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/b1anca/easy-anki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/b1anca/easy-anki/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EasyAnki project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/b1anca/easy-anki/blob/master/CODE_OF_CONDUCT.md).
