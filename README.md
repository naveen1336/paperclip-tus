# paperclip-tus

[![Build Status](https://travis-ci.org/deees/paperclip-tus.svg?branch=master)](https://travis-ci.org/deees/paperclip-tus)

paperclip-tus is paperclip io adapter for [tus-ruby-server](https://github.com/janko-m/tus-ruby-server).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paperclip-tus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip-tus

## Usage

First, make sure you [configure tus ruby server](https://github.com/janko-m/tus-ruby-server/blob/master/README.md#usage) correctly.
Only `Tus::Storage::Filesystem` storage is supported at the moment.

Then, you need [tus-js-client](https://github.com/tus/tus-js-client). Set it up similar to [this example](https://github.com/tus/tus-js-client/blob/master/README.md#example).
It's recommended to add `metadata` to `tus.Upload` `options` (to make sure names of uploaded files can be retrieved by the adapter):
```
var upload = new tus.Upload(file, {
      endpoint: ...,
      metadata: { filename: file.name },
      ...
```

Next, in `onSuccess` callback, you should extract file uid and submit it as `has_attached_file` attribute.
Uid can be extracted from url:
```
var upload = new tus.Upload(file, {
  ...
  onSuccess: function() {
    var url_parts = upload.url.split('/')
    # get last part of url
    var uid = url_parts[url_parts.length - 1]
    ... [assign uid to attachment attribute]..
  }
  ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install:local`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deees/paperclip-tus.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

