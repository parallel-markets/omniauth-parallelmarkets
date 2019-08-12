[![Gem Version](https://badge.fury.io/rb/omniauth-parallelmarkets.svg)](https://badge.fury.io/rb/omniauth-parallelmarkets)
[![Build Status](https://travis-ci.org/parallel-markets/omniauth-parallelmarkets.svg?branch=master)](https://travis-ci.org/parallel-markets/omniauth-parallelmarkets)

# OmniAuth ParallelMarkets

This gem contains the [Parallel Markets](https://parallelmarkets.com) strategy for OmniAuth.

ParallelMarkets uses the OAuth2 flow, you can read about at [docs.parallelmarkets.com/api](https://docs.parallelmarkets.com/api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-parallelmarkets'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-parallelmarkets

## Usage

You'll need to register your application with [Parallel Markets Support](mailto:help@parallelmarkets.com) and get `client_id` & `client_secret`.

Here's an example for adding the middleware to a Rails app in config/initializers/omniauth.rb:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :parallelmarkets, ENV["CLIENT_ID"], ENV["CLIENT_SECRET"]
end
```

See the documentation for [OmniAuth](https://github.com/omniauth/omniauth) for more information on usage.

## Sample Auth Hash
```ruby
{
  "provider"=>"parallelmarkets",
  "uid"=>"123456",
  "info"=> {
    "name"=>"Snake Plissken",
    "email"=>"snake@example.com",
    "first_name"=>"Snake"
    "last_name"=>"Plissken"
  },
  "credentials"=> {
    "token"=>"parallel_access_token",
    "refresh_token"=>"parallel_refresh_token",
    "expires_at"=>1451681914,
    "expires"=>true
  },
  "extra"=> {
    "accreditations"=>[
      {
        "id"=>321,
        "status"=>"current",
        "expires_at"=>1565317542,
        "assertion_type"=>"income",
        "created_at"=>1565307542
      }
    ]
  }
}
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).