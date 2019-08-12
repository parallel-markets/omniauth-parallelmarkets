# OmniAuth ParallelMarkets

This gem contains the [Parallel Markets](https://parallelmarkets.com) strategy for OmniAuth.

ParallelMarkets uses the OAuth2 flow, you can read about at [docs.parallelmarkets.com/api](https://docs.parallelmarkets.com/api/).

## How To Use It

So let's say you're using Rails, you need to add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-parallelmarkets'
```

Once these are in, you need to add the following to your `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :parallelmarkets, YOUR_CUSTOMER_KEY, YOUR_CUSTOMER_SECRET
end
```

You will obviously have to put in your key and secret, which you get when you register your app with Parallel Markets.

Now just follow the README at: https://github.com/intridea/omniauth
