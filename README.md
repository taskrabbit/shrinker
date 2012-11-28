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


```ruby
Shrinker.configure do
  backend 'Redis'
  backend_options client: {port: 6388, host: '192.168.12.22'}
  expanded_domain /(www.)?google.com/ # this also works with protocol
  exclude_path /assets|images/
  anchors\_only\_in_html true         # With the mime only replace the links inside an anchor
  shrinked_domain 'go.com'
end
```

Not shrinking a link `www.google.com?shrinker=false&something=else` would be replaced by `www.google.com?something=else`.

Usage on a text:

```ruby

text = <<-EV
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
  Nunc quis rutrum http://www.google.com?something=true&else=false dolor. 
  Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
  Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
  Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
  http://google.com/somepath?something=true
  Aenean placerat ullamcorper lorem vel feugiat.
EV


new_text = Shrinker::Parser::Text.replace(text, {:user_id => 123})

new_text # => 
# Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
# Nunc quis rutrum http://go.com/token1 dolor. 
# Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
# Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
# Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
# http://go.com/token2
# Aenean placerat ullamcorper lorem vel feugiat.

```

With a MIME:

```ruby
new_mime = Shrinker::Parser::Mime.replace(mime, {:user_id => 123})
```

Get back a real link:

```ruby
url = Shrinker::unshrink(token)
url.to_s # => 'http://google.com/something=true'
url.attributes['user_id'] # => 123
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
