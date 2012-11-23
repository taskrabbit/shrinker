# Shrinker

Replace all occurence of a domain and create a shortened link using a token.

## Installation

Add this line to your application's Gemfile:

    gem 'shrinker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shrinker

## Usage


    Shrinker.configure do
      backend 'Redis'
      backend_options client: {port: 6388, host: '192.168.12.22'}
      expanded_domain /www.google.com/
      shrinked_domain 'go.com'
    end

Not shrinking a link

    www.google.com?shrinker=false&something=else 

    would be replaced by www.google.com?something=else

Usage on a text:

    new_text = Shrinker::Parser::Text.replace(text, {:user_id => 123})

With a MIME:

    new_mime = Shrinker::Parser::MIME.replace(mime, {:user_id => 123})

Get back a real link:

    url = TaskRabbit::Shortener::Url.find(token)
    url.attributes[:user_id] # => 123

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
