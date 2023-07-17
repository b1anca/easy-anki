# Easy Anki

Generate your Anki flashcards from your exported Anki `.txt` data, from `.csv` or directly from an array of words.
Translates words and gives English definitions to boost your vocabulary!

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

You can either create a `.env` file and add your credentials, the default values will be fetched from this file, or configure the gem, for example in an initializer file.

```rb
EasyAnki.configure do |config|
  config.openai_access_token = ENV["OPENAI_ACCESS_TOKEN"]
  config.openai_organization_id = ENV["OPENAI_ORGANIZATION_ID"]
  config.translation_language = ENV["TRANSLATION_LANGUAGE"]
end
```

## Usage

```rb
words = [{ text: "rambling" }, { text: "beckoned" }] # Array of word hashes with key :text
words = EasyAnki.parse_input_file('csv-input.csv') # Parse CSV input file; expected format: one word per row under column 'text'
words = EasyAnki.parse_input_file('anki-input.txt') # Parse exported Anki data
EasyAnki.generate_flashcards(words) # Generate a CSV file suitable for import into Anki using the provided words
```

<!-- TODO: keep context -->

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/b1anca/easy-anki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/b1anca/easy-anki/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EasyAnki project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/b1anca/easy-anki/blob/master/CODE_OF_CONDUCT.md).
